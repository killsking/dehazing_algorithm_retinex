close all;clear all;clc; 
%% 读取图像
I=imread('002_haze.jpg');I = im2double(I);
I_origin = imread('002_groudtruth.jpg');I_origin = im2double(I_origin);
%% 小波分解
for i=1:3
[cA(:,:,i),cH(:,:,i),cV(:,:,i),cD(:,:,i)] = dwt2(I(:,:,i),'sym4','mode','per');
% 高频系数，HH HL LH做阈值去噪
 cH_d(:,:,i) = wave_denoising(cH(:,:,i));
 cV_d(:,:,i) = wave_denoising(cV(:,:,i));
 cD_d(:,:,i) = wave_denoising(cD(:,:,i));
end
%%低频系数 do retinex
[ssrA, msrA, msrcrA]  = retinex(cA);
msrcrA = im2double(msrcrA);
cA_d = msrcrA;
a = mean((mean(mean(cA)))/mean(mean(mean(cA_d))));
cA_d = 2.*cA_d;

%% 小波重构 
 for i = 1:3
I_d(:,:,i) = idwt2(cA_d(:,:,i),cH_d(:,:,i),cV_d(:,:,i),cD_d(:,:,i),'sym4');
% I_d(:,:,i) = imadjust(I_d(:,:,i));
 end
%  I_d(:,:,1) = imadjust(I_d(:,:,1),[]);
%  I_d(:,:,2) = imadjust(I_d(:,:,2),[]);
%  I_d(:,:,3) = imadjust(I_d(:,:,3),[]);
I_d = imadjust(I_d,[0.1 0.1 0.1; 1,1,1],[]);

figure();
imagesc(I_d);
title('Denoised and Dehazed Signal');
%% 显示，计算ssim和psnr
I_d_gray = rgb2gray(I_d);
I_origin_gray = rgb2gray(I_origin(3:410,3:546,:));
I_ssim = ssim(I_d_gray,I_origin_gray)
I_psnr = psnr(I_d_gray,I_origin_gray)
%% 小波阈值去噪函数
function Image_d = wave_denoising(Image)
[thr,sorh,keepapp] = ddencmp('den','wv',Image);% 阈值获取
Image_d = wdencmp('gbl',Image,'sym4',2,thr,sorh,keepapp);% 阈值去噪
end