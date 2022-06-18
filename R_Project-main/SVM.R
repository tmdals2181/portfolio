install.packages("e1071")
library(e1071) 

iris
data(iris)

colnames(iris)
levels(iris$Species)

train <- sample(1:150, 100) #무작위로 100개 추출 (학습데이터)
train
(sv <- svm(Species ~., data = iris, subset = train,  type = "C-classification"))
sv
svm(formula = Species ~ ., data = iris, type = "nu-classification", subset = train)


#학습된 SVM 모델로 Test셋 예측하기
predict(sv, iris[-train,])

#정오분류표(confusion matrix) 작성
(tt <- table(iris$Species[-train], predict(sv, iris[-train,])))

#정분류율 및 오불류율 계산
sum(tt[row(tt) == col(tt)])/sum(tt) #정분류율

1-sum(tt[row(tt) == col(tt)])/sum(tt) #오분류율

#SVM 모델 분류모델은 데이터가 사상된 공간에서 경계로 표현되는데 SVM 알고리즘은 그 중 가장 큰 폭(Margin)을 가진 경계를 찾는 알고리즘임. 
#R에서 e1071 패키지의 svm() 함수로 SVM모델을 개발할 수 있음.
###############################################

install.packages("e1071")
library(e1071) 
data(iris)

#degree : 다항커널이 사용될 경우의 모수(차수)이다.
#gamma : 선형을 제외한 모든 커널에 요구되는 모수로, 디폴트는 1/(데이터 차원) 이다.
#coef0 : 다항 또는 시그모이드 커널에 요구되는 모수로, 디폴트는 0 이다.
#cost : 제약 위배의 비용으로, 디폴트는 1 이다.
#cross : k- 중첩 교차타당도에서 k값을 지정한다
svm.e1071 <- svm(Species ~ . , data = iris, type = "C-classification", kernel = "radial", cost = 10, gamma = 0.1) 

summary(svm.e1071)

plot(svm.e1071, iris, Petal.Width ~ Petal.Length, slice = list(Sepal.Width = 3, Sepal.Length = 4))

plot(svm.e1071, iris, Sepal.Width ~ Sepal.Length, slice = list(Petal.Width = 2.5, Petal.Length = 3)) 
# slice= 변수가 2개 이상일 때 상수값을 할당함(assign)
# 아래 그림에서 x: 서포트벡터, o:데이터 점을 나타냄

pred <- predict(svm.e1071, iris, decision.values = TRUE) 

(acc <- table(pred, iris$Species))

#모형의 정확도
classAgreement(acc)
#diag	: Percentage of data points in the main diagonal of tab.
#kappa	: diag corrected for agreement by chance.
#rand	: Rand index.
#crand : Rand index corrected for agreement by chance.

tuned <- tune.svm(Species~., data = iris, gamma = 10^(-6:-1), cost = 10^(1:2))

summary(tuned)

#################################

install.packages("kernlab")
library(kernlab) 

#iris 데이터 살펴보기
data(iris) 
colnames(iris)
levels(iris$Species)

svm.kernlab <- ksvm(Species ~ ., data = iris, type = "C-bsvc", kernel = "rbfdot", kpar = list(sigma = 0.1), C = 10, prob.model = TRUE) 
svm.kernlab 

fit <- fitted(svm.kernlab) 
par(mfrow=c(2,2)) 
plot(fit, iris[,1], main="Sepal.Length") 
plot(fit, iris[,2], main="Sepal.Width")  
plot(fit, iris[,3], main="Petal.Length")  
plot(fit, iris[,4], main="Petal.Width")  
par(mfrow=c(1,1))

head(predict(svm.kernlab, iris, type= "probabilities")) 

head(predict(svm.kernlab, iris, type = "decision")) 
table(predict(svm.kernlab, iris), iris[,5]) 

#######################
# SVR
# 분석용 자료 생성 
x <-c(1:20) 
y <- c(3,4,8,4,6,9,8,12,15,26,35,40,45,54,49,59,60,62,63,68)  
data<-data.frame(x, y)
plot(data, pch=16) 
model <- lm(y ~ x, data) 
abline(model)
lm.error <- model$residuals # same as data$Y - predictedY 
(lmRMSE <- sqrt(mean(lm.error^2)))

model <- svm(y ~ x , data)
pred.y <- predict(model, data) 
points(data$x, pred.y, col = "red", pch=4) # pch=4는 ‘x’임
error <- data$y - pred.y
svmRMSE <- sqrt(mean(error^2)) 

#초모수 최적화
tuneResult <- tune(svm, y ~ x, data = data, ranges = list(epsilon = seq(0,1,0.1), cost = 2^(2:9))) 
print(tuneResult) 
plot(tuneResult)

tuneResult <- tune(svm, y ~ x, data=data, ranges = list(epsilon=seq(0,0.2,0.01), cost=2^(2:9))) # 168개 모수 조합 
print(tuneResult) 
plot(tuneResult)

# 최적 모형 찾기
tunedModel <- tuneResult$best.model  
tpred.y <- predict(tunedModel, data)  
error <- data$y - tpred.y 
tsvmRMSE <- sqrt(mean(error^2)) 
tsvmRMSE 


#모수에 대한 조절(tuning) 전과 후의 SVR을 적합한 결과를 그림
plot(data, pch=16) 
points(data$x, pred.y, col = "red", pch=4, type="b")  
points(data$x, tpred.y, col = "blue", pch=4, type="b")

###############################
