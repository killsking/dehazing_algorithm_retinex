clear all;
close all;
clc;
%% 参数设置
format long
%采样频率及采样间隔 
fs=14000;         
Ts=1/fs;
f0=500;                 
f= [50,100,150];
%% 调制
sample=500;%采样点
k=1:sample; 
xx = k;
g_modulated = 0;
for i = 1:3
    t=Ts*(k-1);
    signal(i,:)=cos(2*pi*f(i)*t);   
    carry(i,:)=cos(2*pi*(f0*2*i)*t); 
    g_modulated = g_modulated + signal(i,:).*carry(i,:);
end

%% 滤波器
n=50;%长度为n,阶数是n-1，时延为n/2;
b=fir1(n,f0/fs);%过渡带中心
%% 解调
x_ax=((round(n/2)+1):sample) - round(n/2);%减去时延,x坐标轴
for i=1:3
   g_de(i,:)=g_modulated.*carry(i,:); 
   g_final(i,:)=2.5*filter(b,1,g_de(i,:));
   g_final(i,x_ax)=g_final(i,((round(n/2)+1):sample));
  figure(i);
   plot(xx,signal(i,xx),x_ax,g_final(i,x_ax));
   legend('调制前','解调后');
    xlabel('采样点');
    ylabel('幅度');
end

figure(4);
[H,w]=freqz(b,1,512,fs);
H_phase=angle(H);
H_amplitude=abs(H);
subplot(2,1,1)
plot(w,20*log(H_amplitude))
title('Amplitude')
subplot(2,1,2)
plot(w,H_phase)
title('Phase')
