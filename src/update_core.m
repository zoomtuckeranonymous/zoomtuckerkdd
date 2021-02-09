function res = update_core(answer, T)


    res = T;
    num_blocks = size(answer, 1);
    order = length(T)-1;
    core = T{order+1};
    rank = size(core,1);
    target_FMs = T(1:end-1);


    block_sum = tenzeros(size(answer{1, order+1}));
    time_factors = T{order};
    time_s = 0;
    for i = 1:num_blocks
        block_FMs = answer(i, 1:end-1);
        time_factor_length = size(answer{i, order}, 1);
        target_FMs{order} = time_factors(time_s+1:time_s+time_factor_length, :);
        time_s = time_s+time_factor_length;

       fac_mul = cellfun(@(x, y) x.'*y, target_FMs, block_FMs, 'UniformOutput', false); 
       block_sum = block_sum + tensor(ttm(answer{i, order+1}, fac_mul));
    end


    res{order+1} = block_sum;

end
