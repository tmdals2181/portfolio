# 8.3 공공데이터포털의 목록 추출(단일 페이지)

# 패키지 설치 및 로딩 
install.packages("rvest")
library(rvest)

# 웹문서 읽기
url <- "https://www.data.go.kr/tcs/dss/selectDataSetList.do"
html <- read_html(url)
html

# 목록 아이템 추출
title <- html_nodes(html, "#apiDataList .title") %>%
           html_text()
title

# 목록 아이템 설명 추출
desc <- html_nodes(html, "#apiDataList .ellipsis") %>%
  html_text()
desc

# 데이터 정제: 제어문자를 공백으로 대체
title <- gsub("[|\r|\n|\t]", "", title)
title

#공백 br 태그 삭제
desc <- gsub("<br/>","",desc)
desc

# 데이터 출력
api <- data.frame(title, desc)
api

########################################
# 패키지 설치 및 로딩 
install.packages("rvest")
library(rvest)

# 웹문서 읽기
url <- "https://www.data.go.kr/search/index.do?index=OPENAPI&query=&currentPage=1&countPerPage=10&sortType=VIEW_COUNT"
html <- read_html(url)
html

# 목록 아이템 추출
title <- html_nodes(html, "#openapi-list-wrapper") %>%
  html_nodes(".data-title a") %>%
  html_text()
title

# 목록 설명 추출
desc <- html_nodes(html, "#openapi-list-wrapper") %>%
  html_nodes(".data-desc a") %>%
  html_text()
desc


# 데이터 정제: 제어문자를 공백으로 대체
title <- gsub("[|\r|\n|\t]", "", title)
title <- trimws(title, "both")
title

desc <- gsub("[|\r|\n|\t]", "", desc)
desc <- trimws(desc, "both")
title

# 데이터 출력
api <- data.frame(title, desc)
api

################################################
# 복수 페이지
install.packages("rvest")
library(rvest)

# 웹문서 읽기
url.api <- "https://www.data.go.kr/search/index.do?index=OPENAPI&query=&countPerPage=10&sortType=VIEW_COUNT&currentPage="
titles <- NULL
descs <- NULL

for(page in 1:10) {
  url <- paste(url.api, page, sep="")
  html <- read_html(url)
  #html

  # 목록 아이템 추출
  title <- html_nodes(html, "#openapi-list-wrapper") %>%
          html_nodes(".data-title a") %>%
          html_text()
  #title

  # 목록 설명 추출
  desc <- html_nodes(html, "#openapi-list-wrapper") %>%
          html_nodes(".data-desc a") %>%
          html_text()
  #desc

  # 데이터 정제: 제어문자를 공백으로 대체
  title <- gsub("[|\r|\n|\t]", "", title)
  title <- trimws(title, "both")
  #title

  desc <- gsub("[|\r|\n|\t]", "", desc)
  desc <- trimws(desc, "both")
  #desc
  
  titles <- c(titles, title)
  descs <- c(descs, desc)
}

titles

########################################
# 8.4 네이버 영화리뷰 추출 (단일 페이지)

# 패키지 설치
install.packages("rvest")
library(rvest)

# 웹문서 읽기
url <- "https://movie.naver.com/movie/point/af/list.nhn"
url <- "https://movie.naver.com/movie/point/af/list.nhn"
html <- read_html(url)
#html <- read_html(url, encoding = "GBK")
#html <- read_html(url, encoding = "utf-8")

html

# 리뷰 셀 추출 
review_cell <- html_nodes(html, "#old_content table tr .title")
review_cell

# 평점 추출 
score <- html_nodes(review_cell, "em") %>%
  html_text()
score

# 리뷰 추출 
review <- review_cell %>% 
  html_text()
review

# 리뷰 데이터 정제 
# (1) 리뷰 앞 공통부분이 있는 위치
index.start <- regexpr("\t별점 -", review)
index.start
# (1) 리뷰 뒤 공통부분이 있는 위치
index.end   <- regexpr("\t신고", review)
index.end
# (2) 리뷰 추출 
review <- substring(review, index.start, index.end)
review
review <- substring(review, 16)
review
# (3) 제어문자 제거(제어문자를 공백으로 대체)
review <- gsub("[|\n|\t]", "", review)
review
# (4) 리뷰 좌우 공백 제거
review <- trimws(review, "both")
review


# (5) 다수 페이지
install.packages("rvest")
library(rvest)

url.page <- "https://movie.naver.com/movie/point/af/list.nhn?&page="



#시작과 끝 페이지
page.start <- 1
page.end <- 5

review.page <- NULL

#시작부터 끝페이지 반복
for(p in page.start:page.end){
  #페이지 url설정
  url <- paste(url.page, p, sep = "")
  
  html <- read_html(url)
  #html <- read_html(url, encoding = "GBK")
  #html <- read_html(url, encoding = "utf-8")
  
  html
  
  # 리뷰 셀 추출 
  review_cell <- html_nodes(html, "#old_content table tr .title")
  review_cell
  
  # 평점 추출 
  score <- html_nodes(review_cell, "em") %>%
    html_text()
  score
  
  # 리뷰 추출 
  review <- review_cell %>% 
    html_text()
  review
  
  # 리뷰 데이터 정제 
  # (1) 리뷰 앞 공통부분이 있는 위치
  index.start <- regexpr("\t별점 -", review)
  index.start
  # (1) 리뷰 뒤 공통부분이 있는 위치
  index.end   <- regexpr("\t신고", review)
  index.end
  # (2) 리뷰 추출 
  review <- substring(review, index.start, index.end)
  review
  review <- substring(review, 16)
  review
  # (3) 제어문자 제거(제어문자를 공백으로 대체)
  review <- gsub("[|\n|\t]", "", review)
  review
  # (4) 리뷰 좌우 공백 제거
  review <- trimws(review, "both")
  review
}








#----------------------------
# 8.3 기상정보 추출 

# 패키지 설치 및 로딩 
install.packages("rvest")
library(rvest)

# 웹문서 읽기
url <- "C:/Temp/weather_info.html"
html <- read_html(url, encoding="utf-8")
html

# 제목 추출(1개 태그) 
# chain operations (Operator %>%, shift+ctrl+M)
title <- html_node(html, "div h1") %>%
  html_text()
title

# 제목 추출(전체 태그)
title <- html_nodes(html, "div h1") %>%
  html_text()
title

# 미세먼지
pm <- html_node(html, "div ul") %>%
  html_nodes("li") %>%
  html_text()
pm

# 미세먼지, 온도
weather <- html_nodes(html, "div ul") %>%
  html_nodes("li") %>%
  html_text()
weather

# 온도 
temperature <- html_nodes(html, "div ul")[2] %>%
  html_nodes("li") %>%
  html_text()
temperature

# 미세먼지
pm <- html_nodes(html, "#pm ul .city") %>%
  html_text()
pm

# 온도 
temperature <- html_nodes(html, "#temperature ul .city") %>%
html_text()

temperature

#########################################

#install.packages("RCurl")
install.packages("XML")
install.packages("rvest")

#library(RCurl)
library(XML)
library(rvest)

####################################################
#PGA 골프 선수별 통계
#url  <- "http://sports.yahoo.com/golf/pga/stats/bycategory?cat=WORLD_RANK&season=2017"
#world_ranking  <- read_html(url)
#world_ranking
#x <- html_table(world_ranking)[[2]] # 두번째 TABLE 
#head(x)

#####################################################

# http://datamining.dongguk.ac.kr/lectures/bigdata/_book/section-27.html#section-29

#동작오류
#url0 <- "https://web.dongguk.ac.kr/mbs/kr/jsp/community/bbsList3.jsp?"
#url1 <- "&table=VOC.TB_VOC&bbs=05&mode=open&keyword=&keyfield=&id=kr_070303030000"
#out <- lapply(1:20, function(i){
#  url <- paste0(url0, "page=",i, url1)
#  nv  <- read_html(url)
#  html_table(nv)[[1]][, c(3,5)]
#})
#save(out, file="data/campus_qna.RData")
#load(file="data/campus_qna.RData")
#oo <- do.call("rbind", out)
#text <- oo$제목

library(KoNLP)
## Checking user defined dictionary!
library(wordcloud)
## Loading required package: RColorBrewer
x1 <- lapply(text, extractNoun)
x2 <- lapply(x1, function(x) x[nchar(x)>1])
x3 <- do.call(c, x2)
o <- table(x3)
pal <- brewer.pal(8,"Dark2")
wordcloud(names(o), o, min.freq=3, random.order=F,random.color=T,colors=pal)


####################################################
#네이버 뉴스 및 댓글의 수집을 위한 패키지
#동작오류
#https://github.com/mrchypark/N2H4
#install.packages("devtools")
#if (!require("devtools")) install.packages("devtools")
#devtools::install_github("forkonlp/N2H4")

#library(N2H4)
#뉴스내용 수집
#n_url = "https://news.naver.com/main/ranking/read.nhn?mid=etc&sid1=111&rankingType=popular_day&oid=001&aid=0010691079&date=20190313&type=1&rankingSeq=7&rankingSectionId=102"
#nn <- getContent(n_url)
#nn


############################


--------------------------------
  #https://blog.naver.com/jangmi9111/221358793330
  install.packages("rvest")
install.packages("XML")

library(rvest)
library(XML)

#쿠팡
#플라하반오트밀

url <-"http://www.coupang.com/np/search?component=&q=%ED%94%8C%EB%9D%BC%ED%95%98%EB%B0%98%EC%98%A4%ED%8A%B8%EB%B0%80&channel=user&component=&eventCategory=SRP&trcid=&traid=&sorter=scoreDesc&minPrice=&maxPrice=&priceRange=&filterType=&listSize=36&filter=&isPriceRange=false&brand=&offerCondition=&rating=0&page="
content <- read_html(url, encoding="UTF-8")
content
namenodes <- html_nodes(content, ".name")
name <- html_text(namenodes)
name
pricenodes <- html_nodes(content, ".price-value")
price <- html_text(pricenodes)
price
pointNodes <- html_nodes(content, ".rating")
point <- html_text(pointNodes)
point
page <- cbind(name, price)
page <- cbind(page, point)
page

coupang <- NULL
for (i in 1:10){
  url2 <- paste(url, i, sep="")
  content <- read_html(url, encoding="UTF-8")
  namenodes <- html_nodes(content, ".name")
  name <- html_text(namenodes)
  pricenodes <- html_nodes(content, ".price-value")
  price <- html_text(pricenodes)
  pointNodes <- html_nodes(content, ".rating")
  point <- html_text(pointNodes)
  page <- cbind(name, price)
  page <- cbind(page, point)
  coupang <- rbind(coupang, page)
}
coupang
write.csv(coupang, "c://Temp/coupang.csv")

-------------------------------------------------
  install.packages("rvest")
library(rvest)

url_tvcast = "http://tvcast.naver.com//jtbc.youth"
html_tvcast = read_html(url_tvcast , encoding="UTF-8")
html_tvcast
html_tvcast %>% html_nodes(".title a")
html_tvcast %>% html_nodes(".title a") %>% html_text()

tvcast_df = html_tvcast %>% html_nodes(".title a") %>% html_text() %>% data.frame()
tvcast_df

#table 추출
url_table = "http://en.wikipedia.org/wiki/Student%27s_t-distribution"
html_wiki = read_html(url_table, encoding="UTF-8")
wiki = html_wiki %>% html_nodes(".wikitable") %>% html_table()
wiki


---------------------------------
  #동작오류
  #url <- "http://search.wemakedocprice.com/search?search_cate=top&search_keyword=%EC%97%AC%EC%84%B1%ED%81%AC%EB%A1%9C%EC%8A%A4%EB%B0%B1&_service=5&_type=3"
  #url <- "http://search.wemakedocprice.com/search?search_cate=top&search_keyword=%EC%97%AC%EC%84%B1%ED%81%AC%EB%A1%9C%EC%8A%A4%EB%B0%B1"
  #doc <- htmlParse(url, encoding="UTF-8")
  #doc
-----------------------------------
  
install.packages("XML")
install.packages("RCurl")

library(XML)
library(RCurl)

query <- URLencode(iconv("I dreamed a dream", "euc-kr", "UTF-8"))
url <- paste("https://www.youtube.com/results?q=", query, sep="")

doc <- getURL(url)
html <- htmlParse(doc, encoding="UTF-8")

link <- xpathSApply(html, "//div[@class='div 클래스명']//button", xmlGetAttr, 'button 태그내의 추출 속성명')

url1 <- paste("https://www.youtube.com/results?q=", link, sep="")
link <- xpathSApply(html, "//div[@class='div 클래스명']//a", xmlGetAttr, 'a 태그내의 추출 속성명')

url2 <- paste("https://www.youtube.com/results?q=", link[1:4], sep="")
urls <- c(url1, url2)
urls



---------------------------------------------
#크롤링
#https://kuduz.tistory.com/1032

install.packages("rvest") 
install.packages("ggplot2")
install.packages("ggmap") 
install.packages("maps") 

library(rvest) 
library(ggplot2) 
library(ggmap) 
library(maps)

html.airports <- read_html("https://en.wikipedia.org/wiki/List_of_busiest_airports_by_passenger_traffic") 
df <- html_table(html_nodes(html.airports, "table")[[1]], fill = TRUE) 
df
register_google(key = 'AIzaSyDIBguD_JsJzUI-x78Uj9aoOQgG95eAJwc')

colnames(df)[6] <- "total" 
df$total <- gsub('\\[[0-9]+\\]', '', df$total) 
df$total <- gsub(',', '', df$total) 
df$total <- as.numeric(df$total) 
gc <- geocode(df$Airport) 
df <- cbind(df, gc) 
world <- map_data("world")

ggplot(df, aes(x=lon, y=lat)) +  
  geom_polygon(data=world, aes(x=long, y=lat, group=group), fill="grey75", color="grey70") +     
  geom_point(color="dark red", alpha=.25, aes(size=total)) +     
  geom_point(color="dark red", alpha=.75, shape=1, aes(size=total)) +     
  theme(legend.position='none')


#출처: https://kuduz.tistory.com/1032 [kini'n creations]

-------------------------------------------------------------
  # 동작오류
  #https://stat-and-news-by-daragon9.tistory.com/112
  ######################################################################3
install.packages("rvest")
install.packages("dplyr")

library(rvest)
library(dplyr)

basic_url <- 'http://news.donga.com/search?query=bigkini&more=1&range=3&p='
urls <- NULL

for(x in 0:5){
  
  urls[x+1] <- paste0(basic_url, as.character(x*15+1))
  
}
links <- NULL

for(url in urls){
  
  html <- read_html(url)
  
  links <- c(links, html %>% html_nodes('.searchCont') %>% html_nodes('a') %>% html_attr('href') %>% unique())
  
}
links
links <- links[-grep("pdf", links)]

txts <- NULL

for(link in links){
  
  html <- read_html(link)
  
  txts <- c(txts, html %>% html_nodes('.article_txt') %>% html_text())
  
}
txts
write.csv(txts, "c://Temp/text.csv")
#출처: https://kuduz.tistory.com/1041 [kini'n creations]

###########################################################3
# https://mrchypark.github.io/getWebR/





#---------------------------