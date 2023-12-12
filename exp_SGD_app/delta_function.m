function y = delta_function(distri, eeps)
    y = zeros(4,1);

    d1 = distri(1,:);
    d2 = distri(2,:);
    d3 = distri(3,:);
    
    delta12 = d1-eeps*d2;
    delta12(delta12<0) = 0;
    y(1) = sum(delta12);
    
    delta21 = d2-eeps*d1;
    delta21(delta21<0) = 0;
    y(2) = sum(delta21);
    
    delta13 = d1-eeps*d3;
    delta13(delta13<0) = 0;
    y(3) = sum(delta13);
    
    delta31 = d3-eeps*d1;
    delta31(delta31<0) = 0;
    y(4) = sum(delta31);
    
    y = max(y);
end