function [ param ] = expandParamMatrix(param, seg_rows, seg_columns)
    
    [vol_rows, vol_columns] = size(param);
    if vol_rows == 1 && vol_columns == 1
       param = param*ones(seg_rows, seg_columns);
    elseif vol_columns == 1
       if vol_rows ~= seg_rows
          error('Param matrix is incorrect size')
       end
       temp = ones(seg_rows, seg_columns);
       for j = 1:seg_rows
          temp(j,:) = param(j,1)*temp(j,:);
       end
       param = temp;
    end
    [param_rows, param_columns] = size(param);
    if param_rows ~= seg_rows || param_columns ~= seg_columns
          error('Param matrix is incorrect size')
    end

end

