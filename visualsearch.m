%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch.m
%% Skeleton code provided as part of the coursework assessment
%%
%% This code will load in all descriptors pre-computed (by the
%% function cvpr_computedescriptors) from the images in the MSRCv2 dataset.
%%
%% It will pick a descriptor at random and compare all other descriptors to
%% it - by calling cvpr_compare.  In doing so it will rank the images by
%% similarity to the randomly picked descriptor.  Note that initially the
%% function cvpr_compare returns a random number - you need to code it
%% so that it returns the Euclidean distance or some other distance metric
%% between the two descriptors it is passed.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'visiondemo/cwsolution/MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = 'visiondemo/descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
DESCRIPTOR_SUBFOLDER='globalRGBhisto';

% Specify the ground truth folder
GROUND_TRUTH_FOLDER = fullfile(DATASET_FOLDER, 'GroundTruth');
ALLFILES = cell(1, 0);
allfiles = dir(fullfile([DATASET_FOLDER, '/Images/*.bmp']));

% Initialize as global variables
global ALLFEAT;
global allDisplays;
global all_precisions_list;
global all_recalls_list;
global all_class_labels;

% Initialize arrays for storing values
ALLFEAT = [];
all_precisions_list = [];
all_recalls_list = [];
all_class_labels = [];

average_precisions = [];
% Preallocate a cell array to store the results
allDisplays = cell(length(allfiles), 1);
all_models_relevantindices = cell(length(allfiles), 1);
totalTime = 0;

specified_indices = [1,33,63,97,128,157,182,212,242,272,301,335,363,395,422,468,497,530,565,570];
loop_count = 0;
for queryimg = [1,33,65,99,128,157,182,212,242,272,301,325,335,368,395,425,475,500,530,565]% Iterate through all images in the dataset
    loop_count = loop_count + 1;
    
    % Start the timer
    tic;

    % Load descriptors
    ctr = 1;
    for filenum = 1:length(allfiles)
        fname = allfiles(filenum).name;
        imgfname_full = ([DATASET_FOLDER, '/Images/', fname]);
        img = double(imread(imgfname_full))./255;
        thesefeat = [];
        featfile = [DESCRIPTOR_FOLDER, '/', DESCRIPTOR_SUBFOLDER, '/', fname(1:end-4), '.mat']; % replace .bmp with .mat
        load(featfile, 'F');
        ALLFILES{ctr} = imgfname_full;
        % Concatenate feature vectors
        ALLFEAT = [ALLFEAT; F];
        ctr = ctr + 1;
    end
    
    % Compute distances
    NIMG = size(ALLFEAT, 1);
    dst = [];
    for i = 1:NIMG
        candidate = ALLFEAT(i, :);% candidate descriptors
        query = ALLFEAT(queryimg, :);
        %thedst = euclideanDistance(query, candidate); % 0.30
        %thedst = mahalanobisPCA(query, candidate); % 0.30
        %thedst = mahalanobisDistance(query, candidate);
        %thedst = l1Distance(query, candidate); % 0.32
        thedst = minkowskiDistance(query, candidate,0.5);% p0.8=0.324 & p0.5=0.34 & p0.4=0.34
        %thedst = chisquaredDistance(query, candidate); %0.25
        dst = [dst; [thedst i]];
        distance_index = dst;%
    end
    dst = sortrows(dst, 1); % sort the results
    

    %% Visualize results
    
    counter = 0;
    for SHOW = 1:10  % Loop through SHOW values from 1 to 10
        current_dst = dst(1:SHOW, :);
        outdisplay = [];
        for i = 1:size(current_dst, 1)
            img = imread(ALLFILES{current_dst(i, 2)});
            img = img(1:2:end, 1:2:end, :);
            img = img(1:81, :, :);
            outdisplay = [outdisplay img];
        end
    
    % Save the current outdisplay into the cell array
    allDisplays{queryimg} = outdisplay;
       
        %% Calculate Precision and Recall

        relevant_instance_count = 0;
        gtrelevant_indices = [];
        [~, filename, ~] = fileparts(ALLFILES{queryimg});
        query_number_str = regexp(filename, '^(\d+)_', 'tokens', 'once');
        if ~isempty(query_number_str)
            query_number = str2double(query_number_str{1});
        else
            query_number = NaN;
        end
        
        % goes through all the img files to find relevant images according
        % to filename, all relevant images are stores in an array 'gtrelevant_indices'
        for i = 1:length(allfiles)
            file_number_str_cell = regexp(allfiles(i).name, '^(\d+)_', 'tokens');
            if ~isempty(file_number_str_cell)
                file_numbers = cellfun(@(x) str2double(x{1}), file_number_str_cell);
                if any(~isnan(file_numbers) && isequal(query_number, file_numbers))
                    gtrelevant_indices = [gtrelevant_indices i];
                end
            end
        end

        total_number_of_relevant_instances = length(gtrelevant_indices);
        threshold = current_dst(SHOW, 1);
        %models_relevantindices = find(distance_index(:, 1) <= threshold);
        models_relevantindices = find(distance_index(:, 1) <= threshold);
        
        % Sort the indices based on the corresponding threshold values
        [sorted_thresholds, sorted_indices] = sort(distance_index(models_relevantindices, 1));
        
        % Now, models_relevantindices contains the indices sorted based on threshold values
        models_relevantindices = models_relevantindices(sorted_indices);

        % we check if the models relevant indices are accurate 
        counter = 0;
        for i = 1:length(models_relevantindices)
            if ismember(models_relevantindices(i), gtrelevant_indices)
                counter = counter + 1;
                %disp('RELEVANT');
            else
                %disp('IRRELEVANT');
            end
        end

        num_relevant_retrieved = counter;
        total_retrieved = length(models_relevantindices);
        total_relevant = total_number_of_relevant_instances;

    end

   % Calculate Average Precision for the current query image
    relevant_indices = ismember(distance_index(:, 2), gtrelevant_indices);
    num_relevant_items = sum(relevant_indices);
    
    % Display Results for each SHOW value
    disp(['Results for Query Image ', num2str(queryimg)]);
    relevance_count = 0;
    relevant_precisions = [];
    precision_list = [];
    recall_list = [];

    for SHOW = 1:10
       
        disp(['SHOW = ', num2str(SHOW)]);
        if ismember(models_relevantindices(SHOW), gtrelevant_indices)
                disp('RELEVANT ADDITION');
                relevance_count = relevance_count + 1;
                prec = relevance_count / SHOW;% in order to calculate precision after each retrieval
                % Add the value to the array
                relevant_precisions = [relevant_precisions, prec];
                %rec = relevance_count / total_number_of_relevant_instances;
                rec = relevance_count / 10;
            else
                disp('IRRELEVANT ADDITION');
                prec = relevance_count / SHOW;
                rec = relevance_count / 10;
        end

        precision_list = [precision_list, prec];
        recall_list = [recall_list, rec];
        
        disp(['Total Relevant so far = ', num2str(relevance_count)]);
        disp(['Precision: ', num2str(prec)]);
        disp(['Recall: ', num2str(rec)]);
        disp('-------------------------------------------');
    end
    % Calculate Average Precision
    average_precision = sum(relevant_precisions)/10;
    average_precisions = [average_precisions, average_precision];

    % Display Average Precision
    disp(['Number of Relevant Items: ', num2str(num_relevant_retrieved)]);
    disp(['Average Precision: ', num2str(average_precision)]);
    disp('-------------------------------------------');

    % Stop the timer
    elapsedTime = toc;

    % Accumulate the time
    totalTime = totalTime + elapsedTime;

    % Display the time for the current iteration in minutes
    disp(['Query no. ', num2str(queryimg), ': ', num2str(totalTime/60), ' minutes']);

    % Clear ALLFEAT for the next iteration
    ALLFEAT = [];

    all_models_relevantindices{queryimg} = models_relevantindices;
    % Extract filenames based on indices
    filenames_for_iteration = allfiles(models_relevantindices);
    
    % Determine class labels based on filename patterns using the function
    for idx = 1:numel(filenames_for_iteration)
        filename = filenames_for_iteration(idx).name;
        class_labels_for_iteration{idx} = determineLabel(filename);
    end

    % Store class labels for the current iteration
    all_class_labels{loop_count} = class_labels_for_iteration;

    % add precision values fro current query image to the array
    all_precisions_list = [all_precisions_list; precision_list];
    all_recalls_list = [all_recalls_list; recall_list];

end

% After the loop, calculate average precision for all query images
avg_precision = mean(average_precisions);

%% Output overall results

disp('-------------------------------------------');
disp('Overall Results for All Images:');
disp(['Mean Average Precision: ', num2str(avg_precision)]);
disp('-------------------------------------------');

