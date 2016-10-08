function interpMatrix = scatteredInterpMatrix(xyz_tet, xs, ys, zs)
% scatteredInterpMatrix  Interpolation matrix from points to Cartesian grid
%
% M = scatteredInterpMatrix(xyz_sample, xz, ys, zs)
%
% xyz_sample Nx3 coordinates of sample points
% xs         linear array of Cartesian grid x coordinates (size Nx)
% ys         linear array of Cartesian grid y coordinates (size Ny)
% zs         linear array of Cartesian grid z coordinates (size Nz)
%
% v_Cartesian = M*v_sample  is size [Nx*Ny*Nz,1].
% It can be reshaped to size [Nx Ny Nz], i.e. corresponding to coords in
% ndgrid(xs,ys,zs).


[xx,yy,zz] = ndgrid(xs,ys,zs);
xyz = [xx(:),yy(:),zz(:)];

numTetPoints = size(xyz_tet,1);
numCartPoints = size(xyz,1);

[xyz_tet, ia, ic] = unique(xyz_tet, 'rows');
DT = delaunayTriangulation(xyz_tet(:,1), xyz_tet(:,2), xyz_tet(:,3));

%% Get tet index for each grid point

[triIndex, baryCoords] = pointLocation(DT, xyz);
triVerts = DT.ConnectivityList;

%% Build interpolation matrix


ravel = @(A) A(:);
rows = ravel(repmat(1:numCartPoints, [4,1]));
cols = ia(ravel(transpose(triVerts(triIndex,:))));
vals = ravel(transpose(baryCoords));

interpMatrix = sparse(rows, cols, vals, numCartPoints, numTetPoints);
