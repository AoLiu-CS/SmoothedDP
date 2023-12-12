function y = delta_cal_2(h1, h2, eeps_bin)
    one_mat = ones(size(eeps_bin));

    z1 = one_mat.*h1'-eeps_bin.*h2';
    z1(z1 < 0) = 0;
    z1 = sum(z1);
    
    z2 = one_mat.*h2'-eeps_bin.*h1';
    z2(z2 < 0) = 0;
    z2 = sum(z2);
    
    y = max([z1;z2]);
end
