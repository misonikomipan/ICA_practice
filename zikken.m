clc;clear;

A=zeros(2,2,3);

for i=1:3
    A(:,:,i)=eye(2);
end

A
data_mat = [1,2,3,4,5,6;2,3,4,5,6,7]

for i = 1:3
    DKL(A(:,:,i),data_mat)
end

%data_matは二行、長い列のつもり
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


function y = score_func(x)
    y = exp(-abs(x))/2;
end