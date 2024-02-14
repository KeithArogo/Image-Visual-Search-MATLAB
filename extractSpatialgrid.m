function histFeatures = extractSpatialgrid(img)
    % Default parameters
    gridSize = [2, 2];%[2,2]-db [5,5]-svm
    numNeighbors = 4; % 4 - db 5-svm
    uprightFlag = true;

    %size of the image
    [height, width, ~] = size(img);

    %spatial grid parameters
    regionSize = [height, width] ./ gridSize;

    histFeatures = [];

    %extract Local Binary Pattern
    for i = 1:gridSize(1)
        for j = 1:gridSize(2)
            
            %region of interest
            rowStart = round((i - 1) * regionSize(1)) + 1;
            rowEnd = round(i * regionSize(1));
            colStart = round((j - 1) * regionSize(2)) + 1;
            colEnd = round(j * regionSize(2));

            %Extract for each channel
            lbpFeatures = [];
            for channel = 1:3
                channelImage = img(rowStart:rowEnd, colStart:colEnd, channel);
                lbp = extractLBPFeatures(channelImage, 'Upright', uprightFlag);
                lbp = lbp(:, 1:numNeighbors);
                lbpFeatures = [lbpFeatures, lbp];
            end
            % Concatenate 
            histFeatures = [histFeatures, lbpFeatures];
        end
    end

    % Normalize the histogram to have a unit sum
    histFeatures = histFeatures / sum(histFeatures);

    % Reshape the feature vector into a row vector
    histFeatures = histFeatures(:)';
end
