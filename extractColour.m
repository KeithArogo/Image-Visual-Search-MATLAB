function histFeatures = extractColour(img)
    % number of bins
    numBins = 16; 

    % red green blue channels
    redChannel = img(:,:,1); 
    greenChannel = img(:,:,2);
    blueChannel = img(:,:,3);

    % Compute histograms for each channel
    redHist = imhist(redChannel, numBins);
    greenHist = imhist(greenChannel, numBins);
    blueHist = imhist(blueChannel, numBins);

    % Concatenate a feature vector
    histFeatures = [redHist; greenHist; blueHist];

    % Normalize 
    histFeatures = histFeatures / sum(histFeatures);

    histFeatures = histFeatures(:)';
end
