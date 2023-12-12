function y = delta_cal2(h1, h2, eeps)
    z1 = h1-eeps*h2;
    z1(z1 < 0) = 0;
    z1 = sum(z1);
    
    z2 = h2-eeps*h1;
    z2(z2 < 0) = 0;
    z2 = sum(z2);
    
    y = max([z1,z2]);
end
