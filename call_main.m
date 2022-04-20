clc;clear;

%ICAするファイルのデータたちはデータの数がそろっていることが前提

foldername = "speech_mix";   %ICAするデータが入っているフォルダ名
step = 0.5;             %ステップサイズ
rep = 20;               %繰り返し回数
score_func = @score_func_laplace;           %優ガウス分布
score_func_dif = @score_func_laplace_dif;   %優ガウス分布をlogとって微分

func_main(foldername,step,rep,score_func,score_func_dif);