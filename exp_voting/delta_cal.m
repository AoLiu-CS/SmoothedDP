function y = delta_cal(h_mat, eeps)
    delta = zeros(6,2);

    h_mat1 = [h_mat(:,2:end), h_mat(:,end)];
    delta(1,:) = delta_temp(h_mat1, h_mat, eeps);
    h_mat2 = [h_mat(:,1), h_mat(:,1:end-1)];
    delta(2,:) = delta_temp(h_mat2, h_mat, eeps);
    h_mat3 = [h_mat(2:end,:); h_mat(end,:)];
    delta(3,:) = delta_temp(h_mat3, h_mat, eeps);
    h_mat4 = [h_mat(1,:); h_mat(1:end-1,:)];
    delta(4,:) = delta_temp(h_mat4, h_mat, eeps);
    h_mat5 = [h_mat2(2:end,:); h_mat2(end,:)];
    delta(5,:) = delta_temp(h_mat5, h_mat, eeps);
    h_mat6 = [h_mat1(1,:); h_mat1(1:end-1,:)];
    delta(6,:) = delta_temp(h_mat6, h_mat, eeps);
   
    y = max(max(delta));
end



function z = delta_temp(mat1, mat2, eeps)
    z = zeros(1,2);
    delta_mat1 = mat1-eeps*mat2;
    delta_mat1(delta_mat1 < 0) = 0;
    z(1) = sum(sum(delta_mat1));
    
    delta_mat2 = mat2-eeps*mat1;
    delta_mat2(delta_mat2 < 0) = 0;
    z(2) = sum(sum(delta_mat2));
end