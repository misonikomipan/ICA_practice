function func_main(foldername,step,rep,score_func,score_func_dif)

list = dir(foldername);
[num_file,~] = size(list);
cd(foldername);

%listに謎の[.][..]ファイルがあるのでlist(3)からになってる
[data_mat,Fs] = audioread(list(3).name);
for i = 4:num_file
    [data,~] = audioread(list(i).name);
    data_mat = horzcat(data_mat,data);
end
cd .. %main.mの場所に戻る

cd function
%get_dataは最大値が1の分離したベクトルの集まり
get_data = func_ICA(data_mat,step,rep,score_func,score_func_dif);
cd ..

mkdir(foldername + "_result");

cd(foldername + "_result");

for i = 1:num_file-2 %ここの -2 は[.][..]を無視するため
audiowrite("madeup_result" + i + ".wav",get_data(:,i),Fs);
end

cd .. %main.mの場所に戻る

end