function func_sdr_write(foldername)

addpath("./bss_eval");
addpath("./" + foldername + "_result");
addpath("./" + foldername + "_true");

list_true = dir("./" + foldername + "_true");
[num_file_true,~] = size(list_true);
data_true = audioread(list_true(3).name);
for i = 4:num_file_true
data_true = horzcat(data_true,audioread(list_true(i).name));
end

[num_len,~] = size(data_true);

list_result = dir("./" + foldername + "_result");
data_result = zeros(num_len,num_file_true-2);

SDR_mat = zeros(num_file_true-2,num_file_true-2);

for i = 1:num_file_true-2
    for j = 1:num_file_true-2
        text = list_result(i+(j-1)*(num_file_true-2)+2).name;
        data_result(:,j) = audioread(text);
    end
    %fprintf("score observed " + i + " is\n");
    SDR_mat(i,:) = bss_eval_sources(data_result',data_true');
end

xlsx_file_pass = "./" + foldername + "_result/write_SDR.xlsx";
%ここからエクセルファイルにデータを書き込む----------------------
writecell({"foldername" " " foldername;"datetime" " " datetime},xlsx_file_pass,"range","A1");
%writecell({},"result_SDR.xlsx","range","A2");
writematrix(SDR_mat,xlsx_file_pass,"range","F2");

str = ["ovserver1"];
for i = 2:num_file_true-2
    str = horzcat(str,convertCharsToStrings("observer" + i));
end
writematrix(str',xlsx_file_pass,"range","E2");

str = [list_true(3).name];
for i = 4:num_file_true
    str = horzcat(str,convertCharsToStrings(list_true(i).name));
end
writematrix(str,xlsx_file_pass,"range","F1");
%------------------------------------------------------------
end