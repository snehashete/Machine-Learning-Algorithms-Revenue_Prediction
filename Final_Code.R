train <- read.csv("train.csv")
test <- read.csv("test.csv")

trow <- nrow(train)
trow
test$revenue <- 1
tr <- train$revenue
godset <- rbind(train,test)
#rm(train,test)
head(godset)
head(train)
library(reshape)
train <- train[train$revenue < 16000000,]
d <- melt(train[,-c(1:5)])
ggplot(d,aes(x = value)) + 
  facet_wrap(~variable,scales = "free_x") + 
  geom_histogram()

library(dplyr)
godset$year <- substr(as.character(godset$Open.Date),7,10) %>% as.factor()
godset$month <- substr(as.character(godset$Open.Date),1,2) %>% as.factor()
godset$day <- substr(as.character(godset$Open.Date),4,5) %>% as.numeric()

godset$Date <- as.Date(strptime(godset$Open.Date, "%m/%d/%Y"))


train$year <- substr(as.character(train$Open.Date),7,10) %>% as.factor()
train$month <- substr(as.character(train$Open.Date),1,2) %>% as.factor()
train$day <- substr(as.character(train$Open.Date),4,5) %>% as.numeric()

train$Date <- as.Date(strptime(train$Open.Date, "%m/%d/%Y"))
train$days <- as.numeric(as.Date("2014-02-02")-train$Date)
train$months <- as.numeric(as.Date("2014-02-02")-train$Date) / 30


test$year <- substr(as.character(test$Open.Date),7,10) %>% as.factor()
test$month <- substr(as.character(test$Open.Date),1,2) %>% as.factor()
test$day <- substr(as.character(test$Open.Date),4,5) %>% as.numeric()

test$Date <- as.Date(strptime(test$Open.Date, "%m/%d/%Y"))
test$days <- as.numeric(as.Date("2014-02-02")-test$Date)
test$months <- as.numeric(as.Date("2014-02-02")-test$Date) / 30

godset$days <- as.numeric(as.Date("2014-02-02")-godset$Date)
godset$months <- as.numeric(as.Date("2014-02-02")-godset$Date) / 30
qplot(revenue/1000000, months, data=train, xlab="Revenue in millions") + geom_smooth() + ggtitle("Life of restaurant (months) vs Revenue")
summary(train)

godset$Id <- godset$Open.Date <- godset$Date <- godset$City <- NULL

train <-  godset[1:trow,]
train$revenue = tr
test <- godset[(trow+1):nrow(godset),]
row.names(test) = NULL

# Random Forest  
library(randomForest)
set.seed(147)
fit = randomForest(revenue~., train, ntree = 1000)
varImpPlot(fit)
predrf = predict(fit, test, type = "response")
predrf1 = predict(fit, train, type = "response")
predrf
#install.packages("Metrics")
library(Metrics)
rfrmse1 <- rmse(train$revenue, predrf1)
rfrmse1








test <- read.csv("test.csv")
train <- read.csv("train.csv")
test$revenue <- predrf
train <- train[train$revenue < 16000000,]



train$Open.Month <- as.factor(format(as.POSIXlt(train$Open.Date,format="%m/%d/%Y"), "%m"))
train$Open.Year <- as.numeric(format(as.POSIXlt(train$Open.Date,format="%m/%d/%Y"), "%Y"))
test$Open.Month <- as.factor(format(as.POSIXlt(test$Open.Date,format="%m/%d/%Y"), "%m"))
test$Open.Year <- as.numeric(format(as.POSIXlt(test$Open.Date,format="%m/%d/%Y"), "%Y"))
train$Open.Date <- as.numeric(as.POSIXlt("01/01/2015",format="%m/%d/%Y") - as.POSIXlt(train$Open.Date, format="%m/%d/%Y"))
test$Open.Date <- as.numeric(as.POSIXlt("01/01/2015",format="%m/%d/%Y") - as.POSIXlt(test$Open.Date, format="%m/%d/%Y"))

summary(train)

str(train)

train$Type <- unclass(train$Type)
test$Type <- unclass(test$Type)
str(test)
test <- subset(test, select = -c(City))
train <- subset(train, select = -c(City))

#to_drop <- test['P3', 'P7', 'P9', 'P10', 'P12', 'P13', 'P14', 'P15', 'P16','P17', 'P18', 'P24', 'P25', 'P26', 'P27', 'P29', 'P31', 'P34', 'P30','P32','P33','P34','P35','P36','P37']

#train <- subset(train, select = -c(P3, P7, P9, P10, P12, P13, P14, P15, P16,P17, P18, P24, P25, P26, P27, P29, P31, P34,P30,P32,P33,P34,P35,P36,P37))








#Logistic Regression

glm_model <- glm(revenue ~., data = train)
summary(glm_model)
glm_model <- glm(revenue ~  City.Group+Open.Date+Type+P8+P26+P28+Open.Year, data = train)
summary(glm_model)
predlr <- predict(glm_model,test)
summary(predlr)
predlr
lrrmse <- rmse(test$revenue, predlr)
lrrmse


summary(test)
summary(train)

trainmatrix <- model.matrix(revenue ~  City.Group+Open.Date+Type+P8+P26+P28+Open.Year, data = train)
testmatrix <- model.matrix(revenue ~  City.Group+Open.Date+Type+P8+P26+P28+Open.Year, data = test)
grid = 10^seq(4, -2, length=100)

#lasso
library(glmnet)
lasso <- glmnet(trainmatrix, train$revenue)
cvlasso <- cv.glmnet(trainmatrix, train$revenue)
bestlambdalasso <- cvlasso$lambda.min
pred.lasso <- predict(lasso, s = bestlambdalasso, newx = testmatrix)
pred.lasso
lassormse <- rmse(test$revenue, pred.lasso)
lassormse




#ridge
ridge <- glmnet(trainmatrix, train$revenue)
glmridge  <- cv.glmnet(trainmatrix, train$revenue)
bestlambda <- glmridge$lambda.min
pred.ridge <- predict(ridge, s = bestlambda, newx = testmatrix)
pred.ridge
ridgermse <- rmse(test$revenue, pred.ridge)
ridgermse



#PCR
library(pls)
pcr <- pcr(revenue ~  City.Group+Open.Date+Type+P8+P26+P28+Open.Year, data = train, scale = TRUE, validation = "CV")
validationplot(pcr, val.type = "MSEP")
predpcr <- predict(pcr, test, ncomp = 4)
predpcr
pcrrmse <- rmse(test$revenue, predpcr)
pcrrmse





#PLS
pls <- plsr(revenue ~  City.Group+Open.Date+Type+P8+P26+P28+Open.Year, data = train, scale = TRUE, validation = "CV")
validationplot(pls, val.type = "MSEP")
predpls <- predict(pls, test, ncomp = 4)
predpls
plsrmse <- rmse(test$revenue, predpls)
plsrmse







#Backward Selection
nmodel<-lm(revenue ~ 1, data = train)
fmodel<-lm(revenue ~  City.Group+Open.Date+Type+P8+P26+P28+Open.Year, data = train)
bwd<-step(fmodel,direction = "backward")
summary(bwd)
bwdpred<-predict(bwd,test)
bwdpred
bwdrmse <- rmse(test$revenue, bwdpred)
bwdrmse


#Stepwise Selection
step <-step(nmodel, scope = list(lower = nmodel, upper = fmodel), 
            direction = "both")
summary(step)
steppred<-predict(step,test)
steppred
steprmse <- rmse(test$revenue, steppred)
steprmse


#Linear Regression
linear_model <- lm(revenue ~  City.Group+Open.Date+Type+P8+P26+P28+Open.Year, data = train)
summary(linear_model)
linear_prediction <- predict(linear_model, test)
linear_prediction
lprmse <- rmse(test$revenue, linear_prediction)
lprmse


#Gradient Boosting Machine
library(gbm)
gbmmodel <- gbm(revenue ~  City.Group+Open.Date+Type+P8+P26+P28+Open.Year,data = train )
predgbm <- predict(gbmmodel, n.trees = gbmmodel$n.trees, test)
predgbm
length(predgbm)
gbmrmse <- rmse(test$revenue, predgbm)
gbmrmse





#SVM 
library(e1071)
svmmodel <- svm(revenue ~  City.Group+Open.Date+Type+P8+P26+P28+Open.Year ,data = train)
svmpred <- predict(svmmodel, test)
points(test$revenue, svmpred, col = "red", pch=4)
svmpred
svmrmse <- rmse(test$revenue, svmpred)
svmrmse



lrrmse
lassormse
ridgermse
pcrrmse
plsrmse
bwdrmse
steprmse
lprmse
gbmrmse
svmrmse
rfrmse1


# Preparing the required output format 
test <- read.csv("test.csv")
final = data.frame(ID = test$Id, Prediction1 = predrf, Prediction2 = predgbm, Prediction3 = predpcr, Prediction4 = pred.lasso, Prediction5 = pred.ridge )
colnames(final)[2] = "RF_Revenue_Prediction"
colnames(final)[3] = "GBM_Revenue_Prediction"
colnames(final)[4] = "PCR_Revenue_Prediction"
colnames(final)[5] = "Lasso_Revenue_Prediction"
colnames(final)[6] = "Ridge_Revenue_Prediction"
write.csv(final, "final.csv", row.names = T)

