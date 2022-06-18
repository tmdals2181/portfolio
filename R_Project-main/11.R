# 11.3 네트워크 지표 분석

# 네트워크 만들기
install.packages("igraph")
library(igraph)

G.star <- make_star(6, mode="undirected", center=1) %>%
    set_vertex_attr("name", value = c("A", "B", "C", "D", "E", "F"))
plot(G.star, vertex.color=rainbow(6), vertex.size=60)

tkplot(G.star, vertex.color=rainbow(6), vertex.size=20)

G.ring <- make_ring(6, directed = FALSE, circular = TRUE) %>%
    set_vertex_attr("name", value = c("A", "B", "C", "D", "E", "F"))
tkplot(G.ring, vertex.color=rainbow(6), vertex.size=20)

G.Y <- make_graph(edges=NULL, n=NULL, directed=FALSE)
G.Y <- G.Y + vertices("A", "B", "C", "D", "E", "F")
G.Y <- G.Y + edges("A", "B",
                   "A", "C",
                   "A", "D",
                   "D", "E",
                   "E", "F")
tkplot(G.Y, vertex.color=rainbow(6), vertex.size=20)

# 연결 정도 중심성과 중심화
degree(G.star, normalized = FALSE)

degree(G.star, normalized = TRUE)

CD <- centralization.degree(G.star, normalized = FALSE)
CD

Tmax <- centralization.degree.tmax(G.ring)

CD$centralization / Tmax

# 근접 중심성과 중심화
closeness(G.star, normalized=FALSE)

closeness(G.star, normalized=TRUE)

CC <- centralization.closeness(G.star, normalized = FALSE)
CC$centralization / (6-1)

CC$theoretical_max / (6-1)

CC$centralization / CC$theoretical_max

# 중개 중심성과 중심화
betweenness(G.star, normalized=FALSE)

betweenness(G.star, normalized=TRUE)

CB <- centralization.betweenness(G.star, normalized=FALSE)
CB$centralization

CB$theoretical_max

CB$centralization / CB$theoretical_max
CB

#########################
# 네트워크 밀도
graph.density(G.star)

graph.density(G.Y)

graph.density(G.ring)

# 최단경로와 평균 거리
shortest.paths(G.Y)

distances(G.Y, v = "A", to="E")

get.shortest.paths(G.Y, "A", "E")$vpath[[1]]

average.path.length(G.Y)

# 11.4 페이스북 사용자 네트워크 분석
# 페이스북 사용자 데이터 읽기와 그래프 출력
install.packages("igraph")
library(igraph)
df.fb <- read.table(file.choose(), header=F)
head(df.fb)

tail(df.fb)

G.fb <- graph.data.frame(df.fb, directed=FALSE)
G.fb

par(mar=c(0,0,0,0))
plot(G.fb,
     vertex.label = NA,
     vertex.size = 10,
     vertex.color = rgb(0,1,0,0.5))

dev.off()

# 1~50번째 사용자들 간의 그래프
V(G.fb)$name

v.set <- V(G.fb)$name[1:50]
G.fb.part <- induced_subgraph(G.fb, v=v.set)
tkplot(G.fb.part,
       vertex.label.cex = 1.2,
       vertex.size = degree(G.fb.part)*1.5,
       vertex.color = "yellow",
       vertex.frame.color = "gray")

# ID가 1인 사용자와 연결된 그래프
v2 <- which(V(G.fb)$name == "1")
v2

v.set <- neighbors(G.fb, v=v2)
v.set

v3 <- c(v2, v.set)
G.fb.id <- induced_subgraph(G.fb, v=v3)
V(G.fb.id)$color <- ifelse(V(G.fb.id)$name == "1", "red", "yellow")
tkplot(G.fb.id,
       vertex.label.cex = 1.2,
       vertex.size = degree(G.fb.id)*1.5,
       vertex.frame.color = "gray")

# 연결정도가 가장 큰 사용자와 연결된 그래프
v.max <- V(G.fb)$name[degree(G.fb)==max(degree(G.fb))]
v.max

degree(G.fb, v.max)

v.max.idx <- which(V(G.fb)$name == v.max)
v.max.idx

v.set <- neighbors(G.fb, v=v.max.idx)
v3 <- c(v.max.idx, v.set)
G.fb_2 <- induced_subgraph(G.fb, v=v3)
V(G.fb_2)$color <- ifelse(V(G.fb_2)$name == v.max, "red", "yellow")
V(G.fb_2)$label <- ifelse(V(G.fb_2)$name == v.max, v.max, NA)
V(G.fb_2)$size <- ifelse(V(G.fb_2)$name == v.max, 50, 5)
plot(G.fb_2)

# 연결정도 중심성과 중심화 지표
degree(G.fb, normalized=FALSE)

degree(G.fb, normalized=TRUE)

CD <- centralization.degree(G.fb, normalized = FALSE)
CD$centralization

Tmax <- centralization.degree.tmax(G.fb)
Tmax

#페이스북 네트워크 그래프의 평균 연결 정보 = 0.2480944
CD$centralization / Tmax



# 근접 중심성과 중심화 지표
closeness(G.fb, normalized=FALSE)

closeness(G.fb, normalized=TRUE)

CB <- centralization.closeness(G.fb, normalized = FALSE)
n <- vcount(G.fb)
n

CB$centralization / (n-1)

CB$theoretical_max / (n-1)

CB$centralization / CB$theoretical_max



# 중개 중심성과 중심화 지표
betweenness(G.fb, normalized=FALSE)

closeness(G.fb, normalized=TRUE)

CB <- centralization.betweenness(G.fb, normalized = FALSE)
CB$centralization

CB$theoretical_max

CB$centralization / CB$theoretical_max

# 밀도 
graph.density(G.fb)

# 거리 
shortest.paths(G.fb)[1:10, 1:10]

# 3번째 노드와 7번째 노드 사이의 거리
distances(G.fb, v = "3", to="7")

get.shortest.paths(G.fb, "3", "7")$vpath[[1]]

#전체저 노드와 노드 연결의 패스는 3.6개의 노드를 거쳐야 연결이 가능해진다
average.path.length(G.fb)

# 연결정도 분포
plot(degree(G.fb),
     xlab="사용자 ID", ylab="연결 정도",
     main="사용자별 연결정도",
     type='h')

x <- degree(G.fb, normalized=F)
summary(x)

hist(x,
     xlab="연결 정도", ylab="빈도",
     main="연결정도 분포",
     breaks=seq(0, max(x), by=1))

G.fb.dist <- degree.distribution(G.fb)
plot(G.fb.dist,
     type="h",
     xlab="연결정도 분포", ylab="확률밀도",
     main="연결정도 분포")

