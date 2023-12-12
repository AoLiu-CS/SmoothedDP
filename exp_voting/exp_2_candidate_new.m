clear all;
close all;
clc;

ratio = 0.998;
n_bin = 1e5:5e4:5e5;
l_n = length(n_bin);

epsilon_bin = [0.1, 0.5:0.5:10];
l_eps = length(epsilon_bin);
eeps_bin = exp(epsilon_bin);

num_grid = 32;

dy = xlsread('election_history_1920.xls');

votes = dy(2:3,:);
votes = votes';
votes_all = sum(votes,2);
distribution = votes./votes_all;

% compute the convex hull of the distributions
CH = [min(distribution(:,1)); max(distribution(:,1))];
% By symmetry, the distribution of (p,1-p) the equivalent with (1-p, p)
CH(1) = 0.5;

% grid the convex hull
grid_CH = 0:1/(num_grid-1):1;

delta_SDP = zeros(l_eps, l_n, num_grid);

poolobj = parpool('local',8);
for temp_n = 1:l_n
    tic
    n = n_bin(temp_n);    % The number of agents
    T = round(n*ratio);
    
    % calculate the delta when the database has more than half of 1
    start_n = floor(n/2)-1;
    h_prob1 = hygepdf(0:T, n, start_n, T);
    delta_mat = zeros(n+1, l_eps); 
    for temp_N = start_n+1:n
        h_prob2 = hygepdf(0:T, n, temp_N, T);
        delta_mat(temp_N, :) = delta_cal_2(h_prob1, h_prob2, eeps_bin);
        h_prob1 = h_prob2;
    end
    
    % The other half of delta-matrix by symmetry
    delta_mat(end,:) = delta_mat(end-1,:);
    delta_mat(1:start_n-1, :) = delta_mat(end:-1:end-(start_n-2),:);
    
    
    parfor temp_grid = 1:num_grid
        grid_current = grid_CH(temp_grid);
        % The agents following the first distribution
        n1 = round(n*grid_current);
        y1 = binopdf(0:n1, n1, CH(1));
        
        % The agents following the second distribution
        n2 = n-n1;
        y2 = binopdf(0:n2, n2, CH(2));
        
        % The distribution of the summation
        y = conv(y1,y2);
        
        for temp_eps = 1:l_eps
            delta_SDP(temp_eps, temp_n, temp_grid) = y*delta_mat(:,temp_eps);
        end
        
    end
    
    disp(['n = ', num2str(n), ' completed...'])
    disp(['delta_SDP = ', num2str(max(delta_SDP(5, temp_n,:)))])
    toc
end

semilogy(n_bin, max(delta_SDP,[],3))
hold on;
semilogy(n_bin,1./n_bin,'--r')

delete(poolobj)
save(['ratio_', num2str(ratio), '_acc_history.mat'],'delta_SDP','n_bin','epsilon_bin','num_grid')