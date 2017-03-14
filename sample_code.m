%% Sample code for usage of CoreDPP
%   kmeans_k    -> size of the coreset
%   k           -> size of the subset being sampled
%   maxiter     -> max number of iterations to run for constructing coreset
%   nn          -> number of nearest neighbors to be considered when 
%                  constructing coresets

% Experiment Setup
kmeans_k = 10;
k = 5;
maxiter = 3;
nn = 2; 

N = 1000;
sigma = 6;
data = randn(N,10);
[K, ~] = construct_rbf(data,sigma,false);

fprintf('\nkmeans_k=%d\tk=%d\n', kmeans_k, k);

% Construct coreset
[mapping, group, core] = run_kernel(K, kmeans_k, k, maxiter, nn);

% Preprocessing groups
group_smpl = cell(1,kmeans_k);
for i = 1:kmeans_k
    group_smpl{i} = find(mapping == i);
end

% Get CoreDPP kernel
group_sizes = sqrt(group);
L = get_coreset_kernel(K(core,core), group_sizes);
L = decompose_kernel(L);

% Sample from CoreDPP
Y = sample_coredpp(L, group_smpl, k);

fprintf('\nSampled Subset from CoreDPP: ');
fprintf('%d ', Y);
fprintf('\n');

