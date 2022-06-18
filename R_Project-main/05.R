# 5.2 줄기-잎 그림

# 줄기-잎 그림
rivers
length(rivers)

stem(rivers)

rivers
stem(rivers, scale=2)

# 5.3 파이 차트

# 파이 차트 
city <- c("서울", "부산", "대구", "인천", "광주", "대전", "울산")
pm25 <- c(18, 21, 21, 17, 8, 11, 25)
colors <- c("red", "orange", "yellow", "green", "lightblue", "blue", "violet")
pie(pm25, 
    labels=city, 
    col=colors, 
    main="지역별 초미세먼지 농도")

pie(pm25, 
    labels=city, 
    col=colors, 
    main="지역별 초미세먼지 농도",
    init.angle=90, clockwise=T)

# 사용 가능한 색 찾기
colors()

# 팔레트
install.packages("RColorBrewer")
library(RColorBrewer)
display.brewer.all()

display.brewer.pal(9, name='Greens')

display.brewer.pal(6, name='Greens')

# 라벨 변경과 팔레트 사용
# install.packages("RColorBrewer")
# library(RColorBrewer)

greens <- brewer.pal(7, 'Greens')

pct <- round(pm25/sum(pm25)*100, 0)
city_label <- paste(city, ", ", pct, "%", sep="")

pie(pm25, 
    labels=city_label, 
    col=greens, 
    main="지역별 초미세먼지 농도",
    init.angle=90, clockwise=T)

# 5.4 바 차트 

# 바 차트 
dept <- c("영업 1팀", "영업 2팀", "영업 3팀", "영업 4팀")
sales01 <- c(4, 12, 5, 8)
barplot(sales01, 
        names.arg=dept,
        main="부서별 영업 실적(1분기)",
        col=rainbow(length(dept)),
        xlab="부서", ylab="영업 실적(억 원)",
        ylim=c(0, 15))

# 수평선
abline(h=mean(sales01), col="orange", lty=2)
# a: y절편, b: 기울기 (y = bx + a)
abline(a=mean(sales01), b=0, col="black", lty=2)

# 데이터 라벨 출력
bp <- barplot(sales01, names.arg=dept,
              main="부서별 영업 실적(1분기)",
              col=rainbow(length(dept)),
              xlab="부서", ylab="영업 실적(억 원)",
              ylim=c(0, 15))

text(x=bp, y=sales01, labels=sales01, pos=3)

# 바 차트의 회전(수평 바 차트)
barplot(sales01, names.arg=dept,
        main="부서별 영업 실적(1분기)",
        col=rainbow(length(dept)),
        ylab="부서", xlab="영업 실적(억 원)",
        xlim=c(0, 15),
        horiz=TRUE)

# 스택형 바 차트
dept <- c("영업 1팀", "영업 2팀", "영업 3팀", "영업 4팀")
sales01 <- c(4, 12, 5, 8)
sales02 <- c(12, 8, 8, 4)
sales <- rbind(sales01, sales02)
sales

legend_lbl <- c("1 분기", "2 분기")
barplot(sales, main="부서별 영업 실적(1~2 분기)",
        names.arg=dept,
        xlab="부서", ylab="영업 실적(억 원)",
        col=c("green","orange"),
        legend.text=legend_lbl,
        ylim=c(0, 30),
        args.legend = list(x = "top", ncol = 2))

barplot(sales, main="부서별 영업 실적(1~2 분기)",
        names.arg=dept,
        xlab="부서", ylab="영업 실적(억 원)",
        col=c("green","orange"),
        legend.text=legend_lbl,
        xlim=c(0, 7),
        args.legend = list(x = "right"))

# 그룹형 바 차트
barplot(sales, main="부서별 영업 실적(1~2 분기)",
        names.arg=dept,
        xlab="부서", ylab="영업 실적(억 원)",
        col=c("green","orange"),
        legend.text=legend_lbl,
        xlim=c(0, 17),
        args.legend = list(x = "right"),
        beside=TRUE)

# 5.5 X-Y 플로팅

# 플로팅 
women

height <- women$height
weight <- women$weight
plot(x=height, y=weight,
     xlab="키", ylab="몸무게",
     main="키와 몸무게의 변화")

# 플로칭 문자의 활용 
plot(height, weight,
     xlab="키", ylab="몸무게",
     main="키와 몸무게의 변화",
     pch=23, col="blue", bg="yellow", cex=1.5)

# 선의 유형 
plot(height, weight, 
     xlab="키", ylab="몸무게", 
     type="p")
# type: p, l, b, c, o, h, s, S, n
plot(height, weight, 
     xlab="키", ylab="몸무게", 
     type="l", lty=2, lwd=3)

# 그래프 출력 범위 
plot(height, weight,
     xlim=c(0, max(height)), ylim=c(0, max(weight)),
     xlab="키", ylab="몸무게",
     main="키와 몸무게의 변화",
     pch=23, col="blue", bg="yellow", cex=1.5)

# 5.6 히스토그램

# 지진의 강도에 대한 히스토그램
quakes

mag <- quakes$mag
mag

hist(mag,
     main="지진 발생 강도의 분포",
     xlab="지진 강도", ylab="발생 건수",
     col=rainbow(10))

hist(mag,
     main="지진 발생 강도의 분포",
     xlab="지진 강도", ylab="발생 건수",
     col=rainbow(10),
     breaks=seq(4, 6.5, by=0.5))

# 확률밀도 곡선
hist(mag,
     main="지진 발생 강도의 분포",
     xlab="지진 강도", ylab="확률밀도",
     col=rainbow(10),
     freq=FALSE)

lines(density(mag), lwd=2)
 
# 5.7 박스 플롯

# 박스 플롯
mag <- quakes$mag
boxplot(mag,
        main="지진 발생 강도의 분포",
        xlab="지진", ylab="지진 규모",
        col="red")

# 박스 플롯 정보
min(mag)

max(mag)

median(mag)

Q <- quantile(mag)
Q

Q[4] - Q[2]

IQR(mag)

fence.upper <- Q[4] + 1.5 * IQR(mag)
fence.upper

fence.lower <- Q[2] - 1.5 * IQR(mag)
fence.lower

mag[mag > fence.upper]
    
max(mag[mag <= fence.upper])

mag[mag < fence.lower]
