function output_ten = func_ICA(input_mat,step,rep,score_func,score_func_dif)

[len_data,num_data] = size(input_mat);  %len_dataは測定点の数、num_dataは音源の数

data_mat = input_mat.';

I_mat = eye(num_data);
W_mat = eye(num_data);
distance_vec = 1:rep; %値は関係ないサイズが大切

for i = 1:rep
    E_mat = zeros(num_data);
    for t = 1:len_data
        y_vec = W_mat*data_mat(:,t);
        p_vec = arrayfun(score_func_dif,y_vec);
        R = p_vec*y_vec.';
        E_mat = E_mat + R/len_data;
    end
    W_mat = W_mat - step*(E_mat-I_mat)*W_mat;
    distance_vec(i) = -log(abs(det(W_mat)))-sum(log(arrayfun(score_func,data_mat)),"all")/len_data;
end

func_picture(distance_vec);

%breakupに分離信号を入れる
breakup_mat = zeros(num_data,len_data);
for t = 1:len_data
    breakup_mat(:,t) = W_mat*data_mat(:,t);
end

output_ten = breakup_mat.'/max(abs(breakup_mat),[],"all");

%スケール補正はもうええやろ。。。なんかうまくかけへん。。。
end