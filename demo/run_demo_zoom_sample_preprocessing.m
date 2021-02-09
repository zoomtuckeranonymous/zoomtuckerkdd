

R_true = [10 10 10]; % True tensor rank
I = [100 100 2000]; % Tensor size
noise_level = 1e-3; % Amount of noise added to nonzero elements
fprintf('Generating dense tensor... ');
G_true = tensor(randn(R_true));
A_true = cell(length(R_true),1);
for k = 1:length(R_true)
    A_true{k} = randn(I(k),R_true(k));
    [Qfac, ~] = qr(A_true{k}, 0);
    A_true{k} = Qfac;
end
X = tensor(ttensor(G_true, A_true)) + noise_level*randn(I);
fprintf('Done!\n\n');

LASTN = maxNumCompThreads(1);

rank = [10, 10, 10];

blocksize = 50;
maxiter = 100;
tolerance = 1e-4;

[storage, storage_norm] = preprocessing(X, rank, blocksize, maxiter, tolerance);

if ~exist('./sample', 'dir')
    mkdir('./sample')
end

fprintf('Save preprocessed results... ');
save('./sample/preprocessed_sample.mat', 'storage', 'storage_norm');
fprintf('Save dense tensor... ');
save('./sample/sample_input.mat', 'X', '-v7.3');
fprintf('Preprocessing phase is done\n\n');

