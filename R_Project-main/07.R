# 7.3 구글맵 출력

# 서울 세종문화회관 중심의 지도 출력
install.packages("ggmap")
library(ggmap)

#register_google(key = "AIzaSyBk..........................Xgb5NS7o")
# 개인 구글키
register_google(key = "AIzaSyDIBguD_JsJzUI-x78Uj9aoOQgG95eAJwc");

map <- get_googlemap(center=c(126.975684, 37.572752))
ggmap(map)

# 지도 유형 변경
map <- get_googlemap(center=c(126.975684, 37.572752),
                     maptype="roadmap")
ggmap(map)

# 지도 확대 및 축소
map <- get_googlemap(center=c(126.975684, 37.572752),
                     maptype="roadmap",
                     zoom=17)
ggmap(map)

# 지도 해상도
map <- get_googlemap(center=c(126.975684, 37.572752),
                     maptype="roadmap",
                     zoom=17,
                     size=c(320, 320))
ggmap(map)

# 지도 여백
map <- get_googlemap(center=c(126.975684, 37.572752),
                     maptype="roadmap",
                     zoom=17,
                     size=c(320, 320))
ggmap(map, extent="device")

# 주소 이용 지도 출력
gc <- geocode(enc2utf8("호미곶"))
gc

lonlat <- c(gc$lon, gc$lat)
lonlat

map <- get_googlemap(center=lonlat)
ggmap(map)

# 마커 출력
gc <- geocode(enc2utf8("호미곶"))
lonlat <- c(gc$lon, gc$lat)
map <- get_googlemap(center=lonlat, marker=gc)
ggmap(map)

# 7.4 단양팔경을 지도 위에

# 단양팔경 위치의 마커 출력
# install.packages("ggmap")
install.packages("ggplot2")
# library(ggmap)
library(ggplot2)

#register_google(key = "AIzaSyBkv……….tXgb5NS7o")
register_google(key = "AIzaSyDIBguD_JsJzUI-x78Uj9aoOQgG95eAJwc")
names <- c("도담삼봉/석문", 
           "구담/옥순봉", 
           "사인암", 
           "하선암", 
           "중선암", 
           "상선암")
addr <- c("충청북도 단양군 매포읍 삼봉로 644-33",
          "충청북도 단양군 단성면 월악로 3827",
          "충청북도 단양군 대강면 사인암2길 42",
          "충청북도 단양군 단성면 선암계곡로 1337",
          "충청북도 단양군 단성면 선암계곡로 868-2",
          "충청북도 단양군 단성면 선암계곡로 790")
gc <- geocode(enc2utf8(addr))
gc

df <- data.frame(name=names, lon=gc$lon, lat=gc$lat)
df

cen <- c((max(df$lon)+min(df$lon))/2,
         (max(df$lat)+min(df$lat))/2)
cen

map <- get_googlemap(center=cen,
                     maptype="roadmap",
                     zoom=12,
                     marker=gc)
ggmap(map)

# 단양 팔경 이름 출력
gmap <- ggmap(map)
gmap + geom_text(data=df,
                 aes(x=lon, y=lat),
                 size=5,
                 label=df$name)

#------------------------
data(quakes)
head(quakes)
df <- head(quakes, 100)
df

cecn <- c(mean(df$long), mean(df$lat))
cen

gc <- data.frame(lon=df$long, lat=df$lat)

gc$long <- ifelse(gc$long > 180, -(360-gc$long), gc$long)
gc

map <- get_googlemap(center=cen, scale=1, maptype="roadmap", zoom=4, marker=gc)
ggmap(map, extent="device")

map <- get_googlemap(center=cen, maptype="roadmap", zoom=5)
gmap <- ggmap(map, extent=TRUE)
gmap + geom_point(data=df, aes(x=long, y=lat, size=mag), alpha=0.5)

#------------------------

# 7.5 지진 발생 지역 분포

# 지진 지역 출력
# install.packages("ggmap")
# install.packages("ggplot2")
install.packages("openxlsx")
# library(ggmap)
# library(ggplot2)
library(openxlsx)

#register_google(key = "AIzaSyBkv……….tXgb5NS7o")
df <- read.xlsx(file.choose(), sheet = 1, startRow = 4)

head(df)

tail(df)

df[,5] <- gsub(" N", "", df[,5])
df[,6] <- gsub(" E", "", df[,6])
df2 <- data.frame(lon=df[,6], lat=df[,5], mag=df[,3])
str(df2)

df2[,1] <- as.numeric(as.character(df2[,1]))
df2[,2] <- as.numeric(as.character(df2[,2]))
df2[,3] <- as.numeric(as.character(df2[,3]))
str(df2)

cen <- c((max(df2$lon)+min(df2$lon))/2,
         (max(df2$lat)+min(df2$lat))/2)
cen

map <- get_googlemap(center=cen, zoom=6)
gmap <- ggmap(map)
gmap + geom_point(data=df2,
                  aes(x=lon, y=lat),
                  color="red",
                  size=df2$mag,
                  alpha=0.5)

#-------------------------------------------------
#산포도 그리기
# https://blog.naver.com/crow83/221491962114

# https://statkclee.github.io/R-ecology-lesson/kr/05-visualization-ggplot2.html