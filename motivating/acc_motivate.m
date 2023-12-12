function acc = acc_motivate(h, acc_bound)
    h0 = h(1,:);
    h1 = h(2,:);
    h2 = h(3,:);
    
    acc_bin = zeros(2,1);
    acc_temp = acc_mc(h0, h1);
    acc_temp(acc_temp <= acc_bound) = 0.5;
    acc_bin(1) = dot(acc_temp, h0);
    
    acc_temp = acc_mc(h0, h2);
    acc_temp(acc_temp <= acc_bound) = 0.5;
    acc_bin(2) = dot(acc_temp, h0);
    
    acc = max(acc_bin);
end


function a = acc_mc(p0, p1)
    acc0 = p0./(p1+p0);
    acc1 = p1./(p1+p0);
    
    a = [acc0; acc1];
    a(isnan(a)) = 1;
    a = max(a);
end