# 12.2 표본추출과 난수

sample(c("앞면", "뒷면"), 10, replace=T)

runif(10, min=0, max=1)

# 12.3 동전 던지기

# 그래프 초기화
iteration <- 5000

plot(0, 0, xlab="동전을 던진 회수", ylab="앞면이 나오는 비율", xlim=c(0, iteration),
     ylim=c(0, 1))
abline(a=0.5, b=0, col="red")

# 실험 반복에 따른 확률의 변화
# iteration <- 5000
sum <- 0
for(x in 1:iteration) {
  coin <- sample(c("앞면", "뒷면"), 1, replace=T)
  if (coin == "앞면")
    sum = sum + 1
  prob <- sum / x
  points(x, prob)
}

# 복원 추출을 이용한 실험
# 시행회수: 5000
iteration <- 5000
x <- sample(c(0, 1), iteration, replace=T)
round(sum(x)/ iteration * 100, 1)

# 12.4 몬테카를로 시뮬레이션에 의한 원주율 구하기

# 원주율 계산
iteration <- 1000
n_circle  <- 0
for(i in 1: iteration) {
  x <- runif(1, min=0, max=1)
  y <- runif(1, min=0, max=1)
  dist <- sqrt(x ^2 + y ^2)
  if (dist <= 1)
    n_circle <- n_circle + 1
}
pi <- 4 * n_circle / iteration
pi

# 12.4 몬테카를로 시뮬레이션에 의한 원주율 구하기(2)
# 원주율 계산
iteration <- 1000
n_circle  <- 0

plot(NA, xlim=c(0, 1), ylim=c(0, 1))
pts <- NULL

for(i in 1: iteration) {
  x <- runif(1, min=0, max=1)
  y <- runif(1, min=0, max=1)
  
  pts <- rbind(pts, c(x, y))

  dist <- sqrt(x ^2 + y ^2)
  if (dist <= 1)
    n_circle <- n_circle + 1
}
pts
points(pts, pch=19, cex=0.5, col='black')

pi <- 4 * n_circle / iteration
pi

# 12.5 회귀선 구하기

# x, y 데이터 준비 및 산포도 그리기
x <- c(1, 2.2, 3.5, 4, 5.2, 6.4, 7.1, 8.3, 9.2, 10)
y <- c(41, 47, 62, 75, 85, 90, 110, 115, 125, 140)
plot(x, y, xlim=c(0,10), ylim=c(0,150))
lm(y ~x)

# 기울기(b)와 y절편(a) 범위 설정 및 비용함수 값 구하기
B <- seq(-5,  15, by=1)
A <- seq(-30, 30, by=1)
cost.mtx <- matrix(NA, nrow=length(B), ncol=length(A))
for(i in 1:length(B)) {
  for(j in 1:length(A)) {
    err.sum <- 0
    for(k in 1:length(x)) {
      y_hat <- B[i]*x[k] + A[j]
      err   <- (y_hat - y[k])^2
      err.sum <- err.sum + err
    }
    cost <- err.sum/length(x)
    cost.mtx[i,j] <- cost
  }
}
cost.mtx[1:5, 1:5]

# 기울기와 y절편 구하기
range(cost.mtx)

idx <- which(cost.mtx == min(cost.mtx), arr.ind = TRUE)
idx

idx.Bmin <- idx[1,1]   
idx.Amin <- idx[1,2]
Bmin <- B[idx.Bmin]
Bmin

Amin <- A[idx.Amin]
Amin

abline(a=Amin, b=Bmin, lty=2, col="red")

# 기울기와 y절편 범위에서의 비용함수 그래프
plot(B, cost.mtx[,idx.Amin],
     ylim=c(0, 800),
     type='o',
     lwd=3)

for(j in 1:length(A)) {
  lines(B, cost.mtx[,j], col=j)
  Sys.sleep(0.5)
}

plot(A, cost.mtx[idx.Bmin,],
     ylim=c(0, 700),
     type='o',
     lwd=3)
for(i in 1:length(B)) {
  lines(A, cost.mtx[i,], col=i)
  Sys.sleep(0.5)
}

# 기울기와 y절편 범위에서의 3차원 비용함수 그래프
install.packages("rgl")
library(rgl)
persp3d(B, A, cost.mtx, col="yellow")

persp3d(B, A, cost.mtx, col="yellow", zlim=c(0, 400))
