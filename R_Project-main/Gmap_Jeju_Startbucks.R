
#과제
#install.packages("ggmap")
#library(ggmap)

install.packages("ggplot2")
library(ggplot2)

install.packages("ggmap")
library(ggmap)

register_google(key = "AIzaSyDIBguD_JsJzUI-x78Uj9aoOQgG95eAJwc");
map <- get_googlemap(center=c(126.54, 33.3350),
                     maptype="roadmap",
                     zoom=10,
                     size=c(570, 570))

ggmap(map, extent="device")



names <- c("제주 칠성",
           "신제주", 
           "제주용담DT", 
           "제주노형", 
           "제누노형공원", 
           "신제주이마트", 
           "제주애월DT",
           "서귀포DT",
           "제주서귀포",
           "제주중문DT",
           "제주신화월드R",
           "제주중문",
           "제주에듀시티",
           "제주성산DT",
           "성산일출봉",
           "제주송악산")

addr <- c("제주특별자치도 제주시 관덕로 55 (일도일동)",
          "제주특별자치도 제주시 노연로 99 (연동)",
          "제주특별자치도 제주시 서해안로 380 (용담삼동) 화이트하우스",
          "제주특별자치도 제주시 도령로 27 (노형동)",
          "제주특별자치도 제주시 연북로 12 (노형동)",
          "제주특별자치도 제주시 1100로 3348, 신제주이마트 1층 (노형동)",
          "제주특별자치도 제주시 애월읍 애월해안로 376",
          "제주특별자치도 서귀포시 일주서로 11 (강정동)",
          "제주특별자치도 서귀포시 중정로 53 (서귀동)",
          "제주특별자치도 서귀포시 천제연로 95(색달동)",
          "제주특별자치도 서귀포시 안덕면 신화역사로304번길 38 B1-29",
          "제주특별자치도 서귀포시 중문관광로110번길 32 (색달동)",
          "제주특별자치도 서귀포시 대정읍 에듀시티로 36",
          "제주특별자치도 서귀포시 성산읍 일출로 80",
          "제주특별자치도 서귀포시 성산읍 일출로 284-5, 1,2층",
          "제주특별자치도 서귀포시 형제해안로 322 (상모리)")


gc <- geocode(enc2utf8(addr))
gc

df <- data.frame(name=names, lon=gc$lon, lat=gc$lat)
df

cen <- c((max(df$lon)+min(df$lon))/2,
         (max(df$lat)+min(df$lat))/2)
cen

map <- get_googlemap(center=cen,
                     maptype="roadmap",
                     zoom=10,
                     marker=gc)
ggmap(map)

