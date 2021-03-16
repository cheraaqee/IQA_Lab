A feature-based-no-reference method can extract a feature vector out of the
test image. This feature vector (we're gonna call it `feactor' from here on)
can be fed into a support vector regressor (SVR) to map it to a score. The SVR
needs labeled data to get trained.
Here, we need you to provide us with a function that generates the feactor for
an image. The function should be called in matlab as:
>> feactor = feactorator(image);
where `feactor' is a 1xN vectors and `N' is the number of features or attributes.
We then train a SVR using LibSVM library on the desired datasets.
SVRs have two parameters, `cost' and 'gamma', which their values must be 
determined manually. The convention for optimizing these parameters and the 
train procedure are adopted from [1].

(current supported datasets:
- MLIVE

)

[1] Xue, W., Mou, X., Zhang, L., Bovik, A. C., & Feng, X. (2014).
Blind image quality assessment using joiont statistics of gradient magnitude and laplacian features.
IEEE Transactions on Image Processing, 23(11), 4850-4862
