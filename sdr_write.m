function sdr_write(foldername)

addpath("bss_eval\");
addpath(foldername + "_result");
addpath(foldername + "_true");

list_true = dir(foldername + "_true");
[num_file_true,~] = size(list_true);
data_true = audioread(list_true(3).name);
for i = 4:num_file_true
data_true = horzcat(data_true,audioread(list_true(i).name));
end

[num_len,~] = size(data_true);

list_result = dir(foldername + "_result");
data_result = zeros(num_len,num_file_true-2);

SDR_mat = zeros(num_file_true-2,num_file_true-2);

for i = 1:num_file_true-2
    for j = 1:num_file_true-2
        data_result(:,j) = audioread(list_result(i+(j-1)*(num_file_true-2)+2).name);
    end
    %fprintf("score observed " + i + " is\n");
    SDR_mat(i,:) = bss_eval_sources(data_result',data_true');
end

%len = 1:num_file_true-2;

csvwrite("result_SDR.csv",SDR_mat,2,1);


end