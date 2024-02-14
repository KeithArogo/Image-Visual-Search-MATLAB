function distance = minkowskiDistance(F1, F2, p)
    % Calculate Minkowski distance
    distance = (sum(abs(F1 - F2).^p))^(1/p);
end
