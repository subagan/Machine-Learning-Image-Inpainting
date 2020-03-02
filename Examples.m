% Examples of usage of functions in the starter code
% (you can copy/paste these examples onto a Matlab or Octave terminal)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rbf2d.m  -  Returns the value of an RBF with the specified center and width, 
%             at a point or sequence of points.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p=[1	% <- x coordinate for the point
   1];  % <- y coordinate for the point
   
c=[1	% <- x coordinate for the RBF's center
   1];  % <- y coordinate for the RBF's center
   
sigma=2;    %  RBF's width
   
[y]=rbf2d(p,c,sigma)

% Should yield y=1, since p=c, now try p away from c

p=[.5		
   -.75];

[y]=rbf2d(p,c,sigma)

% You can evaluate the rbf at multiple locations

p=[1  .5   .25		% <- x coordinates of 3 points
   1 -.75  -1.5];	% <- y coordinates of 3 points

[y]=rbf2d(p,c,sigma)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TrainRBRegression.m  -  Returns the least-squares optimal weights for a given  
%                     	  model consisting of RBFs with centers C, width sigma,
%                         and for data z correponding to points P
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This won't produce a result until you've implemented your solution, it's here
% to show you how this function would be called to fit a model for a specific
% function.

% Below, we are setting up to approximate a function for which have measured
% values (in vector z) at each of 7 locations (specified in array P). We
% want to fit a model with 4 RBFs, with centers given by array C. All RBFs
% have width=3

C=[0  3  6  9				% RBF center locations
   0  2  5  7];
   
P=[.5   1  2.5   3.5   4    6.25  8     % Location of points for which we have
   .25  1  1.75  2.5   4    5     8];   % measured data for our function

z=[-1.5 -1 .25   2  3.5  .5  -1]';   	% Values of our function at points in P
					% NOTICE the transpose! z is a COLUMN vector!

sigma=3;

[w]=TrainRBFRegression(z,P,C,sigma)

% TrainRBFRegression_regularized.m works in the same way, except it has an additional
% parameter for the regularization amount lambda.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% evalRBRmodel.m  -  Given a model consisting of a set of RBF centers, their width,
%                    and estimated weights for each RBF, it evaluates the RBF
%		     model at the specified points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This won't work until you've implemented your solution. Same as above, it's here
% to help you understand how this function is used, and how it would be called.

% In the example above (for TrainRBFRegression), we had data values at 7 points.
% Let's evaluate the RBF model trained above at the same data points and see if
% it actually approximates the measured values in z above.

[zz]=evalRBFModel(w,P,C,sigma)

% This will display the measured (z) and estimated (zz) values side by side. 
% They should be close!
[z zz]	
		
% Of course, what you'd really want to do is evaluate the RBF model at points
% OTHER than the ones for which you have input data...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RBF_image_inpainting - Performs image inpainting by training RBF models for
%                        image patches using your regression code. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Remove text from the jellyfish image, using RBFs whoce centers are 3 units
% apart, and which have a width of 2. The script returns the original and inpainted
% images. 
% When run, the script will display the input image and ask you to click on a pixel
% that identifies the COLOR of the elements to be removed. Click on a pixel in the
% red text for the jellyfish image, or if your are trying your own image, select
% a pixel from the region(s) you want removed.
[im,im_inpainted]=RBF_image_inpainting('Amazing_jellyfish_corrupted_by_text.tif',3,2);

