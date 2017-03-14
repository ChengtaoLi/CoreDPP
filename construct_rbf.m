function [K, L] = construct_rbf(data,sigma,flag_decomp)

n=size(data,1);
K=data*data'/sigma^2;
d=diag(K);
K=K-ones(n,1)*d'/2;
K=K-d*ones(1,n)/2;
K=exp(K);

if flag_decomp
    L = decompose_kernel(K);
else
    L = 0;
end
