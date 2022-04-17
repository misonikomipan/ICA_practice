clc;clear;

%ICAするファイルのデータたちはデータの数がそろっていることが前提
func_main("speech",0.1,20,@score_func_hyperbolic,@score_func_hyperbolic_dif);
%func_main("music",0.1,20,@score_func_laplace,@score_func_laplace_dif);