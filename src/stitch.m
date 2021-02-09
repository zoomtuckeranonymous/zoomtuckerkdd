function T = stitch(answer, partial_norm, rank, max_iter, tolerance)
    order = size(answer, 2)-1;
    num_blocks = size(answer,1);
    T = cell(1, order+1);
    normX = partial_norm;
    
    time_length = 0;

    for i=1:size(answer, 1)
        time_length = time_length + size(answer{i, order}, 1);
    end
 
    for i=1:order-1
        T{i} = rand(size(answer{1, i}, 1), rank(i));
    end
    
    T{order} = rand(time_length, rank(order));

    T{order+1} = tensor(rand(rank));

    fit = 0;

    for iter=1:max_iter
        fitold = fit;

        for i = 1:order
            if i == order
                T = update_time(answer, T);
            else
                T = update_nontemporal(answer, T, i);
            end
        end

        T = update_core(answer, T);        
        

        normresidual = sqrt( normX - norm(T{order+1})^2 );
        fit = 1 - (normresidual / normX); %fraction explained by model
        fitchange = abs(fitold - fit);


        fprintf(' Iter %2d: fitchange = %7.1e\n', iter, fitchange);
        % Check for convergence
        if (iter > 1) && (fitchange < tolerance)
            num_iter = iter;
            break;
        end    

    end
    

end
