clear all;
close all;
clc;

% we sample the dataset by num_exp - times
num_exp = 200;

% repeat the batch-sampling process by num_sample - times
num_sample = 1e6;

% we assume the two distributions are both Gaussian
mu = [0,0];
sigma = [0.12, 0.12];

% The size of training set N and the batch size T
N_bin = 100:25:250;

epsilon_bin = 0.5:0.5:5;
num_interval = 5;

% The ratio of data following the first distribution
ratio_bin = 0:1/(num_interval-1):1;

% num_bit-bit quanitzation
num_bit = 8;
% range of gradient: (-0.5, 0.5]  %% This is by default
range_half = 2^(num_bit-1);

eeps_bin = exp(epsilon_bin);

l_eps = length(eeps_bin);
delta_smooth_all = [];

poolobj = parpool('local',6);
delta_save = cell(1,length(N_bin));


for temp_N = 1:length(N_bin)
N = N_bin(temp_N);
T = round(sqrt(N));
%% Generate the data


tic
data = zeros(length(ratio_bin), num_exp, N);
for temp_ratio = 1:length(ratio_bin)
    ratio = ratio_bin(temp_ratio);
    n1 = round(N * ratio);
    n2 = N - n1;
    
    parfor temp_exp = 1:num_exp
        
        % generate n1 data following the first distribution
        data1_temp = [];
        while length(data1_temp) < n1
            temp_data = normrnd(mu(1), sigma(1), 1, 100);
            temp_data = ceil(temp_data * range_half*2);
            temp_data(temp_data > range_half) = [];
            temp_data(temp_data < -range_half+1) = [];
            data1_temp = [data1_temp, temp_data];
            if length(data1_temp) >= n1
                data1_temp = data1_temp(1:n1);
            end
        end
       
        
        % generate n2 data following the second distribution
        data2_temp = [];
        while length(data2_temp) < n2
             temp_data = laprnd(1, 100, mu(2), sigma(2));
            temp_data = ceil(temp_data * range_half*2);
            temp_data(temp_data > range_half) = [];
            temp_data(temp_data < -range_half+1) = [];
            data2_temp = [data2_temp, temp_data];
            if length(data2_temp) >= n2
                data2_temp = data2_temp(1:n2);
            end
        end
        
        
        
        data_temp = [data1_temp, data2_temp];
        data(temp_ratio, temp_exp, :) = data_temp;
    end
end
toc

%% Get the distribution by sampling

tic
delta = zeros(length(ratio_bin), num_exp, l_eps);
for temp_ratio = 1:length(ratio_bin)
    ratio = ratio_bin(temp_ratio);
    n1 = round(N * ratio);
    n2 = N - n1;
    
    parfor temp_exp = 1:num_exp
        data_temp = data(temp_ratio, temp_exp, :);
        data_temp = reshape(data_temp, 1, N);
        
        % We the worst-case must be one of the following:
        %   1. the minimum is changed to the max-possible data
        [~, I] = min(data_temp);
        data_temp_1 = data_temp;
        data_temp_1(I) = range_half;
        
        %   2. the maximum is changed to the min-possible data
        [~, I] = max(data_temp);
        data_temp_2 = data_temp;
        data_temp_2(I) = -range_half+1;
        
        distri = zeros(3, 2^num_bit);  % save the distributions
        for temp_sample = 1:num_sample 
            idx_temp = randsample(N,T);
            sample_raw = data_temp(idx_temp);
            sample_raw = round(mean(sample_raw))+range_half;
            distri(1,sample_raw) = distri(1,sample_raw)+1;
            
            sample_1 = data_temp_1(idx_temp);
            sample_1 = round(mean(sample_1))+range_half;
            distri(2,sample_1) = distri(2,sample_1)+1;
            
            sample_2 = data_temp_2(idx_temp);
            sample_2 = round(mean(sample_2))+range_half;
            distri(3,sample_2) = distri(3,sample_2)+1;
        end
        distri = distri/num_sample;
        
        for temp_eps = 1:l_eps
            eeps = eeps_bin(temp_eps);
            delta(temp_ratio, temp_exp, temp_eps) = delta_function(distri, eeps);
        end
    end
end
toc

delta_save{temp_N} = delta;

delta_smooth = mean(delta, 2);
delta_smooth = max(delta_smooth, [], 1);
delta_smooth = reshape(delta_smooth, [1,l_eps]);

delta_smooth_all = [delta_smooth_all; delta_smooth];
end


delete(poolobj)
figure, 
semilogy(N_bin, delta_smooth_all(:,5))

save(['GL_012_',num2str(num_sample),'_',num2str(num_exp),'.mat'],'epsilon_bin','delta','delta_smooth_all','delta_save')