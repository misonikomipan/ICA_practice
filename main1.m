% 2音源分離の場合のbss_eval_sources.mの使い方
% SNRmix.mを使って2つの音源を等パワーで混合するケースの例

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

% 音の等パワー混合
[mixSig, refSig1, refSig2, coef] = SNRmix(sig1, sig2, snr); % 混合比がsnr[dB]となるように2音源を混合（mixSig = refSig1 + refSig2 = sig1 + coef*sig2と思えば良い）

% ここで何らかの音源分離をする
[estSig1, estSig2] = 何らかの音源分離関数(mixSig); % estSig1が1つめの分離音，estSig2が2つめの分離音とする，どちらもsigLen x 1の縦ベクトルとする

% 客観評価尺度算出（SDR，SIR，SAR）
% 音源毎に1 x sigLenの横ベクトルにしてくっつけてbss_eval_sourcesに入力する
% 引数の順番は「分離音，正解音」である
% ここで「estSig1がrefSig2，estSig2がrefSig1」となっていても問題ない．bss_eval_sourcesは総組み合わせを計算してSIRの高いものを出力している．
% 評価尺度の値の順番は正解音の順番と一致する（つまり，SDR(1,1)はrefSig1のSDR値，SDR(2,1)はrefSig2のSDR値）
[SDR, SIR, SAR] = bss_eval_sources([estSig1, estSig2].', [refSig1, refSig2].');
SDR % 信号対歪み比（source-to-distortion ratio），分離音源の音質と分離度合いの両方を含む尺度（分離はできているけど音がボロボロだと低い）
SIR % 信号対干渉比（source-to-interference ratio），分離音源の分離度合いのみを含む尺度（音はボロボロだけど相手の音源が消えていれば高い）
SAR % 信号群対人工歪み比（sources-to-artificial ratio），分離音源の音質のみを含む尺度（分離度合いは関係なく，とにかく人工歪みの少なさ．estSig1 = mixSigならSAR=∞dB）
% SDRはSIRとSARの両方を含む尺度なので，SDRが向上すれば音源分離手法としては優秀．両音源の平均SDRが10dBを超えてくるとまあまあ頑張っている，20dBを超えるとめちゃくちゃすごい．
% あとmixSigがsig1とsig2の等パワー混合ならば，観測時点の（何も音源分離をしていない状態の）SDRとSARはほぼ0dB，SARは∞dBなので，上記のSDRとSIR値がそのまま「音源分離手法によって得られたSDR及びSIRの改善値」になる．
% 混合が等パワーで無い場合は観測時点のSDRとSIR（「入力SDR」及び「入力SIR」と呼ぶ）をあらかじめ計算しておいて，上記の値から引き算して「改善値」を算出する必要がある（main2.mを見てくれ）
