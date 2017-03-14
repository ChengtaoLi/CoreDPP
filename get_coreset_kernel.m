function coreSetKernel = getCoreSetKernel(L, groupSizes)

groupSizes = groupSizes * groupSizes';
coreSetKernel = L .* groupSizes;