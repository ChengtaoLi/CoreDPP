function res = getpoly_kernel(L, k)

%res = sympoly(eig(L), k);
e = eig(L);
n = length(e);
c = [1 zeros(1,k)];
for j=1:k
    c(2:(j+1)) = c(2:(j+1)) - e(j).*c(1:j);
end
for j=k+1:n
    c(2:end) = c(2:end) - e(j).*c(1:k);
end
res = abs(c(k+1));