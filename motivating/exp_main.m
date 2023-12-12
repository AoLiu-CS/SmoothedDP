clear all;
close all;
clc;

n = 100;
ratio = 0.9;
T = n*ratio;
GT = 81268924/(81268924 + 74216154)

n_mean = round([0, GT*(n-1)]);

figure,

for temp = 1:length(n_mean)
    n_mean_temp = n_mean(temp);
    p0 = hygepdf(0:T,n,n_mean_temp,T);
    p1 = hygepdf(0:T,n,n_mean_temp+1,T);
    p = [p1; p0];
    x0 = 0:T;
    indicator0 = max(p);
    indicator0 = indicator0 > 0;
    p = p(:,indicator0);
    x0 = x0(indicator0);
    
    subplot(1,3,temp)
    %rectangle('Position',[0,0,1,1],'FaceColor',[0 .5 .5],'LineWidth',0)
    
    
    bar(x0/T, p','FaceColor','flat');
    xlabel('Ratio of votes for demoncratics')
    ylabel('Probability')
    
    if temp == 1
        set(gca,'XTick',[0, 0.01])
    end
    
    p0 = p(1,:);
    p1 = p(2,:);
    
    acc0 = p0./(p1+p0);
    acc1 = p1./(p1+p0);
    
    acc = [acc0; acc1];
    acc = max(acc);
    
    yyaxis right
    plot(x0/T, acc, '-o', 'linewidth', 2.5);
    ylim([0.5,1])
    ylabel('Adversaries'' hypothesis testing accuracy')
    
    set(gca, 'linewidth', 1.1, 'fontsize', 14, 'fontname', 'times')
end


subplot(1,3,3)
pdf_bi = binopdf(0:n, n, GT);
plot((0:n)/n, pdf_bi, '-', 'linewidth', 2.5);