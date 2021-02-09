function [storage,storage_norm] = preprocessing(X, rank, blocksize, maxiter, tolerance)

% storage function
order = ndims(X);
storage  = cell(0, order+1);
storage_norm  = [];
time_length = size(X, order);
num_blocks = 0;
dimensions = size(X);

if mod(time_length, blocksize) == 0 
    num_blocks = fix(time_length/blocksize);
else
    num_blocks = fix(time_length/blocksize) +1 ;
end

Y = permute(X, [order, 1:order-1]);
Y_m = tenmat(Y, 1);

for i=1:num_blocks

% Make a subtensor along a time dimension
    if i == num_blocks

        subtensor = tensor(Y_m(1+(i-1)*blocksize:time_length,:));
        subtensor = reshape(subtensor, [size(subtensor,1), dimensions(1:order-1)]);
        subtensor = tensor(permute(subtensor, [2:order, 1]));
    else
        subtensor = tensor(Y_m(1+(i-1)*blocksize:i*blocksize,:));
        subtensor = reshape(subtensor, [blocksize, dimensions(1:order-1)]);
        subtensor = tensor(permute(subtensor, [2:order, 1]));
    end

    T = tucker_als(subtensor, rank, 'tol', tolerance, 'maxiters', maxiter);
    if i == num_blocks
        test = norm(X(:,:,1+(i-1)*blocksize:time_length)-subtensor)
    else
        test = norm(X(:,:,1+(i-1)*blocksize:i*blocksize)-subtensor)
    end

    for k=1:order
        storage{i, k} = T{k};
    end
    storage{i, order+1} = T.core;
    storage_norm = [storage_norm, norm(T)^2];
end
end

