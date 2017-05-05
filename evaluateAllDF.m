function dFdp = evaluateAllDF(params)

global LL_MODEL;

numMeshes = length(LL_MODEL.meshes);

if isempty(params)
    dFdp = [];
    return
end


dFdp = zeros(1, length(params));

for mm = 1:numMeshes
    dFdp = dFdp + ll.evaluateDF(LL_MODEL.meshes{mm}, params);
end

