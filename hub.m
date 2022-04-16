clc;clear;

[A,B,C,D] = func_ICA("combined_speech1.wav","combined_speech2.wav",0.1,30,@func_laplace,@func_dif_laplace);