function [err1,err2,err3]=submain(x1,nowi,fs_music)
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%一、1min模拟信号的PCM采样量化编码
% 1.用a率进行非均匀量化
% 2.量化编码后一个电平得到8bit码字
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
symbol_rate=1;%码元速率,Baud/s
fc=1;%模拟载波频率,Hz
smooth=100;
ds=4;%downsample rate,44100的因数,参考下采样率:2,3,4,5,6,8
fs=fs_music/ds;%通信采样(8khz)远小于音频播放(40khz)采样
l_sam=floor(length(x1)/ds);%向下取整
sam1=zeros(l_sam,1);%采样信号
for i=1:l_sam
    sam1(i)=x1(ds*i);
end

% %输入抽样信号,输出量化编码
pcm1=quantization(sam1);
clear sam1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%二、基带调制并显示波形
%1.16FSK和16QAM调制
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%


fsk16=fsk16mod(pcm1,symbol_rate,fc,smooth,false,1e4);
qam16=qam16mod(pcm1,symbol_rate,fc,smooth,false,1e4);


%%%%%%%%%%%%%%%%%%%%%
% %16QAM星座图
%%%%%%%%%%%%%%%%%%%%%
constell_diag=[1 1;1 3;1 -1;1 -3;3 1;3 3;3 -1;3 -3;-1 1;-1 3;-1 -1;-1 -3;-3 1;-3 3;-3 -1;-3 -3];
% %能量归一化,(2,2)归一化模为1
constell_diag=constell_diag./2/sqrt(2);






%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%三、高斯信道传输，信号解调
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 高斯信道传输
w_fsk=2*pi*fc;
w_qam=2*pi*fc;
x_qam = qam16;
x_fsk = fsk16;
clear qam16; clear fsk16;
SNR_indB = 3;
x_qam = awgn(x_qam, SNR_indB);
x_fsk = awgn(x_fsk, SNR_indB);

% 16QAM解调
%  fp1=10;fs1=30;rs=5;rp=0.5;
fp1=50;fs1=100;rs=12;rp=0.5;
y_qam = demodulate_16qam(x_qam,fs, w_qam, fp1, fs1, rs, rp, smooth, symbol_rate);
clear x_qam;

%16FSK解调
%设计低通滤波器
fp1=1000;fs1=1200;rs=10;rp=2;
y_fsk = demodulate_16fsk1(x_fsk,fs, w_fsk, fp1, fs1, rs, rp, smooth, symbol_rate);
df = 10; M = 16;
y_fsk2 = demodulate_16fsk2(x_fsk, fs, fc, smooth);
clear x_fsk;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%四、抽样判决，统计误码率
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

TestBg=10000;TestL=320;
x1Test = x1(TestBg+1:TestBg+TestL);   %测试信号
bj=0;
if nowi==1
    bj=1;
end
err1=part4(y_fsk,pcm1,TestBg,x1Test,fs_music,smooth,ds,'16fsk Coherent-Demodulation',bj);
err2=part4(y_fsk2,pcm1,TestBg,x1Test,fs_music,smooth,ds,'16fsk Envelope-Demodulation',bj);
err3=part4(y_qam,pcm1,TestBg,x1Test,fs_music,smooth,ds,'16qam Coherent-Demodulation',bj);
