close all;
clear;
clc;

setup_paths();

cell_size = 6;
nOrients = 9;

nDim = 3*nOrients+5-1;

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
f_fhog_orig = hog_image_orig(:,:,1:end-1);
f_fhog_v13  = hog_image_v13(:,:,1:end-1);
f_fhog_v68  = hog_image_v68(:,:,1:end-1);

figure(1)
for k = 1:nDim
    subplot(6,6,k);
    imagesc(f_fhog_orig(:, :, k));
    title(['orig  ', num2str(k), ' layer']);
end
figure(2)
for k = 1:nDim
    subplot(6,6,k);
    imagesc(f_fhog_v13(:, :, k));
    title(['v13  ', num2str(k), ' layer']);
end
figure(3)
for k = 1:nDim
    subplot(6,6,k);
    imagesc(f_fhog_v68(:, :, k));
    title(['v68  ', num2str(k), ' layer']);
end