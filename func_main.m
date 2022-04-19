function func_main(folder_name,step,rep,score_func,score_func_dif)

data_list = dir(folder_name);
[num_file,~] = size(data_list);

%listに謎の[.][..]ファイルがあるのでlist(3)からになってる
[data_mat,Fs] = audioread(data_list(3).name);
for i = 4:num_file
    [data,~] = audioread(data_list(i).name);
    data_mat = horzcat(data_mat,data);
end

addpath("function")
%get_dataは最大値が1の分離したベクトルの集まり
get_data = func_ICA(data_mat,step,rep,score_func,score_func_dif);

mkdir(folder_name + "_result");
for i = 1:num_file-2 %ここの -2 は[.][..]を無視するため
    audiowrite("./" + folder_name + "_result/result" + i + ".wav",get_data(:,i),Fs);
end

end