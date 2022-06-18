## 13.3 보스톤 집값 예측 

# 데이터 확인 
install.packages("neuralnet")
install.packages("MASS")
library(neuralnet)
library(MASS)

head(Boston)

# 분석 대상 데이터 할당
data <- Boston[, c(1,2,3,5,9,14)]
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

# 학습용과 테스트용 데이터 분리 
n <- nrow(data.scaled) 

set.seed(1234) 
index <- sample(1:n, round(0.8*n)) 
index

train <- as.data.frame(data.scaled[index,])
head(train)

test  <- as.data.frame(data.scaled[-index,])
head(test)

# 학습용 입출력 변수 할당 
names.col <- colnames(train)
names.col

var.dependent <- names.col[6]
var.dependent

var.independent <- names.col[-6]
var.independent

f.var.independent <- paste(var.independent, collapse = " + ")
f.var.independent

f <- paste(var.dependent, "~", f.var.independent)
f

# 학습 및 모형 출력 
model <- neuralnet(f, 
                   data = train,
                   hidden = c(3, 2),
                   linear.output = T)
plot(model) 

# 테스트 
predicted <- compute(model, test)
predicted$net.result

predicted.real <- predicted$net.result * (maxs[6] - mins[6]) + mins[6]  
predicted.real

test.real <- test$medv * (maxs[6] - mins[6]) + mins[6]  
test.real

# 실제값 대비 예측값 비교(분포)
plot(test.real,  predicted.real,
     xlim=c(0, 50), ylim=c(0, 50),
     main="실제값 대비 예측값 분포",
     xlab="실제값", ylab="예측값",
     col="red", 
     pch=18, cex=0.7)
abline(0, 1, col="blue", lty=2)

MAPE.model <- sum(abs(test.real - predicted.real)/test.real * 100) / length(test.real)
MAPE.model


######################################################
# 패키지 설치 및 로딩
# xlsx 패키지를 위해 먼저 JAVA 구축여부 학인(부록 참조)
install.packages("xlsx")
install.packages("nnet")
library(xlsx)
library(nnet)

# 시계열 데이터 읽기
data <- read.xlsx2(file.choose(), 1)
data
data$종가 <- gsub(",", "", data$종가) 
data$종가 <- as.numeric(data$종가) 

df <- data.frame(일자=data$년.월.일, 종가=data$종가)
df <- df[order(df$일자), ]    
n <- nrow(df)
rownames(df) <- 1:n

# 데이터 정규화
norm <- (df$종가 - min(df$종가)) / (max(df$종가) - min(df$종가)) * 0.9 + 0.05
df   <- cbind(df, 종가norm=norm)
df

# 학습 데이터와 테스트 데이터 분리
n80 <- round(n * 0.8, 0)
n80
df.learning <- df[1:n80, ]
df.learning
df.test     <- df[(n80+1):n, ]
df.test

# 인공신경망 구조
INPUT_NODES   <- 10
HIDDEN_NODES  <- 10
OUTPUT_NODES  <- 5              
ITERATION     <- 100

# 입출력 데이터 파일 생성 함수
getDataSet <- function(item, from, to, size) {
        dataframe <- NULL
        to <- to - size + 1                      # 마지막 행의 시작날짜 번호
        for(i in from:to) {                      # 각 행의 날짜 시작번호에 대한 반복
                start <- i                             # 각 행의 시작날짜 번호
                end   <- start + size - 1              # 각 행의 끝날짜 번호
                temp  <- item[c(start:end)]            # item에서 start~end 구간의 데이터 추출 
                dataframe <- rbind(dataframe, t(temp)) # t() 함수를 사용하여 열 단위의 데이터를 행으로 전환 후 데이터 프레임에 추가
        }  
        return(dataframe)                        # 데이터 프레임 반환 
}

# 입력 데이터 만들기
in_learning <- getDataSet(df.learning$종가norm, 1, 92, INPUT_NODES)
in_learning

# 목표치 데이터 만들기
out_learning <- getDataSet(df.learning$종가norm, 11, 97, OUTPUT_NODES)
out_learning

# 학습
model <- nnet(in_learning, out_learning, size=HIDDEN_NODES, maxit=ITERATION)

# 입력 데이터 만들기
in_test <- getDataSet(df.test$종가norm, 1, 19, INPUT_NODES)
in_test

# 예측
predicted_values <- predict(model, in_test, type="raw")
Vpredicted <- (predicted_values - 0.05) / 0.9 * (max(df$종가) - min(df$종가)) + min(df$종가)
Vpredicted

# 예측 기간의 실제 값 데이터 만들기
Vreal <- getDataSet(df.test$종가, 11, 24, OUTPUT_NODES)
Vreal

# 오차 계산 및 출력
ERROR <- abs(Vreal - Vpredicted)
MAPE <- rowMeans(ERROR / Vreal) * 100
MAPE

mean(MAPE)

# 예측 입력 데이터 만들기
in_forecasting <- df$종가norm[112:121]
in_forecasting 

# 예측
predicted_values <- predict(model, in_forecasting, type="raw")
Vpredicted <- (predicted_values - 0.05) / 0.9 * (max(df$종가) - min(df$종가)) + min(df$종가)
Vpredicted

# 그래프 출력
plot(82:121, df$종가[82:121], xlab="기간", ylab="종가", xlim=c(82,126), ylim=c(1800, 2100), type="o")
lines(122:126, Vpredicted, type="o", col="red")
abline(v=121, col="blue", lty=2)

#####################################################################
## 13.4 붓꽃 종의 분류(분류문제)

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
nn <- neuralnet(f, data=train, hidden=c(6, 6), linear.output=F)
plot(nn)

# 테스트 
predicted <- compute(nn, test[,-5:-8])
predicted$net.result

idx <- max.col(predicted$net.result)
idx

species   <- c('setosa', 'versicolor', 'virginica')
predicted <- species[idx]
predicted

# 실제 값 대비 예측 값 비교(분포)
table(test$Species, predicted)

t <- table(test$Species, predicted)
tot <- sum(t)
tot
same <- sum(diag(t))
same
same / tot

######################################################
install.packages("neuralnet")
install.packages("Metrics")
install.packages("MASS")

library(neuralnet)
library(Metrics)
library(MASS)

data("Boston")
data<-Boston

keeps<-c("crim","indus","nox","rm","age","dis","tax","ptratio","lstat","medv")
data<-data[keeps]
data<-scale(data)

apply(data,2,function(x) sum(is.na(x)))

set.seed(2016)
n = nrow(data)
train <- sample(1:n, 400,FALSE)

f<-medv~ crim+indus + nox + rm + age + dis + tax + ptratio + lstat
fit<-neuralnet(f, 
               data = data[train,],
               hidden = c(10,12,20),
               algorithm = "rprop+",
               err.fct ="sse",
               act.fct = "logistic",
               threshold = 0.1,
               linear.output = TRUE)

pred<-compute(fit, data[-train, 1:9])
plot(data[-train,10]~pred$net.result)

round(cor(pred$net.result, data[-train,10]),2)

mse(pred$net.result, data[-train,10])

rmse(pred$net.result, data[-train,10])


##############################################
require(deepnet)

train
X = data[train,1:9]
Y = data[train, 10]

fitB <- nn.train(x=X,y=Y, 
                 initW = NULL,
                 initB = NULL,
                 hidden = c(10,12,20),
                 learningrate = 0.58,
                 momentum = 0.74,
                 learningrate_scale = 1,
                 activationfun = "sigm",
                 output = "linear",
                 numepochs = 970,
                 batchsize = 60,
                 hidden_dropout = 0,
                 visible_dropout = 0)

predB<-nn.predict(fitB, data[-train,1:9])

round(cor(predB, data[-train,10]),2)

mse(predB, data[-train,10])

rmse(predB, data[-train,10])
