clc;clear;

step = 0.1;        %ステップサイズ
num_iterations = 10;   %反復回数

[data1_vec,Fs]=audioread("combined_speech1.wav");
[data2_vec,~]=audioread("combined_speech2.wav");
data_mat = [data1_vec.';data2_vec.'];

[~,num_data] = size(data_mat);  %num_dataは測定点の数

W_mat = [1,1;1,1];
I_mat = eye(2,2);

for i = 0:num_iterations-1
    E_mat = zeros(2);
    for t = 1:num_data
        y_vec = W_mat*data_mat(:,t);
        p_vec = arrayfun(@dif_score_func,data_mat(:,t));
        R = p_vec*y_vec.';
        E_mat = E_mat + R/t;
    end
    W_mat = W_mat - step*(E_mat-I_mat)*W_mat;
end


separate_mat = data_mat;   %同じサイズを作りたかった
for t = 1:num_data
    separate_mat(:,t) = W_mat*data_mat(:,t);
end

sample1 = separate_mat(1,:).';

audiowrite("make_sample1.wav",sample1,Fs);

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