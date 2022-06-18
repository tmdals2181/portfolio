## 과제1
##주택 가격 예측(입력 노드 수의 변경)

# 데이터 확인 
install.packages("neuralnet")
install.packages("MASS")
library(neuralnet)
library(MASS)

head(Boston)

# 분석 대상 데이터 할당
data <- Boston[, c(1,2,3,4,5,6,7,8,9,10,11,12,13,14)]
head(data)

# 결측치 확인 
na <- apply(data, 2, is.na)
na
apply(na, 2, sum)

# 데이터 정규화
maxs <- apply(data, 2, max) 
maxs
mins <- apply(data, 2, min) 
mins
data.scaled <- scale(data, center = mins, scale = maxs - mins)
data.scaled


















## 과제2
## 붓꽃 종의 분류(은닉층 노드 수의 변경)

# 데이터 확인
install.packages("neuralnet")
library(neuralnet)

iris

data <- iris

# 결측치 확인
na <- apply(data, 2, is.na)
na

apply(na, 2, sum)

# 데이터 정규화
maxs <- apply(data[,1:4], 2, max)
maxs

mins <- apply(data[,1:4], 2, min)
mins

data[,1:4] <- scale(data[,1:4], center = mins, scale = maxs - mins)
data[,1:4]

# 출력 데이터 생성
data$setosa     <- ifelse(data$Species == "setosa", 1, 0)
data$virginica  <- ifelse(data$Species == "virginica", 1, 0)
data$versicolor <- ifelse(data$Species == "versicolor", 1, 0)
head(data)

# 학습용과 테스트용 데이터 분리
n <- nrow(data)

set.seed(2000)
index <- sample(1:n, round(0.8*n))
index

train <- as.data.frame(data[index,])
head(train)

test <- as.data.frame(data[-index,])
head(test)

# 학습용 입출력 데이터
f.var.independent <- "Sepal.Length + Sepal.Width + Petal.Length + Petal.Width"
f.var.dependent   <- "setosa + versicolor + virginica"
f <- paste(f.var.dependent, "~", f.var.independent)
f

# 학습 및 모형 출력
nn <- neuralnet(f, data=train, hidden=c(6, 4), linear.output=F)
plot(nn)
