% 2音源分離の場合のbss_eval_sources.mの使い方
% 2つの音源を等パワー以外のバランスで混合するケースの例

% おまじない
clear; % ワークスペースの変数クリア
close all; % フィギュアウィンドウを全て閉じる
clc; % コマンドラインクリア

% サブフォルダーにパスを通す
addpath('./bss_eval');

% 音の読み込みとチェック
snr = 0; % 混合時の音源間パワー比（dB），0ならば等パワーで混合
[sig1, fs1] = audioread('./input/piano.wav'); % 完全分離音源1（音源分離における正解，リファレンス信号と呼ぶ，sigLen x 1の縦ベクトルとする）
[sig2, fs2] = audioread('./input/drums.wav'); % 完全分離音源2（音源分離における正解，リファレンス信号と呼ぶ，sigLen x 1の縦ベクトルとする）
sigLen = size(sig1,1);
if fs1 ~= fs2 || size(sig2,1) ~= sigLen
    error('何かおかしいです．\n');
end

% 音の混合（この場合等パワーとは限らない，wavファイルのボリューム次第）
%mixSig = sig1 + sig2;  何らかの信号
%refSig1 = sig1;        元信号1
%refSig2 = sig2;        元信号2

% ここで何らかの音源分離をする
%[estSig1, estSig2] = 何らかの音源分離関数(mixSig); % estSig1が1つめの分離音，estSig2が2つめの分離音とする，どちらもsigLen x 1の縦ベクトルとする

%ここからワイのターン---------------------------------------------
addpath("speech\")
addpath("speech_result\")
addpath("source\")
%mixSig = horzcat(audioread("speech1.wav"),audioread("speech2.wav"));
mixSig = audioread("speech1.wav");
refSig1 = audioread("sample_speech_female.wav");
refSig2 = audioread("sample_speech_male.wav");

estSig1 = audioread("signal1_observed1.wav");
estSig2 = audioread("signal2_observed1.wav");

%-----------------------------------------------------------------

% 入力SDRと入力SIRの計算（入力SARは∞なので不要）
[inSDR, inSIR, ~] = bss_eval_sources([mixSig, mixSig].', [refSig1, refSig2].');

% 客観評価尺度算出（SDR，SIR，SAR）
[outSDR, outSIR, SAR] = bss_eval_sources([estSig1, estSig2].', [refSig1, refSig2].');
SDR % 信号対歪み比（source-to-distortion ratio），分離音源の音質と分離度合いの両方を含む尺度（分離はできているけど音がボロボロだと低い）
SIR % 信号対干渉比（source-to-interference ratio），分離音源の分離度合いのみを含む尺度（音はボロボロだけど相手の音源が消えていれば高い）
SAR % 信号群対人工歪み比（sources-to-artificial ratio），分離音源の音質のみを含む尺度（分離度合いは関係なく，とにかく人工歪みの少なさ．estSig1 = mixSigならSAR=∞dB）
% SDRはSIRとSARの両方を含む尺度なので，SDRが向上すれば音源分離手法としては優秀．両音源の平均SDRが10dBを超えてくるとまあまあ頑張っている，20dBを超えるとめちゃくちゃすごい．
% 混合が等パワーで無い場合は観測時点のSDRとSIR（「入力SDR」及び「入力SIR」と呼ぶ）をあらかじめ計算しておいて，上記の値から引き算して「改善値」を算出する
SDRimp = outSDR - inSDR % 信号対歪み比（source-to-distortion ratio）の改善量（入力SDRからの増分）
SIRimp = outSIR - inSIR % 信号対干渉比（source-to-interference ratio）の改善量（入力SDRからの増分）
SAR % 信号群対人工歪み比（sources-to-artificial ratio
