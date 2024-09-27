# EEE3032 – Computer Vision and Pattern Recognition
## Coursework Assignment: Visual Search of an Image Collection

### Running Locally

#### Executing Visual Search/Distance-Based Classification
- Run `visualsearch` in the command window. It will run for 20 iterations.

#### Extracting the Overall Confusion Matrix
- **Note**: This can only be executed after `visualsearch` has completed running.
- Run `plotConfusionmatrix`.
- This will generate and return the overall confusion matrix.

#### Extracting PR Plot for Each of the 20 Retrievals
- **Note**: This can only be executed after `visualsearch` has completed running.
- Run `pr_plot(n)`.
- This will return the PR plot for the nth retrieval. Since there are 20 retrievals, ensure `n` does not exceed this limit.

#### Displaying Retrieved Images in Sequence
- **Note**: This can only be executed after `visualsearch` has completed running.
- Run `showImages(query_no)`.
- Valid values for `query_no`: [1, 33, 65, 99, 128, 157, 182, 212, 242, 272, 301, 325, 335, 368, 395, 425, 475, 500, 530, 565].

#### Executing SVM
- Run `svmClassify` in the command window. Once execution completes, confusion matrices for each retrieval category will be automatically outputted, along with the overall confusion matrix.
