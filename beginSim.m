function beginSim(varargin)

X.Bounds = [];
X.Frequency = [];
X.PML = [];
X.HMin = '';
X.HMax = '';
X.HGrad = '';
X.Physics = 'maxwell';

X = parseargs(X , varargin{:});

if isnumeric(X.HMax)
    X.HMax = num2str(X.HMax);
end

if isnumeric(X.HMin)
    X.HMin = num2str(X.HMin);
end

global LL_MODEL;

if strcmpi(X.Physics, 'maxwell')
    LL_MODEL = struct('physics', 'maxwell',...
        'bounds', X.Bounds, ...
        'frequency', X.Frequency, ...
        'PML', X.PML, ...
        'PMLBounds', X.Bounds - [1 1 1 -1 -1 -1].*X.PML, ...
        'PMLThickness', max(abs(X.PML)), ...
        'sources', {{}}, ...
        'outputs', {{}}, ...
        'measurements', {{}}, ...
        'materials', {{}}, ...
        'incidentField', struct('Ex', '', 'Ey', '', 'Ez', ''), ...
        'meshes', {{}}, ...
        'hmin', X.HMin, ...
        'hmax', X.HMax, ...
        'hgrad', X.HGrad);
elseif strcmpi(X.Physics, 'poisson')
    LL_MODEL = struct('physics', 'poisson', ...
        'bounds', X.Bounds, ...
        'sources', {{}}, ...
        'outputs', {{}}, ...
        'measurements', {{}}, ...
        'potentials', {{}}, ...
        'forwardCallback', [], ...
        'exports', {{}}, ...
        'materials', {{}}, ...
        'meshes', {{}}, ...
        'parameterizedMeshes', {{}}, ...
        'hmin', X.HMin, ...
        'hmax', X.HMax, ...
        'hgrad', X.HGrad);
end