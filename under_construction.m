clc;clear;

step = 0.1; %ステップサイズ
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
        p_vec = arrayfun(@dif_score_func,data_mat(:,t));
        R = p_vec*y_vec.';
        E_mat = E_mat + R/t;
    end
    W_mat = W_mat - step*(E_mat-I_mat)*W_mat
    distance_vec(i) = DKL(W_mat,data_mat);
end

distance_vec.'
plot(distance_vec)

separate_mat = zeros(num_channel,num_data);
for t = 1:num_data
    separate_mat(:,t) = W_mat*data_mat(:,t);
end

sample1 = separate_mat(1,:).';
audiowrite("make_voice1.wav",sample1,Fs);
sample2 = separate_mat(2,:).';
audiowrite("make_voice2.wav",sample2,Fs);

%ラプラス分布--------------------------------
function y = score_func(x)
    y = exp(-abs(x))/2;
end

function y = dif_score_func(x)
    if x >= 0
        y = 1;
    else
        y = -1;
    end
end
%-------------------------------------------
%擬距離の計算
function distance = DKL(W_mat,data_mat)

[num_channel,num_data] = size(data_mat);
sum = 0;

for t=1:num_data
    for n=1:num_channel
        sum = log(score_func(data_mat(num_channel,num_data)));
    end
end

distance = -log(abs(det(W_mat)))-sum/num_data;

end