function maxima = siftlocalmax(F, threshold, pdims)
    % Check inputs
    if nargin < 2
        threshold = -Inf;
    end

    if nargin < 3
        pdims = ndims(F);
    end

    % Get the dimensions of F
    dims = size(F);
    M = dims(1);
    N = dims(2);

    if numel(dims) == 2 && pdims == -1 && (M == 1 || N == 1)
        pdims = 1;
        M = max(M, N);
        N = 1;
        dims = [M, N];
    end

    if pdims < 0
        pdims = numel(dims);
    end

    if pdims > numel(dims)
        error('P must not be greater than the number of dimensions');
    end

    % Prepare for local maxima search
    maxima = [];
    offsets = [1, cumprod(dims(1:end-1))];
    neighbors = getNeighbors(pdims, offsets);
    nneighbors = size(neighbors, 1);

    % Iterate over elements in F
    for i = 2:M-1
        for j = 2:N-1
            pt = F(i, j);
            isGreater = pt >= threshold;

            % Check against all neighbors
            for k = 1:nneighbors
                neighborIndex = [i, j] + neighbors(k, :);
                isGreater = isGreater & (pt > F(neighborIndex(1), neighborIndex(2)));
            end

            % Add local maximum
            if isGreater
                maxima = [maxima; sub2ind(dims, i, j)];
            end
        end
    end
    maxima = reshape(maxima, [], 1);
end

function neighbors = getNeighbors(pdims, offsets)
    neighbors = [];
    for i = -1:1
        for j = -1:1
            if pdims == 2 && ~(i == 0 && j == 0)
                neighbors = [neighbors; i, j];
            end
        end
    end
end
