function [core, group, mapping] = kppseeds_kernel(L,k)

N = size(L,1);
core = zeros(k,1);
mapping = ones(N,1);
group = zeros(k,1);

core(1) = ceil(N*rand);
self = diag(L);
dup = ones(N,1);
dist = inf(N,1);

for i=2:k
    tmp = L(:,core(i-1));
    Y = self + tmp(core(i-1))*dup - 2*tmp;
    olddist = dist;
    dist = min(dist,Y);
    mapping(olddist~=dist) = i-1;
    v = cumsum(dist);
    %core(i) = find(rand < v/v(end),1);
    core(i) = ceil(N*rand);
end
tmp = L(:,core(k));
Y = self + tmp(core(k))*dup - 2*tmp;
olddist = dist;
dist = min(dist,Y);
mapping(olddist~=dist) = k;

for i=1:k
    group(i) = sum(mapping==i);
end