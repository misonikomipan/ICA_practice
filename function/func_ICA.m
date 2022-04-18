function output_mat = func_ICA(input_mat,step,rep,score_func,score_func_dif)

[len_data,num_data] = size(input_mat);  %len_dataは測定点の数、num_dataは音源の数

data_mat = input_mat.';

I_mat = eye(num_data);
W_mat = eye(num_data);
distance_vec = 1:rep; %値は関係ないサイズが大切

for i = 1:rep
    E_mat = zeros(num_data);
    y_mat = W_mat*data_mat;
    %色々考えた結果DKLの計算はここ
    distance_vec(i) = -log(abs(det(W_mat)))-sum(log(arrayfun(score_func,y_mat)),"all")/len_data;
    p_mat = arrayfun(score_func_dif,y_mat);
    for t = 1:len_data
        E_mat = E_mat + p_mat(:,t)*y_mat(:,t).';
    end
    E_mat = E_mat/len_data; %ループの外で割り算
    W_mat = W_mat - step*(E_mat-I_mat)*W_mat;
end

func_picture(distance_vec);

%breakupに分離信号を入れる
breakup_mat = zeros(num_data,len_data);
for t = 1:len_data
    breakup_mat(:,t) = W_mat*data_mat(:,t);
end

output_mat = breakup_mat.'/max(abs(breakup_mat),[],"all");

%スケール補正はもうええやろ。。。なんかうまくかけへん。。。
end