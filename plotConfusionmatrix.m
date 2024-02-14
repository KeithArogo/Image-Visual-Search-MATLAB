function plotConfusionmatrix(all_class_labels)
    global all_class_labels;

    % Define pre-defined labels for actual and predicted values
    actualLabels = {'grass', 'trees', 'building', 'aerocraft', 'Cows', 'Humans', 'cars', 'bikes', 'sheep', 'flowers', 'signboards', 'ducks', 'books', 'seats', 'cats', 'dogs', 'street(s)', 'boats/ships', 'Full Body Human', 'Water Body'}; % Add more as needed
    predictedLabels =  {'grass', 'trees', 'building', 'aerocraft', 'Cows', 'Humans', 'cars', 'bikes', 'sheep', 'flowers', 'signboards', 'ducks', 'books', 'seats', 'cats', 'dogs', 'street(s)', 'boats/ships', 'Full Body Human', 'Water Body'}; % Add more as needed

    % Initialize confusion matrix
    numLabels = numel(actualLabels);
    confMatrix = zeros(numLabels);

    % Iterate through all_class_labels
    for i = 1:numel(all_class_labels)
        % Get ground truth label
        trueLabel = all_class_labels{i}{1};

        % Find index of true label in actualLabels
        trueLabelIdx = find(strcmp(trueLabel, actualLabels));

        % Iterate through the actual labels of what was predicted
        for j = 2:numel(all_class_labels{i})
            % Get actual label of what was predicted
            predLabel = all_class_labels{i}{j};

            % Find index of actual label in predictedLabels
            predLabelIdx = find(strcmp(predLabel, predictedLabels));

            % Update confusion matrix
            confMatrix(trueLabelIdx, predLabelIdx) = confMatrix(trueLabelIdx, predLabelIdx) + 1;
        end
    end

    % Plot Confusion Matrix
    confusionchart(confMatrix, actualLabels, 'RowSummary', 'total-normalized');
end
