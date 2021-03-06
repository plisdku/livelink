function addMesh(varargin)
% addMesh    

X.Mesh = [];
X.Material = 1;
X.Voltage = [];
X.SurfaceCharge = [];
X.Conductivity = 0;
X.Parameters = [];
X.HMax = '';
X.HMin = '';
X.HGrad = '';
X.Exclude = 0;

X = parseargs(X, varargin{:});

if isnumeric(X.HMax)
    X.HMax = num2str(X.HMax);
end

if isnumeric(X.HMin)
    X.HMin = num2str(X.HMin);
end

global LL_MODEL;

m = X.Mesh.meshes(X.Parameters);
v = m{1}.patchVertices;
f = m{1}.faces;
jac = m{1}.jacobian;

if ~isempty(X.Voltage) && ~isempty(X.SurfaceCharge)
    error(['Both Voltage and SurfaceCharge specified (this is ' ...
        'Dirichlet and Neumann)']);
end

%numMeshes = numel(LL_MODEL.meshes);
%fname = sprintf('mesh_%i.stl', numMeshes+1);
%ll.meshToSTL(X.Mesh, fname);

if isa(X.Voltage,'function_handle')
    Voltage = X.Voltage(X.Parameters);
    
    vjac = dmodel.jacobian(X.Voltage, X.Parameters);
    
    
else
    Voltage = X.Voltage;
    vjac = 0*X.Parameters';
    
end 



meshStruct = struct('material', X.Material, 'mesh', X.Mesh, ...
    'voltage', Voltage, 'surfacecharge', X.SurfaceCharge,...
    'vertices', v, 'faces', f, 'jacobian', jac, 'voltagejacobian', vjac, ...
    'hmax', X.HMax, 'hgrad', X.HGrad, 'hmin', X.HMin, 'exclude', X.Exclude);

%LL_MODEL.parameterizedMeshes{end+1} = X.Mesh;
LL_MODEL.meshes{numel(LL_MODEL.meshes)+1} = meshStruct; % put parameterized Mesh into Mesh

