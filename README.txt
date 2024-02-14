# EEE3032 – Computer Vision and Pattern Recognition
## Coursework Assignment: Visual Search of an Image Collection

### Running Locally

#### Executing Visual Search/Distance Based Classification
- Run 'visualsearch' in the command window. It runs for 20 iterations.

#### Extracting Overall Confusion Matrix
- Note: This can only work if 'visualsearch' has completed running.
- Run 'plotConfusionmatrix'.
- This will return the overall confusion matrix.

#### Extracting PR Plot for Each of the 20 Retrievals
- Note: This can only work if 'visualsearch' has completed running.
- Run 'pr_plot(n)'.
- This will return the PR plot for the nth retrieval. There are 20 retrievals, so this should not be exceeded.

#### Displaying Retrieved Images in Sequence
- Note: This can only work if 'visualsearch' has completed running.
- Run 'showImages(query_no)'.
- Valid values for 'query_no': [1, 33, 65, 99, 128, 157, 182, 212, 242, 272, 301, 325, 335, 368, 395, 425, 475, 500, 530, 565].

#### Executing SVM
- Run 'svmClassify' in the command window. Upon execution completion, confusion matrices for each of the retrieval categories will be automatically outputted. The overall confusion matrix will also be displayed.
