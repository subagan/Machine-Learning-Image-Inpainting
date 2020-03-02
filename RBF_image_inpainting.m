% CSC C11 - Machine Learning, Fall 2017, Assignment 1, 
% F. Estrada, festrada@utsc.utoronto.ca
%
% Second test driver for RBF regression assignment.
%
% [im, im_rec]=RBF_image_inpainting(image_name,spacing,sigma)
% 
% This script loads an image that is somehow corrupted with
%  extraneous elements of a *fixed colour*. It will prompt you
%  to clock on a pixel from the extraneous image elements,
%  and then it will use your RBF regression code to fill-in
%  the image regions that contain any of these extraneous
%  pixels.
%
% spacing - Spacing between RBF centers along X and Y (in [1, 9])
% sigma   - Width of the RBFs in [.5, 2*spacing]
%
% The script returns the original image and its reconstruction
%
% You DO NOT need to modify this script. Use it to run the
%  tests described in the A1 handout once you have 
%  completed your regression code.
%

function [im, im_rec]=RBF_image_inpainting(image_name,spacing,sigma)

im=[];
im_rec=[];

if (spacing<1 | spacing>9)
 fprintf(2,'Spacing must be in [1 9]\n');
 return;
end;
if (sigma<.5 | sigma>(2*spacing))
 fprintf(2,'sigma must be in [1  2*spacing]\n');
 return;
end;

% Close all previous figures.
close all;

CENTER_SPACING=spacing;
PATCH_SIZE=25;
SIGMA=sigma;
TOL=.1;

% Load image and convert to floating point
im=double(imread(image_name))/255;
im_rec=im;
figure(1);clf;image(im);axis image

% Select input patch location and ensure it's sufficiently away from the boundary
fprintf(2,'Please click on a pixel of the corrupting component to be filled-in\n');
[X,Y]=ginput(1)
X=round(X);
Y=round(Y);

% Extraneous element colour
fprintf(2,'The colour to be filled-in is:\n');
R_col=im(Y,X,:)

for i=CENTER_SPACING+1:PATCH_SIZE:size(im,2)-(PATCH_SIZE+CENTER_SPACING)
 for j=CENTER_SPACING+1:PATCH_SIZE:size(im,1)-(PATCH_SIZE+CENTER_SPACING)

  % Splat RBFs over this image patch
  [XX,YY]=meshgrid([i-CENTER_SPACING:CENTER_SPACING:i+PATCH_SIZE+CENTER_SPACING],[j-CENTER_SPACING:CENTER_SPACING:j+PATCH_SIZE+CENTER_SPACING]);
  C=[XX(:) YY(:)]';

  % Grid of pixel coordinates for fill-in pixels and corresponding patch with fill-in indices
  [XX YY]=meshgrid([i:i+PATCH_SIZE],[j:j+PATCH_SIZE]);
  Pfill=[XX(:) YY(:)]';
  patch_fill=im(j:j+PATCH_SIZE,i:i+PATCH_SIZE,:);
  ref=(patch_fill-repmat(R_col,[size(patch_fill,1) size(patch_fill,2) 1]));
  ref=ref.^2;
  ref=sum(ref,3);
  [idx_fill]=find(ref<=TOL);
    
  % Grid of pixel coordinates for fitting data and corresponding image patch with valid data indices
  [XX YY]=meshgrid([i-CENTER_SPACING:i+PATCH_SIZE+CENTER_SPACING],[j-CENTER_SPACING:j+PATCH_SIZE+CENTER_SPACING]);
  P=[XX(:) YY(:)]';
  patch=im(j-CENTER_SPACING:j+PATCH_SIZE+CENTER_SPACING,i-CENTER_SPACING:i+PATCH_SIZE+CENTER_SPACING,:);
  ref=(patch-repmat(R_col,[size(patch,1) size(patch,2) 1]));
  ref=ref.^2;
  ref=sum(ref,3);
  [idx_data]=find(ref>TOL);  
  
  if (length(idx_fill)>0)
    % Patch contains the reference fill-in colour, use RBFs to fill-in
    fprintf(2,'Reconstructing patch at %d,%d, %d fill-in pixels\n',i,j,length(idx_fill));
    if (length(idx_data)<=length(C(:)))
     fprintf(2,'Not enough pixels to estimate RBF model! copying patch\n');
     patch_rec=patch_fill;
    else
     % Valid locations for sampling pixels
     PP=P(:,idx_data);
    
     % Reconstruct each colour layer using a separate RBF model
     % Red channel
     patch_R=patch(:,:,1);
     z_R=patch_R(idx_data);
     % Solve for the weights of the RBF model
     [w_R]=TrainRBFRegression(z_R,PP,C,SIGMA);
    
     % Green channel
     patch_G=patch(:,:,2);
     z_G=patch_G(idx_data);
     % Solve for the weights of the RBF model
     [w_G]=TrainRBFRegression(z_G,PP,C,SIGMA);

     % Blue channel
     patch_B=patch(:,:,3);
     z_B=patch_B(idx_data);
     % Solve for the weights of the RBF model
     [w_B]=TrainRBFRegression(z_B,PP,C,SIGMA);
        
     % Reconstruct pixel values at fill-in locations
     PP=Pfill(:,idx_fill);
     [fill_R]=evalRBFModel(w_R,PP,C,SIGMA);
     [fill_G]=evalRBFModel(w_G,PP,C,SIGMA);
     [fill_B]=evalRBFModel(w_B,PP,C,SIGMA);
    
     % Assemble reconstructed patch
     patch_rec=patch_fill;
     pr_R=patch_rec(:,:,1);
     pr_G=patch_rec(:,:,2);
     pr_B=patch_rec(:,:,3);
     pr_R(idx_fill)=fill_R;
     pr_G(idx_fill)=fill_G;
     pr_B(idx_fill)=fill_B;
     patch_rec(:,:,1)=pr_R;
     patch_rec(:,:,2)=pr_G;
     patch_rec(:,:,3)=pr_B;

     figure(1);clf;subplot(1,2,1);image(patch);axis image;
     subplot(1,2,2);image(patch_rec);axis image;
    end;

  else
    % Patch does not contain reference colour, copy patch
    fprintf(2,'Copying patch at %d,%d\n',i,j);
    patch_rec=patch_fill;
  end;
  im_rec(j:j+PATCH_SIZE,i:i+PATCH_SIZE,:)=patch_rec;
  
 end;
end;

figure(2);clf;subplot(1,2,1);image(im);axis image;title('Input image');
subplot(1,2,2);image(im_rec);axis image;title('Inpainted with RBF');

return;

