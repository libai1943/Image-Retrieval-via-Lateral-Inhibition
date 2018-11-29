% ==============================================================================
% MATLAB Source Codes for "An Evolutionary Approach for Image Retrieval Based on Lateral Inhibition". 
% ==============================================================================
%   Copyright (C) 2016 Bai Li
%   Users must cite the following articles when utilizing these source codes. 
%   (1) B. Li, An Evolutionary Approach for Image Retrieval Based on Lateral Inhibition, Optik - International Journal for Light and
%   Electron Optics (2016), http://dx.doi.org/10.1016/j.ijleo.2016.02.056
%
%   (2) B. Li et al. Image enhancement via lateral inhibition: An analysis
%   under illumination changes. Optik - International Journal for Light and
%   Electron Optics (2016), http://dx.doi.org/10.1016/j.ijleo.2016.02.054
% ============================================================================================================================================

clear all
close all
clc
warning off

global template
global test

template = imread('template1.bmp');
test = imread('test1.bmp');

N = 3; % Number of "rings" in Lateral Inhibition weight matrix
MAT = LI(N); % Generation of Lateral Inhibition weight matrix via the methodology introduced in our publication http://dx.doi.org/10.1016/j.ijleo.2016.02.054

template = LItrans(double(rgb2gray(template)), MAT);
test = LItrans(double(rgb2gray(test)), MAT);


figure (1)
imshow(rgb2gray(imread('test1.bmp')))
figure (2)
imshow(uint8(test));
% Figure 1 depicts the original image, whereas Figure 2 presents the effect
% of Lateral Inhibition.



maxTime = 5; % Assigin the maximum CPU time for each runtime 5 seconds.
runtime = 10; % Assigin the repeated run time for statistical significance,
% nontheless, this variable should be set no smaller than 30 so as to lead
% to any safe statistical significance conclusion.
NP = 40;

% The following function helps do optimization via ABC. The first output
% provideds all the best ever solutions in each repeated run, and the
% second output reports the current-best solution quality in each
% iteration.

[CB,abc] = run_ABC(NP,runtime,maxTime);
% The following function can help you draw the matching results in one
% figure: The first input CB stands for solutions in the form of vector;
% the second input control how thin the match box should be; the thrid input determines
% the RBG vector for changing colors; and the last input assigns the figure
% window number. Besides that, the only output reports the test image with all the matching results plotted altogether.

I_result = plot_result(CB,1,[0,128,255],3);
% We can save it via:
imwrite(I_result,'IR_result.bmp','bmp')