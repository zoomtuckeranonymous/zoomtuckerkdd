function [T, partial_norm] = partial(X, storage_norm, blocksize, start_index, end_index)
    order = size(X, 2)-1;
    s_blockIndex = ceil(start_index/blocksize);
    e_blockIndex = ceil(end_index/blocksize);
    num_blocks = e_blockIndex-s_blockIndex+1;

    T = cell(num_blocks, order+1);
    partial_norm = zeros(1,num_blocks);
    partial_norm(2:end-1) = storage_norm(s_blockIndex+1:e_blockIndex-1);
    start_point = start_index - (s_blockIndex-1)*blocksize;
    end_point = end_index - (e_blockIndex-1)*blocksize;

    if num_blocks == 1
        e_factor = X{e_blockIndex, order};
        e_factor = e_factor(start_point:end_point, :);
        [Q_e,R_e] = qr(e_factor, 0);
        for i=1:order-1
            T{num_blocks, i} =X{e_blockIndex, i};
        end
        T{num_blocks, order} = Q_e;
        T{num_blocks,order+1} = tensor(ttm(X{e_blockIndex, order+1}, R_e, order));
        partial_norm(num_blocks) = norm(T{num_blocks, order+1})^2;
    else    
    
    % For middle blocks
        for i=1:(num_blocks-2)
            for j=1:order+1
                T{i+1, j} = X{i+s_blockIndex, j};
            end
        end


        %For start block
        s_factor = X{s_blockIndex, order};
        s_factor = s_factor(start_point:blocksize, :);

        for i=1:order-1
            T{1, i} = X{s_blockIndex, i};
        end

       if size(s_factor,1) >= size(s_factor,2)
           [Q_s,R_s] = qr(s_factor,0);
       else
           [Q_s,R_s] = qr(s_factor.');
           tmp = Q_s;
           Q_s = R_s.';
           R_s = tmp.';
       end
       T{1, order} = Q_s;
       T{1, order+1} = tensor(ttm(X{s_blockIndex, order+1}, R_s, order));
        partial_norm(1) = norm(T{1,order+1})^2;

        % For end block
        e_factor = X{e_blockIndex, order};
        e_factor = e_factor(1:end_point, :);
        for i=1:order-1
            T{num_blocks, i} = X{e_blockIndex, i};
        end
        if size(e_factor,1) >= size(e_factor,2)
           [Q_e,R_e] = qr(e_factor,0);
       else
           [Q_e,R_e] = qr(e_factor.');
           tmp = Q_e;
           Q_e = R_e.';
           R_e = tmp.';
       end
        T{num_blocks, order} = Q_e;
        T{num_blocks,order+1} = tensor(ttm(X{e_blockIndex, order+1}, R_e, order));
        partial_norm(num_blocks) = norm(T{num_blocks, order+1})^2;
    
    end
end
