function chiSquaredDistance = chisquaredDistance(hist1, hist2)
    % Compute Chi-Squared Distance
    chiSquaredDistance = sum((hist1 -(hist1 + hist2)).^2 ./ (hist1 + hist2));

end
