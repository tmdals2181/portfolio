#과제1
#1. 특정 지역의 시간대별 미세먼지 농도의 변화


install.packages("XML")
install.packages("ggplot2")
library(XML)
library(ggplot2)

api <- "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst"
#api_key <- "DEp3%2BU6FI……….de5DQ%3D%3D"

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
url             

xmlFile <- xmlParse(url)
xmlRoot(xmlFile)

# XML 문서를 데이터 프레임으로 변환
df <- xmlToDataFrame(getNodeSet(xmlFile, "//items/item"))
df

# 미세먼지 농도의 그래프
ggplot(data=df, aes(x=dataTime, y=daejeon)) +
  geom_bar(stat="identity", fill="green")

# 라벨 수정
ggplot(data=df, aes(x=dataTime, y=seoul)) +
  geom_bar(stat="identity", fill="green") +
  theme(axis.text.x=element_text(angle=90)) +
  labs(title="시간대별 대전지역의 미세먼지 농도 변화", x = "측정일시", y = "농도")

# 막대 색
ggplot(data=df, aes(x=dataTime, y=seoul, fill=dataTime)) +
  geom_bar(stat="identity") +
  theme(axis.text.x=element_text(angle=90)) +
  labs(title="시간대별 대전지역의 미세먼지 농도 변화", x = "측정일시", y = "농도") +
  scale_fill_manual(values = rainbow(10))

# 범례 삭제
ggplot(data=df, aes(x=dataTime, y=seoul, fill=dataTime)) +
  geom_bar(stat="identity") +
  theme(axis.text.x=element_text(angle=90),
        legend.position="none") +
  labs(title="시간대별 서울지역의 미세먼지 농도 변화", x = "측정일시", y = "농도") +
  scale_fill_manual(values = rainbow(10))

# 가로 막대 출력
ggplot(data=df, aes(x=dataTime, y=seoul, fill=dataTime)) +
  geom_bar(stat="identity") +
  theme(legend.position="none") +
  labs(title="시간대별 대전지역의 미세먼지 농도 변화", x = "측정일시", y = "농도") +
  scale_fill_manual(values = rainbow(10)) +
  coord_flip()
