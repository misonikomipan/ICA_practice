clc;clear;

step = 0.5; %ステップサイズ
rep = 20;   %反復回数

[data1_vec,Fs]=audioread("combined_speech1.wav");
[data2_vec,~]=audioread("combined_speech2.wav");
data_mat = [data1_vec.';data2_vec.'];

[num_channel,num_data] = size(data_mat);  %num_dataは測定点の数

I_mat = eye(2,2);
W_mat = eye(2,2);
distance_vec = 1:rep; %値は関係ないサイズが大切

for i = 1:rep
    E_mat = zeros(2);
    for t = 1:num_data
        y_vec = W_mat*data_mat(:,t);
        p_vec = func_dif_laplace(y_vec);
        R = p_vec*y_vec.';
        E_mat = E_mat + R/num_data;
    end
    W_mat = W_mat - step*(E_mat-I_mat)*W_mat;
    distance_vec(i) = DKL(W_mat,data_mat);
end

figure;
plot(distance_vec);

separate_mat = zeros(num_channel,num_data);
for t = 1:num_data
    separate_mat(:,t) = W_mat*data_mat(:,t);
end

output1 = separate_mat(1,:).';
output2 = separate_mat(2,:).';

%ここからスケール補正
invers_W = inv(W_mat);
output11 = invers_W(1,1)*output1;
output21 = invers_W(2,1)*output1;
output12 = invers_W(1,2)*output2;
output22 = invers_W(2,2)*output2;

audiowrite("make_voice11.wav",output11,Fs);
audiowrite("make_voice21.wav",output21,Fs);
audiowrite("make_voice12.wav",output12,Fs);
audiowrite("make_voice22.wav",output22,Fs);

%-------------------------------------------
%擬距離の計算
function distance = DKL(W_mat,data_mat)

[~,num_data] = size(data_mat);

distance = -log(abs(det(W_mat)))-sum(log(arrayfun(@func_laplace,data_mat)),"all")/num_data;

end