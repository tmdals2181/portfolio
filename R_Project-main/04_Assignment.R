#1번 

cdnow 
mag <-cdnow$mag
mag


head(cdnow$cds)
head(cdnow$elog)

cdnow <- cdnow.sample(T.cal="1997-01-01", T.tot="1998-06-07")

hist(mag,
     main="CD판매량 분석",
     xlab="판매 일자", ylab="판매량",
     col=rainbow(20))

hist(mag,
     main="CD판매량 분석",
     xlab="판매 일자", ylab="판매량",
     col=rainbow(20),
     breaks=seq(19970101,19980607,by=100))








#2번
length(rivers)

stem(rivers)

rivers
stem(rivers, scale=2)




mag <- rivers$mag
boxplot(mag,
        main="강의 길이",
        xlab="강", ylab="강의 길이",
        col="green")

# 박스 플롯
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
