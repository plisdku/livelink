function measurement(varargin)
% 

global LL_MODEL;

X.Bounds = [];
X.ForwardField = [];
X.DualField = [];
X.Points = [];
X.Function = [];
X.HMax = 2e-3;

X = parseargs(X, varargin{:});

extents = X.Bounds(4:6) - X.Bounds(1:3);

numMeas = length(LL_MODEL.measurements);

exportFilename = sprintf('_export_%i.txt', numMeas);
importFilename = sprintf('_import_%i.txt', numMeas);

if ischar(X.ForwardField)
    X.ForwardField = {{X.ForwardField}};
end

if ischar(X.DualField)
    X.DualField = {{X.DualField}};
end

% Write a provisional import file so COMSOL does not crash
if strcmpi(X.ForwardField{1}, 'V')
    fieldVals = zeros(size(X.Points,1), 1);
elseif strcmpi(X.ForwardField{1}, 'E')
    fieldVals = zeros(size(X.Points,1), 3);
end
exportVals = [X.Points, fieldVals];
dlmbarf(importFilename, exportVals);

measStruct = struct('bounds', X.Bounds, ...
    'dimensions', nnz(extents), ...
    'function', X.Function, ...
    'forwardField', X.ForwardField, ...
    'dualField', X.DualField, ...
    'points', X.Points, ...
    'export', exportFilename, ...
    'hmax', X.HMax, ...
    'import', importFilename);

LL_MODEL.measurements{numel(LL_MODEL.measurements)+1} = measStruct;


