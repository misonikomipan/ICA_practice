clc;clear;
[data1_vec,Fs]=audioread("combined_speech1.wav");
[data2_vec,~]=audioread("combined_speech2.wav");
data_matrix = [data1_vec.';data2_vec.'];
