% main script to plot parameter accuracy when fitting time dependent diffusion
% was used to generate figure 6 in "Time-dependent diffusion MRI in cancer: 
% tissue modeling and applications" (Reynaud, Frontiers 2017)

% load fit results for OGSE / POMACE / IMPULSED frameworks
load ('Fit_results_for_figures.mat');

% % Alternatively, you can re-do the analysis (takes time) using:
% script_accuracy_OGSE
% script_accuracy_POMACE
% script_accuracy_IMPULSED
% clear all;
% load ('Accuracy_SNR120_OGSE.mat');
% load ('Accuracy_SNR120_POMACE.mat');
% load ('Accuracy_SNR120_IMPULSED.mat');

% plot results using
createfigure_TDD(parm_list_ogse) % for OGSE data
createfigure_TDD(parm_list_pomace) % for POMACE
createfigure_TDD(parm_list_impulsed) % for IMPULSED