function output_mat = func_ICA(input_mat,step,rep,score_func,score_func_dif)

[len_data,num_data] = size(input_mat);  %len_dataは測定点の数、num_dataは音源の数

data_mat = input_mat';

W_mat = eye(num_data);
distance_vec = 1:rep;

for i = 1:rep
    y_mat = W_mat * data_mat;
    distance_vec(i) = - log(abs(det(W_mat))) - sum(log(score_func(y_mat)),"all") / len_data;
    W_mat = W_mat - step*(score_func_dif(y_mat) * y_mat' / len_data - eye(num_data)) * W_mat;
end

func_picture(distance_vec);

breakup_mat = W_mat * data_mat;

%-------------ここからプロジェクションバック法-----------------

output_mat = breakup_mat'/max(abs(breakup_mat),[],"all");


end