
iris # iris데이터를 불러오자.
summary(iris) # iris 데이터의 대략적인 정보를 보도록 해보자

install.packages("dplyr")
install.packages("ggvis") # 설치가 안되어 있으면 설치
library(dplyr)
library(ggvis) # 패키지 로드


# 종 도식화 %>%함수를 사용 했기 때문에 dplyr패키지 설치가 되어 있어야 한다.
iris %>% 
  ggvis(~Petal.Length, ~Petal.Width, fill = ~factor(Species)) %>%
  layer_points()

# 정규화 함수
min_max_normalizer <- function(x) {
  num <- x - min(x)
  denom <- max(x) - min(x)
  return (num/denom)
}

# Iris 데이터 세트 정규화
normalized_iris <- as.data.frame(lapply(iris[1:4], min_max_normalizer))
# 정규화된 데이터 보기
summary(normalized_iris)

# 데이터 구성 요소 확인
table(iris$Species)
# 랜덤을 위한 시드 값 세트
set.seed(1234)
# 트레이닝-테스트로 67%, 33%씩 나눈다.
random_samples <- sample(2, nrow(iris), replace=TRUE, prob=c(0.67,0.33))

# 트레이닝 데이터 세트
iris.training <- iris[random_samples == 1, 1:4]
iris.training
# 트레이닝 라벨
iris.trainLabels <- iris[random_samples == 1, 5]
iris.trainLabels
# 테스트 데이터 세트
iris.test <- iris[random_samples == 2, 1:4]
# 테스팅 라벨
iris.testLabels <- iris[random_samples == 2, 5]

# 라이브러리 세팅
library(class)
# k = 3에 대해 KNN실행
iris_model <- knn(train = iris.training, test = iris.test, 
                  cl = iris.trainLabels, k =3)
# 학습된 모델에 대한 요약
iris_model

### 모델 평가
# 라이브러리 세팅
install.packages("gmodels") # 설치가 안되어 있으면 설치
library(gmodels)
# 교차표 (cross table) 준비
CrossTable(x = iris.testLabels, y = iris_model, prop.chisq = FALSE)

############################################
data <- iris[, c("Sepal.Length", "Sepal.Width", "Species")]
data
# 재현성을 위한 seed 설정 
set.seed(123) 
# idx 설정 
idx <- sample(x = c("train", "valid", "test"), size = nrow(data), replace = TRUE, prob = c(3, 1, 1)) 
# idx에 따라 데이터 나누기 
train <- data[idx == "train", ] 
valid <- data[idx == "valid", ] 
test <- data[idx == "test", ]

#산점도를 그려서 train, valid, test 데이터의 분포를 확인
install.packages("scales") 
library(scales)

# train 산점도 그리기 
plot(formula = Sepal.Length ~ Sepal.Width, data = train, col = alpha(c("purple", "blue", "green"), 0.7)[train$Species], main = "train - Classification Species") 
# valid 표시하기 
points(formula = Sepal.Length ~ Sepal.Width, data = valid, pch = 17, cex = 1.2, col = "red") 
# test 표시하기 
points(formula = Sepal.Length ~ Sepal.Width, data = test, pch = 15, cex = 1.2, col = "orange") 
# 범례 그리기 
legend("topright", c(levels(data$Species), "valid", "test"), pch = c(1, 1, 1, 17, 15), col = c(alpha(c("purple", "blue", "green"), 0.7), "red", "orange"), cex = 0.9)

# x는 3번째 열을 제외한다는 의미로 -3 
train_x <- train[, -3] 
valid_x <- valid[, -3] 
test_x <- test[, -3] 
# y는 3번째 열만 필터링한다는 의미로 3 
train_y <- train[, 3] 
valid_y <- valid[, 3] 
test_y <- test[, 3]

install.packages("class") 
library(class)

# k = 1 일 때 
set.seed(1234) 
knn_1 <- knn(train = train_x, test = valid_x, cl = train_y, k = 1)

# train 산점도 그리기 
plot(formula = Sepal.Length ~ Sepal.Width, data = train, col = alpha(c("purple", "blue", "green"), 0.7)[train$Species], main = "KNN (k = 1)")

# knn valid 결과 표시하기 
points(formula = Sepal.Length ~ Sepal.Width, data = valid, pch = 17, cex = 1.2, col = alpha(c("purple", "blue", "green"), 0.7)[knn_1]) 
# 범례 그리기 
legend("topright", c(paste("train", levels(train$Species)), paste("valid", levels(valid$Species))), pch = c(rep(1, 3), rep(17, 3)), col = c(rep(alpha(c("purple", "blue", "green"), 0.7), 2)), cex = 0.9) 
# 분류 정확도 계산하기 
accuracy_1 <- sum(knn_1 == valid_y) / length(valid_y) ; accuracy_1

# k = 21 일 때 
set.seed(1234) 

knn_21 <- knn(train = train_x, test = valid_x, cl = train_y, k = 21) 
plot(formula = Sepal.Length ~ Sepal.Width, data = train, col = alpha(c("purple", "blue", "green"), 0.7)[train$Species], main = "KNN (k = 21)") 
# knn valid 결과 표시하기 
points(formula = Sepal.Length ~ Sepal.Width, data = valid, pch = 17, cex = 1.2, col = alpha(c("purple", "blue", "green"), 0.7)[knn_21]) 
# 범례 그리기 
legend("topright", c(paste("train", levels(train$Species)), paste("valid", levels(valid$Species))), pch = c(rep(1, 3), rep(17, 3)), col = c(rep(alpha(c("purple", "blue", "green"), 0.7), 2)), cex = 0.9) 
# 분류 정확도 계산하기 
accuracy_21 <- sum(knn_21 == valid_y) / length(valid_y) ; accuracy_21

# 분류 정확도 사전 할당 
accuracy_k <- NULL 
# kk가 1부터 train 행 수까지 증가할 때 (반복문) 
for(kk in c(1:nrow(train_x))){ 
  # k가 kk일 때 knn 적용하기 
  set.seed(1234) 
  knn_k <- knn(train = train_x, test = valid_x, cl = train_y, k = kk) 
  # 분류 정확도 계산하기 
  accuracy_k <- c(accuracy_k, sum(knn_k == valid_y) / length(valid_y)) 
} 
# k에 따른 분류 정확도 데이터 생성 
valid_k <- data.frame(k = c(1:nrow(train_x)), accuracy = accuracy_k) 
# k에 따른 분류 정확도 그래프 그리기 
plot(formula = accuracy ~ k, data = valid_k, type = "o", pch = 20, main = "validation - optimal k") 
# 그래프에 k 라벨링 하기 with(valid_k, text(accuracy ~ k, labels = rownames(valid_k), pos = 1, cex = 0.7)) 
# 분류 정확도가 가장 높으면서 가장 작은 k는? 
min(valid_k[valid_k$accuracy %in% max(accuracy_k), "k"])

# 21-NN에 test 데이터 적용하기
set.seed(1234)
knn_21_test <- knn(train = train_x,
                   test = test_x,
                   cl = train_y,
                   k = 45)


# Confusion Matrix 틀 만들기
result <- matrix(NA, nrow = 3, ncol = 3)
rownames(result) <- paste0("real_", levels(train_y))
colnames(result) <- paste0("clsf_", levels(train_y))


# Confusion Matrix 값 입력하기
result[1, 1] <- sum(ifelse(test_y == "setosa" & knn_21_test == "setosa", 1, 0))
result[2, 1] <- sum(ifelse(test_y == "versicolor" & knn_21_test == "setosa", 1, 0))
result[3, 1] <- sum(ifelse(test_y == "virginica" & knn_21_test == "setosa", 1, 0))

result[1, 2] <- sum(ifelse(test_y == "setosa" & knn_21_test == "versicolor", 1, 0))
result[2, 2] <- sum(ifelse(test_y == "versicolor" & knn_21_test == "versicolor", 1, 0))
result[3, 2] <- sum(ifelse(test_y == "virginica" & knn_21_test == "versicolor", 1, 0))

result[1, 3] <- sum(ifelse(test_y == "setosa" & knn_21_test == "virginica", 1, 0))
result[2, 3] <- sum(ifelse(test_y == "versicolor" & knn_21_test == "virginica", 1, 0))
result[3, 3] <- sum(ifelse(test_y == "virginica" & knn_21_test == "virginica", 1, 0))


# Confusion Matrix 출력하기
result


# 최종 정확도 계산하기
sum(knn_21_test == test_y) / sum(result)

#최종적으로 아래와 같이 Confusion Matrix와 최종 정확도가 출력된다.


#####################################
#바로 범주를 알지 못하는 특정 레코드 혹은 예제의 범주를 예측하는데 쓰인다. 
#이에 대한 전제는 class(범주)를 포함하는 train data가 충분히 존재해야한다는 점이다. 

# food dataframe
food <- data.frame(ingredient = c("apple", "bacon", "banana", "carrot",
                                  "celery", "cheese", "cucumber", "fish",
                                  "grape", "green bean", "lettuce",
                                  "nuts", "orange", "pear","shrimp"
),
sweetness = c(10,1,10,7,3,1,2,3,8,3,1,3,7,10,2),
crunchiness = c(9,4,1,10,10,1,8,1,5,7,9,6,3,7,3),
class = c("Fruits","Proteins","Fruits","Vegetables",
          "Vegetables","Proteins","Vegetables",
          "Proteins","Fruits","Vegetables",
          "Vegetables","Proteins","Fruits",
          "Fruits","Proteins"))
food
# 토마토 데이터 만들기
tomato <- data.frame(ingredient = "tomato",
                     sweetness = 6,
                     crunchiness = 4)
tomato
##########################################################
################그래프 그리기 비교########################
##########################################################
# ggplot2 : 그래프 만드는 패키지
library(ggplot2)
# par : 파라미터 지정 / pty : plot모형을 "square" 정사각형
par(pty="s")
# 그래프 그리기(version : ggplot)
#par:파라미터/xpd:모형옮기기/mar:여백설정(아래,왼쪽,위,오른쪽)
par(xpd=T, mar=par()$mar+c(0,0,0,15)) 
plot(food$sweetness,food$crunchiness,
     pch=as.integer(food$class),
     #pch=food$class, # pch는 모형 지정
     xlab = "sweetness", ylab = "crunchiness", 
     main = "What is tomato class?")
legend(10.5,10, # legend 위치 지정 
       c("Fruits", "Proteins", "Vegetables", "X"),
       pch=as.integer(food$class))
text(food$sweetness, food$crunchiness, 
     labels=food$ingredient, 
     pos = 3, # 글자위치position(1:below/2:left/3:above/4:right)
     offset = 0.3, # 좌표와 얼마나 띄어쓰기 할것인지
     cex = 0.7 ) # 문자크기
# 그래프 그리기(version : ggplot2)
ggplot(data=food,aes(x=sweetness,y=crunchiness))+
  labs(title="What is tomato class?")+ # 타이틀 명
  geom_point(aes(color=class, shape=class),size=6)+
  geom_text(aes(label=ingredient), # 라벨링 표시
            vjust=-1, # 수직으로 움직일 거리 (위는 -, 아래는 +)
            size = 5) # 문자크기

##########################################################
################### Knn #####################
##########################################################
# dplyr : 큰 데이터를 다룰 때, split-apply-conbine논리로 접근 작업가능
install.packages("dplyr")
#contains knn function
library(class) 
library(dplyr)
# k=1로 두었을 때, 토마토만 예측
# 유클레디안 측정 1nn 분류
tmt <- knn(select(food, sweetness, crunchiness), 
           select(tomato,sweetness, crunchiness), 
           food$class, k=1)
tmt
# 데이터프레임 만들기
# 포도, 완두콩, 오렌지, 토마토를 통해서 예측하기
unknown <- data.frame(ingredient = c("grape", "green bean", "orange","tomato"),
                      sweetness = c(8,3,7,6),
                      crunchiness = c(5,7,3,4))
unknown
# 포도, 완두콩, 오렌지, 토마토를 통해서 k=3으로 예측
pred <- knn(select(food, sweetness, crunchiness), 
            select(unknown,sweetness, crunchiness), 
            food$class, k=3)
pred


