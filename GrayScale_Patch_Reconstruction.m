% CSC C11 - Machine Learning, Fall 2017, Assignment 1, 
% F. Estrada, festrada@utsc.utoronto.ca
%
% First test driver for RBF regression assignment.
%
% [patch, patch_rec]=GraysScale_Patch_Reconstruction(spacing,sigma)
% 
% This script loads an image, allows you to select a patch,
%  and then uses *your code* to fit an RBF model to the
%  brightness in the patch. It then creates a reconstruction
%  of the patch based on your model and displays the original
%  and reconstructed patch for comparison.
%
% spacing - Spacing between RBF centers along X and Y (in [1, 9])
% sigma   - Width of the RBFs in [1, 2*spacing]
%
% The script returns the original patch and its reconstruction
%
% You DO NOT need to modify this script. Use it to run the
%  tests described in the A1 handout once you have 
%  completed your regression code.
%

function [patch, patch_rec]=GrayScale_Patch_Reconstruction(spacing,sigma)

patch=[];
patch_rec=[];

if (spacing<1 | spacing>9)
 fprintf(2,'Spacing must be in [1 9]\n');
 return;
end;
if (sigma<1 | sigma>(2*spacing))
 fprintf(2,'sigma must be in [1  2*spacing]\n');
 return;
end;

% Close all previous figures.
close all;

CENTER_SPACING=spacing;
PATCH_SIZE=41;
HS=(PATCH_SIZE-1)/2;
SIGMA=sigma;

% Obtain RBF centers given the desired center spacing
[XX,YY]=meshgrid([-HS:CENTER_SPACING:HS],[-HS:CENTER_SPACING:HS]);
C=[XX(:) YY(:)]';

% Load image and convert to floating point
im=double(imread('Amazing_jellyfish_corrupted_by_text.tif'))/255;
figure(1);clf;image(im);axis image

% Select input patch location and ensure it's sufficiently away from the boundary
[X,Y]=ginput(1)
X=round(X);
Y=round(Y);
if (X<=HS | Y<=HS | X>=size(im,2)-HS | Y>=size(im,1)-HS)
 fprintf(2,'Selected location is too close to the boundary, please select a patch away from the boundary\n');
 return;
end;

% Extract and display originalpatch
patch=im(Y-HS:Y+HS,X-HS:X+HS,2);
figure(2);imagesc(patch);axis image;title('Input Patch');colormap(gray);

% SAMPLE patch (in this case, use all pixels in the patch)
[XX YY]=meshgrid([-HS:1:HS],[-HS:1:HS]);
P=[XX(:) YY(:)]';
Z=patch(:);

% Solve for the weights of the RBF model
[w]=TrainRBFRegression(Z,P,C,SIGMA);

% Evaluate model to reconstruct patch
[zp]=evalRBFModel(w,P,C,SIGMA);

% Display reconstructed patch
patch_rec=reshape(zp,size(patch));
figure(3);imagesc(patch_rec);axis image;colormap(gray);title('Reconstructed Patch');

% Display difference
figure(4);imagesc(patch-patch_rec);axis image;colormap(gray);title('Difference between original and reconstruction');

return;

