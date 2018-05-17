close all
clc

%% Read Image
im = imread('baby-elephant-md.png');
figure;
imshow(im);

%% Grayscale
im2 = rgb2gray(im);
figure;
imshow(im2);

%% Binarize

I = adaptthresh(im2, 0.5);
figure;
imagesc(I);
im3 = imbinarize(im2, I);
figure;
imshow(im3);

%% HSV

% hsv = rgb2hsv(im);
I = adaptthresh(im2, 0.4);
figure;
imagesc(I); axis equal;

im4 = imbinarize(im2, I);
figure;
imshow(im4);

%%
contour(im2)