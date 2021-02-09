

LASTN = maxNumCompThreads(1);

% Load an input tensor. It is only used for measuring reconstruction errors
fprintf('\nRead an input tensor...\n\n')
path = './stock/stock.mat';
load(path, 'x');
X = x;

X = tensor(X);


% load the results of preprocessing phase
fprintf('\nRead preprocessed results...\n\n')
load('./stock/preprocessed_stock.mat', 'storage', 'storage_norm');


rank = [10, 10, 10];


blocksize = 50;
maxiter = 100;
tolerance = 1e-4;

order = ndims(X);


% 4 exmample time ranges:
% The entire time range
% 2010-2019
% 2015-2018
% Jan. - Apr., 2020
start_time = [1,501, 1740,2967]; 
end_time = [3050,2966, 2720, 3048];

% Zoom-Tucker

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

