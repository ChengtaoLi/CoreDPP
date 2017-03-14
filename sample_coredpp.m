function Y = sample_coredpp(L, groupSmpl, k)

dppCores = sample_dpp(L,k);
Y = zeros(k,1);

for i = 1:k
    Y(i) = randsample(groupSmpl{dppCores(i)}, 1);
end

