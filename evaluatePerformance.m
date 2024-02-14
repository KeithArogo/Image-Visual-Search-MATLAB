function performanceMetrics = evaluatePerformance(actualLabels, predictedLabels, currentClass)
    
    % Convert labels to binary.
    binaryActualLabels = (actualLabels == currentClass);
    binaryPredictedLabels = (predictedLabels == currentClass);

    % Compute confusion matrix
    confMat = confusionmat(binaryActualLabels, binaryPredictedLabels);
    
    % Calculate TP,FP,FN,TN based on the binary confusion matrix
    TP = confMat(2, 2);
    FP = confMat(1, 2);
    FN = confMat(2, 1);
    TN = confMat(1, 1);

    % Accuracy for one-vs-all
    accuracy = (TP + TN) / sum(confMat(:));

    % Precision, Recall, and F1 Score
    precision = TP / (TP + FP);
    recall = TP / (TP + FN);
    f1Score = 2 * (precision * recall) / (precision + recall);

    % Incase precision or recall is 0
    if isnan(precision)
        precision = 0;
    end
    if isnan(recall)
        recall = 0;
    end
    if isnan(f1Score)
        f1Score = 0;
    end

    % store metrics for the current class
    performanceMetrics = struct('ConfusionMatrix', confMat, ...
                                'Accuracy', accuracy, ...
                                'Precision', precision, ...
                                'Recall', recall, ...
                                'F1Score', f1Score);
end
