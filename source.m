function source(varargin)

X.Bounds = [];
X.Jx = '0';
X.Jy = '0';
X.Jz = '0';
X.Mx = '0';
X.My = '0';
X.Mz = '0';

X = parseargs(X, varargin{:});

extents = X.Bounds(4:6) - X.Bounds(1:3);

numSrc = length(LL_MODEL.sources);
selectionName = sprintf('measurement_%d', numSrc);

srcStruct = struct('bounds', X.Bounds, ...
    'dimensions', nnz(extents), ...
    'selectionName', selectionName, ...
    'Jx', X.Jx, 'Jy', X.Jy, 'Jz', X.Jz, ...
    'Mx', X.Mx, 'My', X.My, 'Mz', X.Mz);

global LL_MODEL;
LL_MODEL.sources{numel(LL_MODEL.sources)+1} = srcStruct;


% need selectionName (?)
% need dimensions
% need extent