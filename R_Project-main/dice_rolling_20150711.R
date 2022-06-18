#ceiling 반올림, runif 랜덤

# 100번 던지고 바플롯으로 그래프 보기
roll <- 100
dice <- ceiling(runif(roll)*6) + ceiling(runif(roll)*6) #2 ~12
a <- table(dice)
barplot(a)

#a[7]
#a[3]
#a[11]


#1000번 던지고 바플롯으로 그래프 보기
roll <- 1000
dice <- ceiling(runif(roll)*6) + ceiling(runif(roll)*6) #2 ~12
a <- table(dice)
barplot(a)

#10000번 던지고 바플롯으로 그래프 보기
roll <- 10000
dice <- ceiling(runif(roll)*6) + ceiling(runif(roll)*6) #2 ~12
a <- table(dice)
barplot(a)