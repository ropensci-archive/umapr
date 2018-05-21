## ------------------------------------------------------------------------
library(umapr)
# select only numeric columns
embedding <- as.data.frame(umap(as.matrix(iris[ , 1:4])))

# look at result
head(embedding)

# plot result
library(ggplot2)
ggplot(embedding, aes(x = V1, y = V2, color = iris$Species)) + 
  geom_point()

## ------------------------------------------------------------------------


