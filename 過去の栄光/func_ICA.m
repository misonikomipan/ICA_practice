function [output11,output12,output21,output22] = func_ICA(filename1,filename2,step,rep,func_score,func_dif_score)

cd speech

[data1_vec,Fs]=audioread(filename1);
[data2_vec,~]=audioread(filename2);
data_mat = [data1_vec.';data2_vec.'];

cd ..

[num_data,len_data] = size(data_mat);  %len_dataは測定点の数

I_mat = eye(2);
W_mat = eye(2);
distance_vec = 1:rep; %値は関係ないサイズが大切

for i = 1:rep
    E_mat = zeros(2);
    for t = 1:len_data
        y_vec = W_mat*data_mat(:,t);
        p_vec = arrayfun(func_dif_score,y_vec);
        R = p_vec*y_vec.';
        E_mat = E_mat + R/len_data;
    end
    W_mat = W_mat - step*(E_mat-I_mat)*W_mat;
    distance_vec(i) = -log(abs(det(W_mat)))-sum(log(arrayfun(func_score,data_mat)),"all")/len_data;
end

func_picture(distance_vec);

separate_mat = zeros(num_data,len_data);
for t = 1:len_data
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

cd speech

audiowrite("make_voice11.wav",output11,Fs);
audiowrite("make_voice21.wav",output21,Fs);
audiowrite("make_voice12.wav",output12,Fs);
audiowrite("make_voice22.wav",output22,Fs);

cd ..

end