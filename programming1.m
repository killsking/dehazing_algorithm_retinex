clear all;
close all;
clc;
%% ��������
format long
%����Ƶ�ʼ�������� 
fs=14000;         
Ts=1/fs;
f0=500;                 
f= [50,100,150];
%% ����
sample=500;%������
k=1:sample; 
xx = k;
g_modulated = 0;
for i = 1:3
    t=Ts*(k-1);
    signal(i,:)=cos(2*pi*f(i)*t);   
    carry(i,:)=cos(2*pi*(f0*2*i)*t); 
    g_modulated = g_modulated + signal(i,:).*carry(i,:);
end

%% �˲���
n=50;%����Ϊn,������n-1��ʱ��Ϊn/2;
b=fir1(n,f0/fs);%���ɴ�����
%% ���
x_ax=((round(n/2)+1):sample) - round(n/2);%��ȥʱ��,x������
for i=1:3
   g_de(i,:)=g_modulated.*carry(i,:); 
   g_final(i,:)=2.5*filter(b,1,g_de(i,:));
   g_final(i,x_ax)=g_final(i,((round(n/2)+1):sample));
  figure(i);
   plot(xx,signal(i,xx),x_ax,g_final(i,x_ax));
   legend('����ǰ','�����');
    xlabel('������');
    ylabel('����');
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
