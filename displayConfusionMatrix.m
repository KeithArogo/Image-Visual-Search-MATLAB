function displayConfusionMatrix(confMat, classNames)
    figure;
    imagesc(confMat);
    colorbar;
    
    % Set axis labels
    xticks(1:length(classNames));
    yticks(1:length(classNames));
    xticklabels(classNames);
    yticklabels(classNames);
    
    % Label the axes
    xlabel('Predicted');
    ylabel('Actual');
    
    % Display the values in the cells
    for i = 1:length(classNames)
        for j = 1:length(classNames)
            text(j, i, num2str(confMat(i, j)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
        end
    end
    
    title('Confusion Matrix');
end
