

LASTN = maxNumCompThreads(1);

% load an input tensor. It is only used for measuring reconstruction errors
fprintf('\nRead an input tensor...\n\n')
path = './sample/sample_input.mat';
load(path, 'X');

X = tensor(X);


% load the results of preprocessing phase

fprintf('\nRead preprocessed results...\n\n')
load('./sample/preprocessed_sample.mat', 'storage', 'storage_norm');

rank = [10, 10, 10];

%pool = [128];

blocksize = 50;
maxiter = 100;
tolerance = 1e-4;

% storage function
order = ndims(X);


% 4 example time ranges:
start_time = [1,59, 1374,867]; 
end_time = [397,1973, 1821, 1123];


num_queries = size(start_time,2);


for i=1:num_queries
    fprintf('The start time is %d and the end time is %d\n', start_time(i), end_time(i));
    fprintf('\nRunning Zoom-Tucker...\n')
    zoom_tic = tic;
    [partial_result, partial_norm] = partial(storage, storage_norm, blocksize, start_time(i), end_time(i));
    stitch_result = stitch(partial_result, partial_norm, rank, maxiter, tolerance);
    zoom_toc = toc(zoom_tic);
    fprintf('Elapsed time of Zoom-Tucker is %3f\n', zoom_toc);
    result = tensor(ttm(stitch_result{order+1}, stitch_result(1:order), [1:order]));
    Y = X(:,:,start_time(i):end_time(i));
    normX = norm(Y)^2;
    differ1 = norm(Y-result)^2/normX;
    fprintf('Reconstruction error of Zoom-Tucker is %3f\n\n', differ1);
end


