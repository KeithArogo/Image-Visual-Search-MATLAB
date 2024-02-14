# EEE3032 – Computer Vision and Pattern Recognition
# Coursework Assignment
# Visual Search of an Image Collection

# Running Locally

### Excecuting Visual Search/Distance Based Classification
- Run 'visualsearch' in the command window - It runs for 20 iterations.

### Exracting overall confusion matrix.
- N/B this can only work if 'visualsearch' has completed running.
- Run 'plotConfusionmatrix'. 
- This will return the overall confusion matrix.

### Exracting pr plot for each of the 20 retrievals
- N/B this can only work if 'visualsearch' has completed running.
- Run 'pr_plot(n)'. 
- This will return the pr plot for the nth retrieval.
- There are 20 retrievals so this should not be exceeded

### Displaying retrieved images in sequence
- N/B this can only work if 'visualsearch' has completed running.
- Run 'showImages(query_no)'.
- Valid values for query_no - [1,33,65,99,128,157,182,212,242,272,301,325,335,368,395,425,475,500,530,565]   

### Excecuting SVM
- Run 'svmClassify' in the command window - on excecution completion, confusion matrices for each of the retrieval categories will be automatically outputted. 
- The overall confusion matrix will also be displayed.