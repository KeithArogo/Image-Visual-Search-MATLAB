```markdown
# EEE3032 – Computer Vision and Pattern Recognition
## Coursework Assignment: Visual Search of an Image Collection

**Overview**

This project explores visual search and image classification techniques, including distance-based retrieval and SVM classification. Key features include:

*   **Global Colour Histograms:** For colour distribution analysis.
*   **Spatial Grid Descriptors:** For localized feature extraction.
*   **Hu Moments:** For shape-based recognition.
*   **PCA:** For dimensionality reduction.
*   **Distance Metrics:** (Euclidean, Mahalanobis, Manhattan, Minkowski, Chi-squared) for similarity measurement.
*   **SVM:** For supervised classification.

Performance is evaluated using Mean Average Precision (MAP) and Precision-Recall (PR) curves.

**Running the Code**

1.  **Visual Search / Distance-Based Classification**

    Execute the visual search algorithm to retrieve similar images based on distance metrics:

    ```matlab
    visualsearch
    ```

    The script runs for 20 iterations, generating retrieval results.

2.  **Extracting the Overall Confusion Matrix**

    After running `visualsearch`, generate the confusion matrix to evaluate performance:

    ```matlab
    plotConfusionmatrix
    ```

3.  **Generating Precision-Recall (PR) Plots**

    After `visualsearch` completes, plot PR curves for individual retrievals (1 to 20):

    ```matlab
    pr_plot(n)  % Replace 'n' with a retrieval number (1 ≤ n ≤ 20)
    ```

4.  **Displaying Retrieved Images**

    View the retrieved images for specific queries:

    ```matlab
    showImages(query_no)  % Replace 'query_no' with a valid query number (see below)
    ```

    **Valid Query Numbers:**

    `[1, 33, 65, 99, 128, 157, 182, 212, 242, 272, 301, 325, 335, 368, 395, 425, 475, 500, 530, 565]`

5.  **Executing SVM Classification**

    Train and evaluate the SVM model for image classification:

    ```matlab
    svmClassify
    ```

    Outputs confusion matrices for each feature set and the overall confusion matrix.

**Key Findings from Experiments**

*   **Global Colour Histograms:**
    *   Optimal performance with 16 bins (MAP: 0.29).
    *   Best distance metric: Minkowski (h=0.5) (MAP: 0.306).
*   **Spatial Grid Descriptors:**
    *   Optimal grid size: 5x5 (SVM accuracy: 0.542).
    *   Combining with global colour features improves MAP to 0.347.
*   **Hu Moments:**
    *   Low performance when used alone (MAP: 0.137).
    *   Best combined with spatial grid + colour features (MAP: 0.258).
*   **SVM vs. Distance-Based Methods:**
    *   SVM outperforms distance-based methods (Highest MAP: 0.617 vs. 0.347).
    *   SVM achieves better generalization across categories.

**Directory Structure**

*   `visualsearch.m`: Main script for distance-based retrieval.
*   `svmClassify.m`: SVM training and evaluation.
*   `plotConfusionmatrix.m`: Generates confusion matrices.
*   `pr_plot.m`: Plots Precision-Recall curves.
*   `showImages.m`: Displays retrieved images.

**Dependencies**

*   MATLAB (tested on R2021a or later).
*   Image Processing Toolbox.
*   Statistics and Machine Learning Toolbox.

**References**

Relevant citations are included in the PDF. For further details, refer to the Bibliography section (Page 16).
```
