function dist = l1Distance(F1, F2)
    % Ensure vectors are of the same size
    assert(length(F1) == length(F2), 'Vectors must be of the same size.');

    % Calculate L1 distance
    dist = sum(abs(F1 - F2));
end
