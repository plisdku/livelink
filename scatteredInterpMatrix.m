function [interpMatrix] = scatteredInterpMatrix(xyz_tet, xs, ys, zs)
% scatteredInterpMatrix  Interpolation matrix from points to Cartesian grid
%
% [M,R] = scatteredInterpMatrix(xyz_sample, xz, ys, zs)
%
% M: interpolation matrix
% R: the volume-normalized restriction matrix
%
% xyz_sample Nx3 coordinates of sample points
% xs         linear array of Cartesian grid x coordinates (size Nx)
% ys         linear array of Cartesian grid y coordinates (size Ny)
% zs         linear array of Cartesian grid z coordinates (size Nz)
%
% v_Cartesian = M*v_sample  is size [Nx*Ny*Nz,1].
% It can be reshaped to size [Nx Ny Nz], i.e. corresponding to coords in
% ndgrid(xs,ys,zs).

ravel = @(A) A(:);

[xx,yy,zz] = ndgrid(xs,ys,zs);
xyz = [xx(:),yy(:),zz(:)];

numTetPoints = size(xyz_tet,1);
numCartPoints = size(xyz,1);

[xyz_tet, ia, ic] = unique(xyz_tet, 'rows');
DT = delaunayTriangulation(xyz_tet(:,1), xyz_tet(:,2), xyz_tet(:,3));

%% Get tet index for each grid point

[triIndex, baryCoords] = pointLocation(DT, xyz);
triVerts = DT.ConnectivityList;

%% Get volume of each tet, for the normalized restriction

numTets = size(triVerts,1);
tetVolumes = zeros(numTets,1);
for ii = 1:numTets
    tetVolumes(ii) = tetVolume(xyz_tet(triVerts(ii,:),:));
end

%% Get volume associated with each tet vertex
% 
% tetVertAdjacency = sparse(ia(triVerts(:)), repmat(1:numTets,1,4), ...
%     ones(numel(triVerts),1));
% 
% vertVol = 0.25*tetVertAdjacency*tetVolumes;

%% Build interpolation matrix

rows = ravel(repmat(1:numCartPoints, [4,1]));
cols = ia(ravel(transpose(triVerts(triIndex,:))));
vals = ravel(transpose(baryCoords));

interpMatrix = sparse(rows, cols, vals, numCartPoints, numTetPoints);

%% Build restriction matrix
% 
% divideByVol = spdiags(...
%     1./vertVol, 0, numel(vertVol), numel(vertVol));
% normalizedRestriction = divideByVol * transpose(interpMatrix);

end



function vol = tetVolume(xyz_tet)

sides = bsxfun(@plus, xyz_tet(2:4,:), -xyz_tet(1,:));
vol = 0.5*det(sides);

end
