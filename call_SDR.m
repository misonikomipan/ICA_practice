addpath("bss_eval\");
addpath("speech\");
addpath("speech_result\");

se = horzcat(audioread("speech1.wav"),audioread("speech2.wav"));
s = horzcat(audioread("signal1_observed1.wav"),audioread("signal2_observed1.wav"));

[SDR,SIR,SAR,perm] = bss_eval_sources(se',s')