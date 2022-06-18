#과제2
# 특정 시간대의 지역별 초미세먼지 농도 비교

# 미세먼지 XML 문서 출력
install.packages("XML")
# install.packages("ggplot2")
install.packages("ggmap")
library(XML)
# library(ggplot2)
library(ggmap)

api <- "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst"

api_key <- "5q%2BzwsLteUG6g0ynvHWOG83qop%2B6NsEB6SonxCKEckgt73qtliUjRjpjz1yeF0IKXlyitp%2FWg63176tcCaEaFQ%3D%3D"

numOfRows <- 10
pageNo <- 1
itemCode <- "PM10"
dataGubun <- "HOUR"
searchCondition <- "MONTH"

url <- paste(api,
             "?serviceKey=", api_key,
             "&numOfRows=", numOfRows,
             "&pageNo=", pageNo,
             "&itemCode=", itemCode,
             "&dataGubun=", dataGubun,
             "&searchCondition=", searchCondition,
             sep="")
xmlFile <- xmlParse(url)

# 특정 시간대의 지역별 미세먼지 농도 추출
df <- xmlToDataFrame(getNodeSet(xmlFile, "//items/item"))
df

pm <- df[1, 4:20]
pm

# 지역별 미세먼지 농도의 지도 출력
# 임준형 개인 구글키
register_google(key = "AIzaSyDIBguD_JsJzUI-x78Uj9aoOQgG95eAJwc");

cities <- c("서울시", "부산시", "대구시", "인천시", "광주시",
            "대전시", "울산시", "경기도", "강원도", "충청북도",
            "충청남도", "전라북도", "전라남도", "경상북도", "경상남도",
            "제주시", "세종시")
gc <- geocode(enc2utf8(cities))
gc

df2 <- data.frame(지역명=cities,
                     미세먼지=t(pm),
                     경도=gc$lon,
                     위도=gc$lat,
                     stringsAsFactors = F)
df2

names(df2)[2] <- "미세먼지"
df2

str(df2)

df2[,2] <- as.numeric(df2[,2])
cen <- as.numeric(geocode(enc2utf8("전라남도도")))
map <- get_googlemap(center=cen, zoom=7)
ggmap(map) +
  geom_point(data=df2,
             aes(x=경도, y=위도),
             color=rainbow(length(df2$미세먼지)),
             size=df2$미세먼지 * 0.3,
             alpha=0.5)

