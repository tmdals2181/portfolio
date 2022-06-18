
install.packages("RCurl")
install.packages("XML")
install.packages("wordcloud")
install.packages("RmecabKo")

library(RCurl)
library(XML)
library(wordcloud)
library(RmecabKo)

install_mecab("C:/Rlibs/mecab")
library(RmecabKo)


#오픈 api를 사용하여nwe검색 API 클리언트 ID와 시크릿
searchUrl     <- "https://openapi.naver.com/v1/search/news.xml"
Client_ID     <- "fYdx3j2XARITndR4xOVI"
Client_Secret <- "Nmhi69DZ19"

query <- URLencode(iconv("한남대학교맛집","euc-kr","UTF-8"))
url <- paste(searchUrl,"?query=",query,"&display=20",sep="")

doc <- getURL(url, 
              httpheader = c('Content-Type' = "application/xml",
                             'X-Naver-Client-Id' = Client_ID,
                             'X-Naver-Client-Secret' = Client_Secret))
doc

#뉴스 추출 및 단어 간 빈도 비교
xmlFile <- xmlParse(doc)
df <- xmlToDataFrame(getNodeSet(xmlFile, "//item"))
str(df)

#뉴스 내용
description <- df[,4]
description
description2 <- gsub("\\d|<b>|</b>|&quot;", "", description)
description2

#단어추출 20개 각 뉴스의 대한 단어 추출 결과 리스트
nouns <- nouns(iconv(description2, "utf-8"))
nouns
nouns[[1]]

nouns.all <- unlist(nouns, use.names = F)
nouns.all

nouns.all1 <- nouns.all[nchar(nouns.all) <= 1]
nouns.all1

nouns.all2 <- nouns.all[nchar(nouns.all) >= 2]
nouns.all2  

#단어빈도
nouns.freq <- table(nouns.all2)
nouns.freq

nouns.df <- data.frame(nouns.freq, stringsAsFactors = F)
nouns.df

#단어 빈도 역순으로 정렬
nouns.df.sort <- nouns.df[order(-nouns.df$Freq), ] 
nouns.df.sort

#단어의 워드 클라우드
wordcloud(nouns.df.sort[,1], 
          freq=nouns.df.sort[,2], 
          min.freq=1, 
          scale=c(3,0.7), 
          rot.per=0.25, 
          random.order=F,  
          random.color=T,
          colors=rainbow(10))

