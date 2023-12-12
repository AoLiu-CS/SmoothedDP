clear all;
close all;
clc;

dy = xlsread('election_history_1920.xls');

% 100 sigma is enough to cover all mass of the hypergeometric distribution
num_std = 100; 

ratio = 0.998;
% eps = log(0.6/0.4)
% eps = log(0.51/0.49)
eps = 0;
eeps = exp(eps);

util_bound = (eeps-1)/(eeps+1)

year = dy(1,:);
data = dy(2:3,:);

s = size(data);
s = s(2);

delta = zeros(1,s);
utility = zeros(1,s);

for temp = 1:s
    data_temp = data(:,temp);
    data_temp = sort(data_temp);
    
    n1 = data_temp(1);
    n2 = data_temp(2);
    n = n1+n2;
    T = round(n*ratio);
    
    [lb, ub] = bound_cal_hyper(n, n1 ,T, num_std);
    
    p = zeros(3, ub-lb+1);
    p(1,:) = hygepdf(lb:ub, n, n1, T);
    p(2,:) = hygepdf(lb:ub, n, n1+1, T);
    p(3,:) = hygepdf(lb:ub, n, n1-1, T);
    
    idx = sum(p);
    idx = (idx ~= 0);
    p = p(:,idx);
    
    delta(temp) = delta_motivate(p, eeps);
    utility(temp) = utility_motivate(p, util_bound);

end

semilogy(year, 1./sum(data), '-o', 'linewidth', 2.5);
hold on;
semilogy(year, delta, '-p', 'linewidth', 2.5);
hold on;
semilogy(year, utility, '-o', 'linewidth', 2.5);
xlabel('Year')
ylabel('\delta or adversaries'' utility')
set(gca, 'linewidth', 1.1, 'fontsize', 14, 'fontname', 'times')

save(['ub_',num2str(util_bound),'_', num2str(ratio),'_new.mat'], 'delta', 'utility')


function [y1_lb, y1_ub] = bound_cal_hyper(N, n ,K, n_std)
    y_mean = n*K/N;
    y_std = sqrt(n*K/N*(N-K)/N*(N-n)/(N-1));
    y1_lb = round(y_mean-n_std*y_std);
    y1_lb = max([y1_lb, 0]);
    y1_ub = round(y_mean+n_std*y_std);
    y1_ub = min([y1_ub, K]);
end