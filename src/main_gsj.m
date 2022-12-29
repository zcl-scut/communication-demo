slCharacterEncoding('UTF-8');
%slCharacterEncoding('GBK');
%https://www.cnblogs.com/leoking01/p/8269516.html


clear
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%һ��1minģ���źŵ�PCM������������
% 1.��a�ʽ��зǾ�������
% 2.���������һ����ƽ�õ�8bit����
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
[x,fs_music]=audioread('music.wav');
% sound(x,fs)%����ԭ��
N=length(x);
t=0:1/fs_music:(N-1)/fs_music;


x1=x(:,1);%��ȡx��1����
x2=x(:,2);%��ȡx��2����

cut=15;%��ȡ15s����
x1=x1(1:fs_music*cut);
x2=x2(1:fs_music*cut);

start=fs_music*10;%�ӵ�10�뿪ʼ����
inteval=fs_music/300;%��ȡ����,1/300s
test=x1(start:start+inteval);


%%ʱ����ʾ
% figure
% subplot(2,1,1);
% plot(test);%����������������
% grid;
% subplot(2,1,2);
% stem(test);
% grid;

% %%Ƶ����ʾ
% figure
% inteval=2e4;
% test=x1(start:start+inteval-1);
% test_fre=fft(test);
% f=(-inteval/2:inteval/2-1)*fs_music/inteval;
% plot(f,abs(fftshift(test_fre)))
% xlabel('f/Hz')
% axis([0,100,0,100])%��Ƶ��ʾ
% axis([0,2e4,0,40])%��Ƶ��ʾ


ds=4;%downsample rate,44100������,�ο��²�����:2,3,4,5,6,8
fs=fs_music/ds;%ͨ�Ų���(8khz)ԶС����Ƶ����(40khz)����
l_sam=floor(length(x1)/ds);%����ȡ��
sam1=zeros(l_sam,1);%�����ź�
sam2=zeros(l_sam,1);%�����ź�
for i =1:l_sam
    sam1(i)=x1(ds*i);
    sam2(i)=x2(ds*i);
end


% %��������ź�,�����������
pcm1=quantization(sam1);




%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�����������Ʋ���ʾ����
%1.16FSK��16QAM����
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

symbol_rate=2;%��Ԫ����,Baud/s
fc=3;%ģ���ز�Ƶ��,Hz
% test_in=[0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,0,1,0,0,0,1,0,1,0,1,1,0,0,1,1,1,1,0,0,0,1,0,0,1,1,0,1,0,1,0,1,1,1,1,0,0,1,1,0,1,1,1,1,0,1,1,1,1];
% cut=4;%��ÿ4λ��Ƭ
% test_in=reshape(test_in,cut,[]);%[]�Զ�����ά�ȴ�С
% fsk16=[];
% tao=0.01;
% t1=0:tao:1-tao;
% symbols=4;%��ʾ1~4������
% w_fsk=2*pi*4;%����Ϊ1/4
% for i = 1:symbols
%     num=bin2dec(num2str(test_in(:,i)'));%��ȡ4λ����ת��Ϊʮ���ƣ��ٶ�4bit��Ϣλ����16fsk���ƻ���16qam����
%     fsk16=[fsk16,sin((num+1)*w_fsk*t1)];%��(num+1)����Ƶ�ʵ���
% end

% figure
% subplot(2,1,1)
% carrier=repmat(sin(w_fsk*t1),[1 symbols]);
% t1=0:tao/symbols:1-tao/symbols;
% plot(t1,carrier');
% title('�ز�����')
% subplot(2,1,2)
% plot(t1,fsk16');%����16fsk�Ĳ���
% title('16fsk���Ʋ���')

tao=0.01;
t1=0:tao/symbol_rate:1/symbol_rate-tao/symbol_rate;
w_fsk=2*pi*fc;%����Ϊ
fsk16=zeros(1,l_sam*(1/tao)*2);
for i=0:l_sam-1
    binstr= dec2bin(pcm1(i+1),8);%254='11111110'
    num=bin2dec(binstr(1:4));%'1111'=15
    fsk16(i*(1/tao*2)+1:(i+0.5)*(1/tao*2))=sin(((num+1)*w_fsk).*t1);%��(num+1)����Ƶ�ʵ���
    num=bin2dec(binstr(5:8));%'1110'=14
    fsk16((i+0.5)*(1/tao*2)+1:(i+1)*(1/tao*2))=sin(((num+1)*w_fsk).*t1);%��(num+1)����Ƶ�ʵ���
end


%��֤������ȷ��
figure;
i=1;
t1=0:tao/symbol_rate:1/symbol_rate*4-tao/symbol_rate;
plot(t1,fsk16(i*(1/tao*2)+1:(i+2)*(1/tao*2)));%���3fc,10fc,5fc,2fc,����Ӧ�˽���02941(oct),����0��Ӧfc
pcm1(i+1:i+2)%��� 41(dec)=029(oct),65(dec)=041(oct)


%16QAM����ͼ
constell_diag=[1 1;1 3;1 -1;1 -3;3 1;3 3;3 -1;3 -3;-1 1;-1 3;-1 -1;-1 -3;-3 1;-3 3;-3 -1;-3 -3];
%������һ��,(2,2)��һ��ģΪ1
constell_diag=constell_diag./2/sqrt(2);


% qam16=[];
% t2=0:0.001:1-0.001;
% w_qam=2*pi*4;%����Ϊ1/4,Ϊ�˿��ӻ����ÿ���ʹģ�����ڡ�4=��Ԫ����
% symbols=4;%��ʾ1~4������
% for i = 1:symbols
%     num=bin2dec(num2str(test_in(:,i)'));%��ȡ4λ����ת��Ϊʮ���ƣ��ٶ�16bit��Ϣλ����16fsk���ƻ���16qam����
%     qam_sig=constell_diag(num+1,1)*cos(w_qam*t2)-constell_diag(num+1,2)*sin(w_qam*t2);
%     qam16=[qam16,qam_sig];%��(num+1)����Ƶ�ʵ���
% end


% figure
% subplot(2,1,1)
% carrier=repmat(sin(w_qam*t2),[1 symbols]);
% t2=0:0.001/symbols:1-0.001/symbols;
% plot(t2,carrier');
% title('�ز�����')
% subplot(2,1,2)
% plot(t2,qam16');%����16qam�Ĳ���
% title('16qam���Ʋ���')

tao=0.01;
t2=0:tao/symbol_rate:1/symbol_rate-tao/symbol_rate;
w_qam=2*pi*fc;%����Ϊ
qam16=zeros(1,l_sam*(1/tao)*2);
for i=0:l_sam-1
    binstr= dec2bin(pcm1(i+1),8);%254='11111110'
    num=bin2dec(binstr(1:4));%'1111'=15
    qam16(i*(1/tao*2)+1:(i+0.5)*(1/tao*2))=constell_diag(num+1,1)*cos(w_qam*t2)-constell_diag(num+1,2)*sin(w_qam*t2);%��(num+1)����Ƶ�ʵ���
    num=bin2dec(binstr(5:8));%'1110'=14
    qam16((i+0.5)*(1/tao*2)+1:(i+1)*(1/tao*2))=constell_diag(num+1,1)*cos(w_qam*t2)-constell_diag(num+1,2)*sin(w_qam*t2);%��(num+1)����Ƶ�ʵ���
end


%��֤������ȷ��
figure;
i=1e4;
t2=0:tao/symbol_rate:1/symbol_rate*4-tao/symbol_rate;
plot(t1,qam16(i*(1/tao*2)+1:(i+2)*(1/tao*2)));%���3fc,10fc,5fc,2fc,����Ӧ�˽���02941(oct),����0��Ӧfc
pcm1(i+1:i+2)%��� 41(dec)=029(oct),65(dec)=041(oct)



% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%������˹�ŵ����䣬�źŽ��
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % ��˹�ŵ�����
% x_qam = qam16;
% x_fsk = fsk16;
% SNR_indB = 10;
% % x_qam = awgn(x_qam, SNR_indB);
% % x_fsk = awgn(x_fsk, SNR_indB);
% 
% % 16QAM���
% M = 16;
% y_qam = zeros(4, length(x_qam));
% for iter = 1 : symbols
%     y = x_qam(1, (iter-1)*length(t)+1:iter*length(t));
%     y_len = length(y);
%     detect = zeros(1,y_len);         % Ԥ�ü���ź�
%     distance = zeros(1,M);              % �����������
%     I = y.*cos(w_qam*t)*2;
%     Q = -y.*sin(w_qam*t)*2;
%     
%     %��Ƶ�ͨ�˲���
%     Fs=200;
%     fp1=40;fs1=50;rs=30;rp=0.5;
%     wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %ͨ���߽�Ƶ��
%     ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %����߽�Ƶ��
%     [n,wn]=buttord(wp,ws,rp,rs,'s'); %�˲����Ľ���n��-3dB��һ����ֹƵ��Wn
%     [b,a]=butter(n,wn,'s');
%     [num,den]=bilinear(b,a,Fs);  %˫���Ա任
%     I=filter(num,den,I);
%     Q=filter(num,den,Q);
%     [h,w]=freqz(num,den,100,Fs);
% %     figure(1)
% %     subplot(4,1,1);
% %     plot(w,abs(h));
% %     xlabel('Ƶ��/Hz');
% %     ylabel('��ֵ');
% %     title('������˹��ͨ�˲�����������');
% %     grid on;
%     for i = 1 : y_len
%         for j = 1 : M
%             distance(j) = sqrt((I(i)-constell_diag(j,1))^2 + (Q(i)-constell_diag(j,2))^2); %�����źŵ�����������ľ���
%         end
%         pos = find(distance == min(distance)); % ��С�����������λ��
%         detect(i) = pos(1) - 1; % �����ķ��ţ�ʮ���ƣ�
%         y_qam(:, i+(iter-1)*y_len) = (dec2bin(detect(i), 4) - '0')';
%     end
% end
% 
% %16FSK���
% %��Ƶ�ͨ�˲���
% Fs=1000;
% fp1=25;fs1=40;rs=30;rp=0.5;
% wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %ͨ���߽�Ƶ��
% ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %����߽�Ƶ��
% [n,wn]=buttord(wp,ws,rp,rs,'s'); %�˲����Ľ���n��-3dB��һ����ֹƵ��Wn
% [b,a]=butter(n,wn,'s');
% [num,den]=bilinear(b,a,Fs);  %˫���Ա任
% y_fsk = zeros(4, length(x_fsk));
% for iter = 1 : symbols
%     y = x_fsk(1, (iter-1)*length(t1)+1:iter*length(t1));
%     y_len = length(y);
%     detect = zeros(1,y_len);         % Ԥ�ü���ź�
%     distance = zeros(1,M);              % �����������
%     for j = 1 : M
%         y_ = y.*sin(j*w_fsk*t1);       
%         y_=filter(num,den,y_);
%         [h,w]=freqz(num,den,100,Fs);
%         distance(j) = mean(abs(y_));        
%     end
%     for i = 1 : y_len                
%         pos = find(distance == max(distance)); % ����о�
%         detect(i) = pos(1) - 1; % �����ķ��ţ�ʮ���ƣ�
%         y_fsk(:, i+(iter-1)*y_len) = (dec2bin(detect(i), 4) - '0')';
%     end
%     
% 
%     detect(y_len);
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%�ġ������о���ͳ��������
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
% 