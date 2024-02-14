close all;
clear;

IMAGE1='testimages/13_22_s.bmp';
IMAGE2='testimages/13_23_s.bmp';

%IMAGE1='testimages/wall1.jpg';
%IMAGE2='testimages/wall2.jpg';

img1=double(imread(IMAGE1))./255;
img2=double(imread(IMAGE2))./255;

gimg1=rgb2gray(img1);
gimg2=rgb2gray(img2);

%imgshow(gimg1);

% Run the SIFT detetor, and compute the SIFT descriptors
%

% Run the Harris corner detector
thresh=1000; % top 1000 corners
%thresh=10;
corners1 = torr_charris_jc(gimg1, thresh)';
corners2 = torr_charris_jc(gimg2, thresh)';


% Plot positions of the SIFT points and corners
figure(1);
imgshow(img1);
hold on;
%plot(keypoints1(1,:),keypoints1(2,:),'yx');
plot(corners1(1,:),corners1(2,:),'bx');
title(IMAGE1);
% Plot positions of the SIFT points

% Plot positions of the SIFT points
figure(2);
imgshow(img2);
hold on;
%plot(keypoints2(1,:),keypoints2(2,:),'yx');
plot(corners2(1,:),corners2(2,:),'bx');
title(IMAGE2);

% Helpful to give windows a chance to draw before disk tied up saving
% results
drawnow;

clear img1 img2 gimg1 gimg2;
save siftresults keypoints1 keypoints2 descr1 descr2;