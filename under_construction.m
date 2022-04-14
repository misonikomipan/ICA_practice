clc;clear;

step_size = 0.1;        %ステップサイズ
num_iterations = 1;   %反復回数

%filename = "sample_voice.wav";
%[data1_vec,~]=audioread(filename1);
%[data2_vec,~]=audioread(filename2);
%data_matrix = [data1_vec.';data2_vec.'];


data = [1,2;3,4;5,6;7,8];   %データを合わせたもの
[num_data,~] = size(data);  %num_dataは測定点の数
data = data.'

W_matrix = [1,1;1,1]
I_martrix = eye(2,2);


for i = 0:num_iterations
    E = zeros(2);
    for time = 1:1 %ここ後で書き換える
        y = W_matrix*data(:,time)
        p = dif_score_func(y)
    end
end


%ラプラス分布--------------------------------
function y = score_func(x)
    y = exp(-abs(x))/2;
end

function y_vec = dif_score_func(x_vec)
    for i = 1:2
        if x_vec > 0
            y_vec = 1;
        else
            y_vec = -1;
        end
    end
end
%-------------------------------------------