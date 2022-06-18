# 노선 번호에 대한 노선 ID 확인  
install.packages("XML")
install.packages("ggmap")

library(XML)
library(ggmap)

busRtNm <- "711"

API_key <- "vECpSk4BAhmevihpl9z1qQLcOHjj3Fe7IA8JylhaqCJNmjhj67LXat168VW4uFvqHfZ2YdiWhoVQM5l6x3veqg%3D%3D"
#API_key <- "DEp3%2BU.....DQ%3D%3D"
url <- paste("http://openapitraffic.daejeon.go.kr/api/rest/busRouteInfo/getStaionByRouteAll?serviceKey=", API_key, "&regpage=1", busRtNm, sep="")
xmefile <- xmlParse(url)
xmefile
xmlRoot(xmefile)


df <- xmlToDataFrame(getNodeSet(xmefile, "//itemList"))
df
head(df)

df_busRoute <- subset(df, ROUTE_NO==busRtNm)
df_busRoute

df_busRoute$busRouteId


# 노선 ID에 대한 버스 실시간 위치 정보 확인
API_key <- "vECpSk4BAhmevihpl9z1qQLcOHjj3Fe7IA8JylhaqCJNmjhj67LXat168VW4uFvqHfZ2YdiWhoVQM5l6x3veqg%3D%3D"

url <- paste("http://openapitraffic.daejeon.go.kr/api/rest/busposinfo/getBusPosByRtid?ServiceKey=", API_key, "&busRouteId=",
             df_busRoute$busRouteId, sep="")
xmefile <- xmlParse(url)
xmlRoot(xmefile)


df <- xmlToDataFrame(getNodeSet(xmefile, "//itemList"))
df

gpsX <- as.numeric(as.character(df$gpsX))
gpsY <- as.numeric(as.character(df$gpsY))
gc <- data.frame(lon=gpsX, lat=gpsY)
gc


# 구글 맵에 버스 위치 출력
register_google(key = 'AIzaSyDIBguD_JsJzUI-x78Uj9aoOQgG95eAJwc')


cen <- c(mean(gc$lon), mean(gc$lat))
map <- get_googlemap(center=cen, maptype="roadmap",zoom=11, marker=gc)
ggmap(map, extent="device")

