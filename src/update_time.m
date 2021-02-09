function res = update_time(answer, T)

    res = T;
    order = length(T)-1;
    factor_size = size(answer{1, order}, 1);
    num_blocks = size(answer, 1);
    core = T{order+1};
    rank = size(core, order);
    target_FMs = T(1:order-1);
    kron_core = double(tenmat(core, order))*double(tenmat(core, order)).';            
    inv_mat = kron_core;

    block_concat = cell(num_blocks, 1);
    for block_ind = 1:num_blocks
        block_FMs = answer(block_ind, 1:order-1);
        block_kron_core = block_FMs{1}.' * target_FMs{1};
        for j = 2:order-1
            tmp = block_FMs{j}.' * target_FMs{j};
           block_kron_core = kron(tmp, block_kron_core);
        end


        block_kron_core = double(tenmat(answer{block_ind, order+1}, order))* ...
                    block_kron_core*double(tenmat(core, order)).';
        block_concat{block_ind,1} = block_kron_core*inv(inv_mat);
    end

    block_mul = cellfun(@(x,y) x*y, answer(:, order), block_concat, 'UniformOutput', false); 
    block_mul = cell2mat(block_mul);

    % Post processing, orthogonality and core multiplication

    res{order} = block_mul;
    [q, r] = qr(block_mul, 0);
    res{order} = q;
    res{order+1} = tensor(ttm(core, r, order));


end
