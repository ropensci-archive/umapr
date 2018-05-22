
<!-- README.md is generated from README.Rmd. Please edit that file -->
umapr
=====

[![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/umapr.svg?branch=master)](https://travis-ci.org/ropenscilabs/umapr)

`umapr` wraps the Python implementation of UMAP to make the algorithm accessible from within R.

Uniform Manifold Approximation and Projection (UMAP) is a non-linear dimensionality reduction algorithm. It is similar to t-SNE but computationally more efficient. UMAP was created by Leland McInnes and John Healy ([github](https://github.com/lmcinnes/umap), [arxiv](https://arxiv.org/abs/1802.03426)).

Installation
------------

You can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ropenscilabs/umapr")
```

Basic use
---------

Here is an example of running UMAP on the `iris` data set.

``` r
library(umapr)
library(tidyverse)

# select only numeric columns
df <- iris[ , 1:4]

# run UMAP algorithm
embedding <- umap(df)
```

`umap` returns a `data.frame` with two attached columns called "UMAP1" and "UMAP2". These columns represent the UMAP embeddings of the data, which are column-bound to the original data frame.

``` r
# look at result
head(embedding)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width     UMAP1      UMAP2
#> 1          5.1         3.5          1.4         0.2 -13.23999 -0.7355436
#> 2          4.9         3.0          1.4         0.2 -12.50639 -2.8071050
#> 3          4.7         3.2          1.3         0.2 -12.18168 -2.1712356
#> 4          4.6         3.1          1.5         0.2 -12.40702 -2.5013227
#> 5          5.0         3.6          1.4         0.2 -13.51378 -0.8766937
#> 6          5.4         3.9          1.7         0.4 -13.01444  0.3315915

# plot the result
embedding %>% 
  bind_cols(embedding, Species = iris$Species) %>%
  ggplot(aes(UMAP1, UMAP2, color = Species)) + geom_point()
```

![](img/unnamed-chunk-3-1.png)

There is a function called `run_shiny_app()` which will bring up a Shiny app for exploring different colors of the variables on the umap plots.

``` r
run_shiny_app(embedding)
```

![Shiny App for Exploring Results](img/shiny.png)

Function parameters
-------------------

There are a few important parameters. These are fully described in the UMAP Python [documentation](https://github.com/lmcinnes/umap/blob/bf1c3e5c89ea393c9de10bd66c5e3d9bc30588ee/notebooks/UMAP%20usage%20and%20parameters.ipynb).

The `n_neighbor` argument can range from 2 to n-1 where n is the number of rows in the data.

``` r
neighbors <- c(4, 8, 16, 32, 64, 128)

result <- lapply(neighbors, function(neighbor) {
  iris_result <- umap(iris[, 1:4], n_neighbors = neighbor)
 
  cbind(iris_result, Species = iris$Species)
})

names(result) <- neighbors

bind_rows(result, .id = "Neighbor") %>% 
  mutate(Neighbor = as.integer(Neighbor)) %>% 
  ggplot(aes(UMAP1, UMAP2, color = Species)) + 
    geom_point() + 
    facet_wrap(~ Neighbor, scales = "free")
```

![](img/unnamed-chunk-5-1.png)

The `min_dist` argument can range from 0 to 1.

``` r
dists <- c(0.001, 0.01, 0.05, 0.1, 0.5, 0.99)

result <- lapply(dists, function(dist) {
  iris_result <- umap(iris[, 1:4], min_dist = dist)
  cbind(iris_result, Species = iris$Species)
})

names(result) <- dists

bind_rows(result, .id = "Distance") %>% 
  ggplot(aes(UMAP1, UMAP2, color = Species)) + 
    geom_point() + 
    facet_wrap(~ Distance, scales = "free")
```

![](img/unnamed-chunk-6-1.png)

The `distance` argument can be many different distance functions.

``` r
dists <- c("euclidean", "manhattan", "canberra", "cosine", "hamming", "dice")

result <- lapply(dists, function(dist) {
  iris_result <- umap(iris[,1:4], metric = dist)
  cbind(iris_result, Species = iris$Species)
})

names(result) <- dists

bind_rows(result, .id = "Metric") %>% 
  ggplot(aes(UMAP1, UMAP2, color = Species)) + 
    geom_point() + 
    facet_wrap(~ Metric, scales = "free")
```

![](img/unnamed-chunk-7-1.png)

Comparison to t-SNE and principal components analysis
-----------------------------------------------------

t-SNE and UMAP are both non-linear dimensionality reduction methods, in contrast to PCA. Because t-SNE is relatively slow, PCA is sometimes run first to reduce the dimensions of the data.

We compared UMAP to PCA and t-SNE alone, as well as to t-SNE run on data preprocessed with PCA. In each case, the data were subset to include only complete observations. The code to reproduce these findings are available in `timings.R`.

The first data set is the same iris data set used above (149 observations of 4 variables):

![t-SNE, PCA, and UMAP on iris](img/multiple_algorithms_iris.png)

Next we tried a cancer data set, made up of 699 observations of 10 variables:

![t-SNE, PCA, and UMAP on cancer](img/multiple_algorithms_cancer.png)

Third we tried a soybean data set. It is made up of 531 observations and 35 variables:

![t-SNE, PCA, and UMAP on soybeans](img/multiple_algorithms_bean.png)

Finally we used a large single-cell RNAsequencing data set, with 551 observations (cells) of 55000 variables!

![t-SNE, PCA, and UMAP on rna](img/multiple_algorithms_rna.png)

PCA is orders of magnitude faster than t-SNE or UMAP (not shown). UMAP, though, is a substantial improvement over t-SNE both in terms of memory and time taken to run.

![Time to run t-SNE vs UMAP](img/multiple_algorithms_time.png)

![Memory to run t-SNE vs UMAP](img/multiple_algorithms_memory.png)
