
path = './stock/stock.mat';
load(path, 'x');
X = x;

X = tensor(X);
LASTN = maxNumCompThreads(1);

rank = [10, 10, 10];

blocksize = 50;
maxiter = 100;
tolerance = 1e-4;

[storage, storage_norm] = preprocessing(X, rank, blocksize, maxiter, tolerance);

fprintf('Save preprocessed results... ');
save('./stock/preprocessed_stock.mat', 'storage', 'storage_norm');
fprintf('Preprocessing phase is done\n\n');

