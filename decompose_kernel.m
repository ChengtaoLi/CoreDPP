function L = decompose_kernel(M)
  L.M = M;
  [V,D] = eig(M);
  L.V = real(V);
  L.D = max(0,real(diag(D)));