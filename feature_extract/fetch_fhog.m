close all;
clear;
clc;

setup_paths();

cell_size = 6;
nOrients = 9;

%nDim = 3*nOrients+5-1;

% uncomment below to show zero's color
nDim = 3*nOrients+5;

im_orig = imread('data/orig.jpg');
im_v13  = imread('data/orig_v13.jpg');
im_v68  = imread('data/orig_v68.jpg');

[im_height, im_width, num_im_chan, num_images] = size(im_orig);

f_fhog_orig = zeros(floor(im_height/cell_size), floor(im_width/cell_size), nDim, 'single');
f_fhog_v13  = zeros(floor(im_height/cell_size), floor(im_width/cell_size), nDim, 'single');
f_fhog_v68  = zeros(floor(im_height/cell_size), floor(im_width/cell_size), nDim, 'single');

hog_image_orig = fhog(single(im_orig), cell_size, nOrients);
hog_image_v13  = fhog(single(im_v13),  cell_size, nOrients);
hog_image_v68  = fhog(single(im_v68),  cell_size, nOrients);
    
%the last dimension is all 0 so we can discard it
% f_fhog_orig = hog_image_orig(:,:,1:end-1);
% f_fhog_v13  = hog_image_v13(:,:,1:end-1);
% f_fhog_v68  = hog_image_v68(:,:,1:end-1);

% uncomment below to show zero's color
f_fhog_orig = hog_image_orig;
f_fhog_v13  = hog_image_v13;
f_fhog_v68  = hog_image_v68;

figure(1)
for k = 1:nDim
    subplot(4,8,k);
    imagesc(f_fhog_orig(:, :, k));
    title(['orig  ', num2str(k), ' layer']);
end
figure(2)
for k = 1:nDim
    subplot(4,8,k);
    imagesc(f_fhog_v13(:, :, k));
    title(['v13  ', num2str(k), ' layer']);
end
figure(3)
for k = 1:nDim
    subplot(4,8,k);
    imagesc(f_fhog_v68(:, :, k));
    title(['v68  ', num2str(k), ' layer']);
end
figure(4)
for k = 1:nDim
    subplot(4,8,k);
    imagesc(f_fhog_v13(:, :, k) - f_fhog_orig(:, :, k));
    title(['v13 - orig  ', num2str(k), ' layer']);
end
figure(5)
for k = 1:nDim
    subplot(4,8,k);
    imagesc(f_fhog_v68(:, :, k) - f_fhog_orig(:, :, k));
    title(['v68 - orig  ', num2str(k), ' layer']);
end

[feature_orig,vision_orig] = extractHOGFeatures(double(im_orig),'CellSize',[6 6]);
[feature_v13,vision_v13]   = extractHOGFeatures(double(im_v13),'CellSize',[6 6]);
[feature_v68,vision_v68]   = extractHOGFeatures(double(im_v68),'CellSize',[6 6]);

figure(6)
imshow(im_orig);hold on
plot(vision_orig);
figure(7)
imshow(im_v13);hold on
plot(vision_v13);
figure(8)
imshow(im_v68);hold on
plot(vision_v68);
