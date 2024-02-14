function mahalanobisDist = mahalanobisPCA(F1, F2)
    global ALLFEAT;

    %Store the current warning state
    %currentWarningState = warning;

    % Turn off all warnings
    warning('off', 'all');

    
    % Perform PCA on the dataset
    [coeff, ~, ~, ~, explained] = pca(ALLFEAT);
    

    % Choose the number of components to keep
    numComponents = find(cumsum(explained) >= 95, 1, 'first');

    % Select the principal components
    pcaBasis = coeff(:, 1:numComponents);

    % Transpose F1 and F2 to column vectors
    F1 = F1';
    F2 = F2';

    % Project F1 and F2 onto the PCA space
    F1_pca = pcaBasis' * F1;
    F2_pca = pcaBasis' * F2;

    % Compute the covariance matrix in the PCA space
    CovarianceMatrix = cov(ALLFEAT * pcaBasis);

    % Calculate the difference in PCA space
    diff = F1_pca - F2_pca;

    % Calculate Mahalanobis distance in the PCA space
    mahalanobisDist = sqrt(diff' * inv(CovarianceMatrix) * diff);

    return;
end
