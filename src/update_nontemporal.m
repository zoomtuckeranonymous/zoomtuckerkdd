function res = update_nontemporal(answer, T, mode)
    res = T;
    factor_size = size(answer{1, mode}, 1);
    num_blocks = size(answer, 1);
    order = length(T)-1;
    core = T{order+1};
    rank = size(core,mode);
    target_FMs = T(1:end-1);
    target_FMs(mode) = [];
    kron_core = double(tenmat(core, mode))*double(tenmat(core, mode)).';
    inv_mat = kron_core;

    block_sum = zeros(factor_size, rank);
    time_factors = T{order};
    time_s = 0;

    for block_ind = 1:num_blocks
        block_FMs = answer(block_ind, 1:end-1);
        block_FMs(mode) = [];
        time_factor_length = size(answer{block_ind, order}, 1);
        target_FMs{order-1} = time_factors(time_s+1:time_s+time_factor_length, :);
        time_s = time_s+time_factor_length;
        block_kron_core= block_FMs{1}.' * target_FMs{1};        
        for j = 2:order-1
           tmp = block_FMs{j}.' * target_FMs{j};
           block_kron_core = kron(tmp, block_kron_core);
        end
        block_kron_core = double(tenmat(answer{block_ind, order+1}, mode))*block_kron_core*double(tenmat(core, mode)).';
        block_sum = block_sum + answer{block_ind, mode}*block_kron_core;                          
    end

    % Post processing, orthogonality and core multiplication
    res_mat = block_sum*inv(inv_mat);
    res{mode} = res_mat;
    [q, r] = qr(res_mat, 0);
%     
    res{mode} = q;    

     res{order+1} = tensor(ttm(core, r, mode));

end
