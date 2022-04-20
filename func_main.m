function func_main(folder_name,step,rep,score_func,score_func_dif)

%フォルダ名をもとにデータを読み込む
data_list = dir(folder_name);
[num_file,~] = size(data_list);
addpath(folder_name);
%listに謎の[.][..]ファイルがあるのでlist(3)からになってる
[data_mat,Fs] = audioread(data_list(3).name);
for i = 4:num_file
    [data,~] = audioread(data_list(i).name);
    data_mat = horzcat(data_mat,data);
end


addpath("function")
%get_dataは最大値が1の分離したベクトルの集まり
get_data = func_ICA(data_mat,step,rep,score_func,score_func_dif);


%分離信号を.wavで保存
mkdir(folder_name + "_result");
k = 1;
for i = 1:num_file-2
    for j = 1:num_file-2
        audiowrite("./" + folder_name + "_result/sig" + i + "_obs" + j + ".wav",get_data(:,k),Fs);
        k = k + 1;
    end
end

%SDR関数で評価計算の結果を保存
func_sdr_write(folder_name);

end