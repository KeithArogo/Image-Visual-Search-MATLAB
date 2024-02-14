function huMoments = computeHuMoments(M)
    % Compute Hu moments from the central moments
    huMoments = zeros(1, 7);

    eta = zeros(3, 3);
    eta(1, 3) = (M(3, 1) - 3 * M(1, 3))^2;
    eta(2, 1) = (M(1, 3) + M(3, 1))^2;
    eta(2, 2) = (M(2, 1) - M(1, 3))^2 + 4 * M(1, 2)^2;
    eta(3, 1) = (3 * M(2, 1) - M(1, 3))^2;

    huMoments(1) = eta(2, 1) + eta(1, 2);
    huMoments(2) = (eta(2, 1) - eta(1, 2))^2 + 4 * eta(1, 1)^2;
    huMoments(3) = (eta(3, 1) - 3 * eta(1, 3))^2 + (3 * eta(2, 2) - eta(3, 1))^2;
    huMoments(4) = (eta(3, 1) + eta(1, 3))^2 + (eta(2, 2) + eta(2, 2))^2;
    huMoments(5) = (eta(3, 1) - 3 * eta(1, 3)) * (eta(3, 1) + eta(1, 3)) * ...
        ((eta(3, 1) + eta(1, 3))^2 - 3 * (eta(2, 2) + eta(2, 2))^2) + ...
        (3 * eta(2, 2) - eta(3, 1)) * (eta(2, 2) + eta(2, 2)) * ...
        (3 * (eta(3, 1) + eta(1, 3))^2 - (eta(3, 1) + eta(1, 3))^2);
    huMoments(6) = (eta(2, 1) - eta(1, 2)) * ((eta(3, 1) + eta(1, 3))^2 - ...
        (eta(2, 2) + eta(2, 2))^2) + 4 * eta(1, 1) * (eta(3, 1) + eta(1, 3)) * ...
        (eta(2, 2) + eta(2, 2));
    huMoments(7) = (3 * eta(2, 2) - eta(3, 1)) * (eta(3, 1) + eta(1, 3)) * ...
        ((eta(3, 1) + eta(1, 3))^2 - 3 * (eta(2, 2) + eta(2, 2))^2) - ...
        (eta(3, 1) - 3 * eta(1, 3)) * (eta(2, 2) + eta(2, 2)) * ...
        (3 * (eta(3, 1) + eta(1, 3))^2 - (eta(3, 1) + eta(1, 3))^2);

    % Normalization
    huMoments = huMoments/sum(huMoments);
end
