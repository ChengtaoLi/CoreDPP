function [newMapping, newGroup, newCore] = optimize_greedy_kernel(L, mapping, group, core, k, nn)

% each element of group is the group size
newMapping = mapping;
newGroup = group;
newCore = core;

N = size(L,1);
M = length(group);
smpl = 1;  

groupSizes = sqrt(group);

while smpl <= N
    if mod(smpl,200) == 0
        fprintf('\t%d', smpl);
    end
    
    % get index and corresponding group
    currGroup = newMapping(smpl);
    currGroupSize = newGroup(currGroup);
    
    if currGroupSize <= 1 || newCore(currGroup) == smpl 
        smpl = smpl + 1;
        continue;
    end
    
    % tmp stat
    minGroup = currGroup;
    
    %% find nearest neighbor group to switch 
    tmpGroupSizes = groupSizes;
    tmpGroupSizes(currGroup) = sqrt(currGroupSize - 1);
    tmpidx = [newCore; smpl];
    tmpCoreSetKernel = get_coreset_kernel(L(tmpidx,tmpidx), [tmpGroupSizes; 1]);
    
    maxProb = 0;
    distance = diag(tmpCoreSetKernel) - 2 * tmpCoreSetKernel(:,end);
    [~, distidx] = sort(distance(1:end-1),'ascend');
    distidx = distidx(1:nn);
    
    % can acc
    for idx = 1:length(distidx)
    	i = distidx(idx);
        tmpC = tmpCoreSetKernel;
        tmpC(i,:) = [];
        tmpC(:,i) = [];
        tmpv = tmpC(1:end-1,end);
        tmpProb = getpoly_kernel(tmpC(1:end-1,1:end-1) - tmpv * tmpv' / tmpC(end,end),k-1);
        
        if tmpProb > maxProb
            maxProb = tmpProb;
            minGroup = i;
        end
    end  

    %% update data and group
    
    if currGroup ~= minGroup
        % update mapping
        newMapping(smpl) = minGroup;
        
        % update group
        newGroup(currGroup) = newGroup(currGroup) - 1;
        newGroup(minGroup) = newGroup(minGroup) + 1;
        groupSizes(currGroup) = sqrt(newGroup(currGroup));
        groupSizes(minGroup) = sqrt(newGroup(minGroup));
   
        tmpCore = newCore;
        tmpCore(minGroup) = smpl;
        
        if getpoly_kernel(get_coreset_kernel(L(tmpCore,tmpCore), groupSizes),k) > ...
                getpoly_kernel(get_coreset_kernel(L(newCore,newCore), groupSizes),k)
            newCore(minGroup) = smpl;
        end
    end

    smpl = smpl + 1;
end
fprintf('\n');

smpl = 1;
loc = ones(M,1);
while smpl <= N
    currGroup = newMapping(smpl);
    loc(currGroup) = loc(currGroup) + 1;
    smpl = smpl + 1;
end