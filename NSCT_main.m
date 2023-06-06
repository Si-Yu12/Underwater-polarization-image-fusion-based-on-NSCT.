clear all;
close all;
clc;


addpath(genpath('nsct_toolbox'));


[imagename1 imagepath1]=uigetfile('source_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
image_input1=imread(strcat(imagepath1,imagename1)); 
[imagename2 imagepath2]=uigetfile('source_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the second input image');
image_input2=imread(strcat(imagepath2,imagename2));



image_input1=uint8(image_input1);
image_input2=uint8(image_input2);

figure;imshow(image_input1);
figure;imshow(image_input2);

if size(image_input1)~=size(image_input2)
    error('two images are not the same size.');
end

A=double(image_input1);                                                                                                  
B=double(image_input2);

level=4;

tic;

F = nsct_fuse_try(A,B,[2,3,3,4]);        %NSCT


toc;

figure;imshow(uint8(F));
% imwrite(uint8(F),'nsct png.png');



