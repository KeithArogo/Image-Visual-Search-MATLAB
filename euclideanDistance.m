function dst = euclideanDistance(F1, F2)
    epsilon = 1e-6;  
    
    F1 = F1 / (norm(F1) + epsilon);
    F2 = F2 / (norm(F2) + epsilon);
    dst = sqrt(sum((F1 - F2).^2));

    return;
end

