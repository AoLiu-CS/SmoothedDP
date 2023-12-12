clear all;
close all;
clc;

load('GG_011_10000000.mat')
all1 = delta_smooth_all;

load('GG_012_10000000.mat')
all2 = delta_smooth_all;

delta_smooth_all = zeros(7,10);
delta_smooth_all([1,3,5,7],:) = all1;
delta_smooth_all([2,4,6],:) = all2;

save('GG_01_10000000.mat', 'epsilon_bin', 'delta_smooth_all')