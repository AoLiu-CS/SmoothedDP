function y = delta_ca2(h_mat, eeps)
    S = size(h_mat);
    S = S(2);
    delta = zeros(S, 4);
    
    h_mat1 = [h_mat(:,2:end), h_mat(:,end)];
    delta(:,1) = delta_temp(h_mat, h_mat1, eeps);
    delta(:,2) = delta_temp(h_mat1, h_mat, eeps);

    h_mat2 = [h_mat(:,1), h_mat(:,1:end-1)];
    delta(:,3) = delta_temp(h_mat, h_mat2, eeps);
    delta(:,4) = delta_temp(h_mat2, h_mat, eeps);
    
    y = max(delta,[],2);
end

function z = delta_temp(mat1, mat2, eeps)
    delta_mat1 = mat1-eeps*mat2;
    delta_mat1(delta_mat1 < 0) = 0;
    z = sum(delta_mat1);
end