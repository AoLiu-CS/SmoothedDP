function delta = delta_motivate(h, eeps)
    h0 = h(1,:);
    h1 = h(2,:);
    h2 = h(3,:);
    
    delta_bin = zeros(1,4);
    
    delta_bin(1) = delta_mc(h0,h1,eeps);
    delta_bin(2) = delta_mc(h1,h0,eeps);
    delta_bin(3) = delta_mc(h0,h2,eeps);
    delta_bin(4) = delta_mc(h2,h0,eeps);
    
    delta = max(delta_bin);
end

function d = delta_mc(h0,h1,eeps)
    h = h0 - eeps*h1;
    h = h( h > 0 );
    d = sum(h);
end

