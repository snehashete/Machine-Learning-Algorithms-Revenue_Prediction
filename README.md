# Introduction-to-Data-Science

RANDOM FOREST: A random forest is an ensemble of decision trees created using random variable selection and bootstrap aggregating. At each node of the tree, the split is created according to the random subset of the variables. We applied this algorithm on the training data set, setting the ntree parameter to 1000 with respect to revenue. 

![](Random_Forest.PNG)


LOGISTIC REGRESSION: Logistic Regression is a predictive analysis used to describe the data and to explain the relationship between one dependent binary variable and one/more nominal, ordinal, interval, or ratio-level independent variables. In our data set we used this algorithm to predict revenues with respect to the effective parameters: City.Group, Open.Date, Type, P8, P26, P28, Open.Year. 


LASSO REGRESSION: Lasso Regression is an absolute shrinkage and selection method used for analyzing the performance for both variable selection and regularization to enhance the prediction accuracy and interpretability of the statistical model it generates. To train our data for Lasso Regression, we create a matrix for the training data set considering just the ‘effective predictive variables’. Further, we predict the revenue of restaurants considering the best lambda value while training our data set for Lasso Regression. 


RIDGE REGRESSION: Ridge Regression is a technique for analyzing multiple regression data that suffer from multicollinearity. When it occurs, least squares estimates are unbiased, but their variances are large thus they are far from the true values. The predictor variables we have used in this regression are highly co-related. The regression is performed considering same training matrix that we used in Lasso. A new best lambda value is generated for Ridge. The revenue is now predicted on based on the newest lambda value. 


PRINCIPAL COMPONENT REGRESSION: This is regression analysis technique based on principal component analysis that considers regressing the outcome on a set of predictors based on its standard linear regression model however uses PCA for estimating unknown regression coefficients. We require ‘pls’ library to perform PCR on our training data set considering just the ‘effective predictive variables’. We used Mean Squared Error Prediction validation technique to predict the revenue of the restaurants. 

![](PCR.PNG)


PARTIAL LEAST SQUARE: This algorithm is an extension of multiple linear regression model that specifies the relationship between a dependent variable ‘Y’, and set of predictor variables ‘X’ so that  

Y = b0+b1X1+b2X2+…..+bpXp 

In this equation, b0 is the regression coefficient for the intercept and the bi values are the regression coefficients computed from the data. We again performed PCR on our training data set considering just the ‘effective predictive variables’. We used MSEP validation technique to predict the revenue of the restaurants. 

