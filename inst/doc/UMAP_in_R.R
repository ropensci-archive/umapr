## ------------------------------------------------------------------------
library(umapr)
# select only numeric columns
embedding <- as.data.frame(umap(as.matrix(iris[ , 1:4])))

# look at result
head(embedding)

# plot result
library(tidyverse)
ggplot(embedding, aes(x = V1, y = V2, color = iris$Species)) + 
  geom_point()

## ------------------------------------------------------------------------
neighbors <- c(4, 8, 16, 32, 64, 128)

f <- lapply(neighbors, function(neighbor) {
  iris_result <- umap(as.matrix(iris[,1:4]), n_neighbors = as.integer(neighbor))
  cbind(as.data.frame(iris_result), data.frame(Species = iris$Species))
})

names(f) <- neighbors

bind_rows(f, .id = "Neighbor") %>% 
  mutate(Neighbor = as.integer(Neighbor)) %>% 
  ggplot(aes(V1, V2, color = Species)) + geom_point() + 
  facet_wrap(~ Neighbor, scales = "free")

## ------------------------------------------------------------------------
dists <- c(0.001, 0.01, 0.05, 0.1, 0.5, 0.99)

f <- lapply(dists, function(dist) {
  iris_result <- umap(as.matrix(iris[,1:4]), min_dist = dist)
  cbind(as.data.frame(iris_result), data.frame(Species = iris$Species))
})

names(f) <- dists

bind_rows(f, .id = "Distance") %>% 
  ggplot(aes(V1, V2, color = Species)) + geom_point() + 
  facet_wrap(~ Distance, scales = "free")

## ------------------------------------------------------------------------
dists <- c("euclidean", "manhattan", "canberra", "cosine", "hamming", "dice")

f <- lapply(dists, function(dist) {
  iris_result <- umap(as.matrix(iris[,1:4]), metric = dist)
  cbind(as.data.frame(iris_result), data.frame(Species = iris$Species))
})

names(f) <- dists

bind_rows(f, .id = "Metric") %>% 
  ggplot(aes(V1, V2, color = Species)) + geom_point() + 
  facet_wrap(~ Metric, scales = "free")

