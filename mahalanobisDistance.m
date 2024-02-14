function mahalanobisDist = mahalanobisDistance(F1, F2)
    % needed to compute covariance
    global ALLFEAT;    

    % Combine the vectors into a matrix for covariance calculation
    data = ALLFEAT;

    % Compute the covariance matrix
    CovarianceMatrix = cov(data);

    % Calculate Mahalanobis distance
    diff = F1 - F2;
    mahalanobisDist = sqrt(diff * 1/(CovarianceMatrix + eye(size(CovarianceMatrix))) * diff');

    return;
end
