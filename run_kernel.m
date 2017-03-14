function [mapping, group, core] = run_kernel(L, kmeans_k, k, maxiter, nn)

%% test 
[newCore,newGroup,newMapping] = kppseeds_kernel(L,kmeans_k);
lastCore = zeros(length(newCore),1);

% update
iter = 1;
while any(lastCore~=newCore) 
    if iter > maxiter
        break;
    end
    lastCore = newCore;
    
    fprintf('\niter %d, ', iter);
    [newMapping, newGroup, newCore] = optimize_greedy_kernel(L, newMapping, newGroup, newCore, k, nn);
    
    iter = iter + 1;
end

mapping = newMapping;
group = newGroup;
core = newCore;




