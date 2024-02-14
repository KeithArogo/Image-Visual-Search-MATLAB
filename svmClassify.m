%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_computedescriptors.m
%% Skeleton code provided as part of the coursework assessment
%% This code will iterate through every image in the MSRCv2 dataset
%% and call a function 'extractRandom' to extract a descriptor from the
%% image.  Currently that function returns just a random vector so should
%% be changed as part of the coursework exercise.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'visiondemo\cwsolution\MSRC_ObjCategImageDatabase_v2';

%% Create a folder to hold the results...
OUT_FOLDER = 'visiondemo\descriptors';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.
OUT_SUBFOLDER='SVM';

allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
% Initialize variables to store features and labels
% Assuming allfiles is a struct array containing file information
allLabels = cell(length(allfiles), 1);
%metrics = struct([]);

for filenum = 1:length(allfiles)
    % Extract label from filename, assuming the label is the prefix before '_'
    fname = allfiles(filenum).name;
    %label = strsplit(fname, '_');
    %allLabels{filenum} = label{1};  % Use the first part of the split as the label
    allLabels{filenum} = determineLabel(fname);
end


% Create a map for class labels
uniqueLabels = unique(allLabels);
labelMap = containers.Map(uniqueLabels, 1:length(uniqueLabels));

% Convert string labels to numerical labels
allLabelsNumeric = cellfun(@(x) labelMap(x), allLabels);

% Initialize an empty matrix to store features
allFeatures = [];

for filenum = 1:length(allfiles)
    fname = allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n', filenum, length(allfiles), fname);
    tic;
    
    imgfname_full = fullfile(DATASET_FOLDER, 'Images', fname);
    img = double(imread(imgfname_full)) / 255;
    fout = fullfile(OUT_FOLDER, OUT_SUBFOLDER, [fname(1:end-4), '.mat']); % replace .bmp with .mat
    
    % F = extractSpatialGrid(img); % here
    % F = quantangextractSpatialGrid(img);
    % F = extractRandom(img); % here
    % F = modified_extractRandom(img);
    
    % Extract color histogram features
    colorFeatures = extractColour(img);
    huFeatures = computeHuMoments(img);
    gridFeatures = extractSpatialgrid(img);
    
    % Combine color and spatial features
    combinedFeatures = [colorFeatures];
    %combinedFeatures = [huFeatures];
    %combinedFeatures = [colorFeatures, huFeatures];
    %combinedFeatures = [colorFeatures, gridFeatures];
    %combinedFeatures = [huFeatures, gridFeatures];
    %combinedFeatures = [gridFeatures];
    %combinedFeatures = [gridFeatures,colorFeatures,huFeatures];

    % Concatenate features to the feature matrix
    allFeatures = [allFeatures; combinedFeatures];

    % Save features and labels for later evaluation
    save(fout, 'combinedFeatures');
    
    toc
end

% Train an SVM classifier with fitcecoc
% Assuming 'allFeatures' and 'allLabelsNumeric' are your complete dataset
rng(42);  % Set seed for reproducibility

% Shuffle the data
shuffledIdx = randperm(size(allFeatures, 1));
shuffledFeatures = allFeatures(shuffledIdx, :);
shuffledLabels = allLabelsNumeric(shuffledIdx);
%%
% Split the shuffled data
cv = cvpartition(shuffledLabels, 'HoldOut', 0.2); % 0.2 --> 0.56 & 0.3-->
trainIdx = training(cv);

% Training set
trainFeatures = shuffledFeatures(trainIdx, :);
trainLabels = shuffledLabels(trainIdx);

% Testing set
testFeatures = shuffledFeatures(~trainIdx, :);
testLabels = shuffledLabels(~trainIdx);

% Ensure that testLabels is a column vector
testLabels = testLabels(:);

SVMModel = fitcecoc(trainFeatures, trainLabels, 'Learners', templateSVM('Standardize', true));

% Make predictions on the testing set
predictedLabels = predict(SVMModel, testFeatures);

% Evaluate performance
classLabels = unique(allLabels);
%classLabels = unique(allLabelsNumeric);
classNames = classLabels;
%classNames = cellfun(@(x) num2str(x), num2cell(classLabels), 'UniformOutput', false);
%%

%%
for classIndex = 1:20
    % Here, classIndex represents each of your classes
    currentMetrics = evaluatePerformance(testLabels, predictedLabels, classIndex);
    metrics(classIndex) = currentMetrics;
end

for i = 1:length(classLabels)
    % Create the confusion matrix chart for each class
    figure;
    cm = confusionchart(metrics(i).ConfusionMatrix, {['Not ' classLabels{i}], classLabels{i}});
    title(['Confusion Matrix for ', classLabels{i}]);
    xlabel('Predicted Class');
    ylabel('Actual Class');
end

% Initialize the overall confusion matrix
%overallConfMat = zeros(20, 20);

numClasses = 20;
confMat = zeros(numClasses, numClasses);

% Populate the confusion matrix
for i = 1:length(testLabels)
    actualClass = testLabels(i);
    predictedClass = predictedLabels(i);
    confMat(actualClass, predictedClass) = confMat(actualClass, predictedClass) + 1;
end

% Create the confusion matrix chart
figure;
cm = confusionchart(confMat, classLabels);
title('Overall Confusion Matrix');
xlabel('Predicted Class');
ylabel('Actual Class');

% Calculate the sum of all elements in the confusion matrix
totalInstances = sum(confMat, 'all');

% Check the sum
if totalInstances == 118
    disp('The confusion matrix is correctly structured.');
else
    disp(['Discrepancy: The matrix sums to ', num2str(totalInstances), ' instead of 118.']);
end

% Initialize sum of average precision
sumAP = 0;

% Calculate AP for each class and sum them
for i = 1:numClasses
    % Precision for class i
    precision = confMat(i, i) / sum(confMat(:, i));
    
    % In case of NaN, set precision to zero
    if isnan(precision)
        precision = 0;
    end

    sumAP = sumAP + precision;
end

% Calculate MAP
MAP = sumAP / numClasses;

% Display MAP
disp(['Mean Average Precision (MAP): ', num2str(MAP)]);
