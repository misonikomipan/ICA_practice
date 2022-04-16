function output_ten = under_func_ICA(input_mat,step,rep,func_score,func_dif_score)

[len_data,num_data] = size(input_mat);  %len_dataは測定点の数

data_mat = input_mat.';

I_mat = eye(num_data);
W_mat = eye(num_data);
distance_vec = 1:rep; %値は関係ないサイズが大切

for i = 1:rep
    E_mat = zeros(num_data);
    for t = 1:len_data
        y_vec = W_mat*data_mat(:,t);
        p_vec = arrayfun(func_dif_score,data_mat(:,t));
        R = p_vec*y_vec.';
        E_mat = E_mat + R/len_data;
    end
    W_mat = W_mat - step*(E_mat-I_mat)*W_mat;
    distance_vec(i) = -log(abs(det(W_mat)))-sum(log(arrayfun(func_score,data_mat)),"all")/len_data;
end

%func_picture(distance_vec);

separate_mat = zeros(num_data,len_data);
for t = 1:len_data
    separate_mat(:,t) = W_mat*data_mat(:,t);
end

output_ten = separate_mat(1,:)

%ここからスケール補正
%invers_W = inv(W_mat);
%output_ten = zeros(num_data,num_data,len_data);

%対角にベクトルを配置
%for i = 1:num_data
%    output_ten(i,i,:) = separate_mat(i,:);
%end

%各マイクの各音声に分解
%for t = 1:len_data
%    output_ten(:,:,t) = invers_W*output_ten(:,:,t);
%end


end