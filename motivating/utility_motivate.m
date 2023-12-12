function u = utility_motivate(h, util_bound)
    h0 = h(1,:);
    h1 = h(2,:);
    h2 = h(3,:);
    
    u_bin = zeros(2,1);
    
    u_temp = util_mc(h0, h1, util_bound);
    u_bin(1) = dot(u_temp, h0);
    
    u_temp = util_mc(h0, h2, util_bound);
    u_bin(2) = dot(u_temp, h0);
    
    u = max(u_bin);
end


function util = util_mc(p0, p1, util_bound)
    util = abs(p0-p1)./(p1+p0);
    util = util - util_bound;
    util(util < 0) = 0;
    util = util/(1-util_bound);
    util(isnan(util)) = 1;
end