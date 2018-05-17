close all
clear
clc

%% Read Image
[im, map] = imread('s.png');
figure;
imshow(im);
[x,y,z] = size(im);

%% Resize
im_resized = imresize(im, [600, (y*600)/x]);
% figure;
% imshow(im_resized);

% %% Convert to HSV
% hsv_image = rgb2hsv(im2);
% sat_image = hsv_image(:,:,2);
% figure;
% imshow(sat_image);
% 
% %% Thresholding
% min_val = min(sat_image(:));
% figure;
% image_thresh = sat_image <= min_val;
% imshow(sat_image <= min_val);
% 
% %% Flood Fill
% flood_fill = imfill(image_thresh);
% figure;
% imshow(flood_fill); axis equal;

%% RGB to Grayscale
grayim = rgb2gray(im_resized);
% figure;
% imshow(grayim);

%% Binary Image
BW = imbinarize(grayim);
figure;
imshow(BW);

%% Region Separation
[rgn,n] = bwlabel(BW);
figure;
imagesc(rgn); axis equal;

%%
% filled = imfill(BW,'holes');
% figure;
% imshow(filled);

%% Find image boundary
mask = boundarymask(BW);
figure;
imshow(mask);

%%
% [B,L,N,A] = bwboundaries(BW,'noholes');
% imshow(label2rgb(L, @jet, [.5 .5 .5]))
% % imshow(L);
% hold on;
% for k = 1:N
% %    boundary = B{k};
% %    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
%    if (nnz(A(:,k)) > 0) 
%         boundary = B{k}; 
%         plot(boundary(:,2),... 
%             boundary(:,1),'r','LineWidth',2); 
%         % Loop through the children of boundary k 
%         for l = find(A(:,k))' 
%             boundary = B{l}; 
%             plot(boundary(:,2),... 
%                 boundary(:,1),'g','LineWidth',2); 
%         end 
%     end 
% end

%% Distance Map
[D, idx] = bwdist(mask);
% figure;
% imagesc(D); axis equal;

r = rgn(1,1);

for i=1:size(D,1)
    for j=1:size(D,2)
        if (rgn(i,j) == r)
            D(i,j) = NaN;
        end
    end 
end

figure;
imagesc(D); axis equal;

%% Circular Smoothing
H = D;

m = max(D(:));

for i=1:size(D,1)
    for j=1:size(D,2)
        a = m - D(i,j);
        H(i,j) = sqrt(m*m - a*a);
    end
end

%% Create Mesh Grid
x = 1:size(H,1);
y = 1:size(H,2);
[X,Y] = meshgrid(y,x);

%% Stem Plot
% figure;
% stem3(X,Y,H);
% hold on;
% stem3(X,Y,-H);

%% Mesh Plot
figure;
mesh(X,Y,H); axis equal;
hold on;
mesh(X,Y,-H); axis equal;

%% Texture Mapping
% fig = figure, warp([X; X],[Y; Y],[H; -H],[im_resized; im_resized]); axis equal;
% print(fig, '-r80','-dtiff','3Dimage.tif');

%%
h = warp([X; X],[Y; Y],[H; -H],[im_resized; im_resized]); axis equal;

%%
% figure; 
% [sx,sy,sz] = surfnorm([X; X], [Y; Y], [H; -H]); axis equal;
% b = reshape([sx sy sz], size(sx,1), size(sx,2),3);
% b = ((b+1)./2).*255;
% % imshow(uint8(b));
% imwrite(uint8(b), 'NormalMap.jpg');

%%
figure;
s = surf(h.XData, h.YData, h.ZData, h.CData); axis equal;
set(s, 'LineStyle', 'none');

%%
surf2stl('ox1.stl', h.XData, h.YData, h.ZData, h.CData);

%% 
% original = [im_resized; im_resized];
% imshow(original);
% 
% ss = surf([X;X], [Y;Y], [H;-H]); axis equal;
% h = findobj('type', 'surface');
% 
% set(h, 'CData', original, 'FaceColor', 'texturemap', 'edgecolor', 'none');
% grid off;
% axis off;
% 
% El = 24;
% for Az=0:360
%     view(Az, El);
%     pause(0.1);
% end
