clc;
cd speech

[a,Fs] = audioread("combined_speech1.wav");
[b,~] = audioread("combined_speech2.wav");
%[c,~] = audioread("music3.wav");

cd ..

get_data = under_func_ICA(horzcat(a,b),0.1,20,@func_laplace,@func_dif_laplace);

audiowrite("makesample.wav",get_data,Fs);