library(umapr)
library(Rtsne)
library(tidyverse)

# stuff to compare algorithms -------------------------------------------------
embed <- function(labels, d) {
  times <- mark(
    um <- umap(d),
    ts <- Rtsne(d)$Y,
    ts_no_pca <- Rtsne(d, pca = FALSE)$Y,
    check = FALSE)

  pca <- prcomp(d)$x[,1:2]

  times$expression <- c("UMAP", "PCA + t-SNE", "t-SNE")

  combo <- function(embedding, name) {
    colnames(embedding) <- c("V1", "V2")
    embedding %>%
      as.data.frame() %>%
      mutate(Algorithm = name, Class = labels)
  }

  list(times = times,
    results = bind_rows(
      combo(pca, "PCA"),
      mutate(um, Algorithm = "UMAP", Class = labels, V1 = UMAP1, V2 = UMAP2),
      combo(ts, "PCA + t-SNE"),
      combo(ts_no_pca, "t-SNE")))
}

plot_embeddings <- function(embeddings, dataset) {
  ggplot(embeddings, aes(V1, V2, color = Class)) +
    geom_point() + facet_wrap(~ Algorithm, scales = "free") +
    ggtitle(dataset)
}

# iris -----------------------------------------------------------------------
d <- iris
d <- d[!duplicated(d), ]
with_labels <- d
d <- as.matrix(d[ , 1:4])

iris_result <- embed(with_labels$Species, d)

# cancer ---------------------------------------------------------------------
library(mlbench)
data("BreastCancer")
d <- BreastCancer[ , 2:11]
d <- d[!duplicated(d), ]
d <- d[complete.cases(d), ]
labels <- d$Class
d <- as.matrix(d[ , 1:9])
d <- apply(d, 2, as.numeric)

cancer_result <- embed(labels, d)

# beans -----------------------------------------------------------
data(Soybean)
d <- Soybean
d <- d[!duplicated(d[,2:36]), ]
d <- d[complete.cases(d[,2:36]), ]
labels <- d$Class
d <- as.matrix(d[ , 2:36])
d <- apply(d, 2, as.numeric)

bean_result <- embed(labels, d)

# some scRNAseq -------------------------------------------------------------
#https://hemberg-lab.github.io/scRNA.seq.datasets/human/tissues/
library(SingleCellExperiment)
x <- readRDS("~/Desktop/li.rds")
y <- t(logcounts(x))
rm(x)

labels <- str_extract(rownames(y), "[^_]*$")

sc_rna_seq_result <- embed(labels, y)

# display results ----------------------------------------------------------
plot_embeddings(iris_result$results, "iris")
ggsave("img/multiple_algorithms_iris.png", width = 6, height = 5, dpi = 300)
plot_embeddings(cancer_result$results, "cancer")
ggsave("img/multiple_algorithms_cancer.png", width = 6, height = 5, dpi = 300)
plot_embeddings(bean_result$results, "bean")
ggsave("img/multiple_algorithms_bean.png", width = 6, height = 5, dpi = 300)
plot_embeddings(sc_rna_seq_result$results, "scRNAseq")
ggsave("img/multiple_algorithms_rna.png", width = 6, height = 5, dpi = 300)

# times -------------------------------------------------------------------
combo_times <- function(times, dataset) {
  dplyr::select(times, expression, median, mem_alloc) %>%
    dplyr::mutate(Data = dataset)
}

times <- suppressWarnings(bind_rows(combo_times(iris_result$times, "iris"),
  combo_times(cancer_result$times, "cancer"),
  combo_times(bean_result$times, "bean"),
  combo_times(sc_rna_seq_result$times, "scRNAseq")))

ggplot(times, aes(x = expression, y = median)) +
  geom_col()+ facet_wrap(~ Data, scales = "free_y") +
  ylab("Time (s)") + xlab(NULL) +
  ggtitle("Time taken to run dimensionality reduction on dataset")

ggsave("img/multiple_algorithms_time.png", width = 6, height = 5, dpi = 300)

ggplot(times, aes(x = expression, y = mem_alloc)) +
  geom_col()+ facet_wrap(~ Data, scales = "free_y") +
  ylab("Memory (bytes)") + xlab(NULL) +
  ggtitle("Memory used to run dimensionality reduction on dataset")
ggsave("img/multiple_algorithms_memory.png", width = 6, height = 5, dpi = 300)
