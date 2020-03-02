% CSC C11 - Machine Learning, Fall 2017, Assignment 1, 
% F. Estrada, festrada@utsc.utoronto.ca
%
% A 2D - Radial Basis Function
% 
% [z]=rbf2d(p,c,sigma)
%
% p - is a 2-row matrix, each column gives the coordinates of one
%     point where the rgb is to be evaluated, e.g.
%
%     p=[x_1    x_2   .....    x_n
%        y_1    y_2   .....    y_n]
%
% c - center location for the rbf,  c = [c_x
%                                        c_y]
%
% w - output column vector with one value per input point
%     w_i = RBF(p_i) = exp(-(p_i-c)'*(p_i-c)/(2*sigma^2))
%
% sigma - width of the rbf
%
% ** DO NOT MODIFY THIS FUNCTION **
%

function [z]=rbf2d(p,c,sigma)

 d=p-repmat(c,[1 size(p,2)]);	% Compute the difference between each p_i and the RBF center
 d=sum(d'.^2,2);		% Compute squared distance from each p_i to center
 z=exp(-d./(2*sigma*sigma));	% Evaluate the RBF
 
return;
