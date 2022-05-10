
<!-- README.md is generated from README.Rmd. Please edit that file -->
umapr
=====

[![Project Status: Abandoned – Initial development has started, but there has not yet been a stable, usable release; the project has been abandoned and the author(s) do not intend on continuing development.](https://www.repostatus.org/badges/latest/abandoned.svg)](https://www.repostatus.org/#abandoned)
[![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/umapr.svg?branch=master)](https://travis-ci.org/ropenscilabs/umapr) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/juyeongkim/umapr?branch=master&svg=true)](https://ci.appveyor.com/project/juyeongkim/umapr) [![codecov](https://codecov.io/gh/ropenscilabs/umapr/branch/master/graph/badge.svg)](https://codecov.io/gh/ropenscilabs/umapr)

`umapr` wraps the Python implementation of UMAP to make the algorithm accessible from within R. It uses the great [`reticulate`](https://cran.r-project.org/web/packages/reticulate/index.html) package.

Uniform Manifold Approximation and Projection (UMAP) is a non-linear dimensionality reduction algorithm. It is similar to t-SNE but computationally more efficient. UMAP was created by Leland McInnes and John Healy ([github](https://github.com/lmcinnes/umap), [arxiv](https://arxiv.org/abs/1802.03426)).

Recently, two new UMAP R packages have appeared. These new packages provide more features than `umapr` does and they are more actively developed. These packages are:

-   [umap](https://github.com/tkonopka/umap), which provides the same Python wrapping function as `umapr` and also an R implementation, removing the need for the Python version to be installed. It is available on [CRAN](https://cran.r-project.org/web/packages/umap/index.html).

-   [uwot](https://github.com/jlmelville/uwot), which also provides an R implementation, removing the need for the Python version to be installed.

Contributors
------------

[Angela Li](https://github.com/angela-li), [Ju Kim](https://github.com/juyeongkim), [Malisa Smith](https://github.com/malisas), [Sean Hughes](https://github.com/seaaan), [Ted Laderas](https://github.com/laderast)

`umapr` is a project that was first developed at [rOpenSci Unconf 2018](http://unconf18.ropensci.org).

Installation
------------

**First**, you will need to install `Python` and the `UMAP` package. Instruction available [here](https://github.com/lmcinnes/umap#installing).

Then, you can install the development version from [GitHub](https://github.com/) with:

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
df <- as.matrix(iris[ , 1:4])

# run UMAP algorithm
embedding <- umap(df)
```

`umap` returns a `data.frame` with two attached columns called "UMAP1" and "UMAP2". These columns represent the UMAP embeddings of the data, which are column-bound to the original data frame.

``` r
# look at result
head(embedding)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width    UMAP1     UMAP2
#> 1          5.1         3.5          1.4         0.2 5.647059 -6.666872
#> 2          4.9         3.0          1.4         0.2 4.890193 -8.130815
#> 3          4.7         3.2          1.3         0.2 4.397037 -7.546669
#> 4          4.6         3.1          1.5         0.2 4.412886 -7.633424
#> 5          5.0         3.6          1.4         0.2 5.707233 -6.863213
#> 6          5.4         3.9          1.7         0.4 6.442851 -5.726554

# plot the result
embedding %>% 
  mutate(Species = iris$Species) %>%
  ggplot(aes(UMAP1, UMAP2, color = Species)) + geom_point()
```

![](img/unnamed-chunk-3-1.png)

There is a function called `run_umap_shiny()` which will bring up a Shiny app for exploring different colors of the variables on the umap plots.

``` r
run_umap_shiny(embedding)
```

![Shiny App for Exploring Results](img/shiny.png)

Function parameters
-------------------

There are a few important parameters. These are fully described in the UMAP Python [documentation](https://github.com/lmcinnes/umap/blob/bf1c3e5c89ea393c9de10bd66c5e3d9bc30588ee/notebooks/UMAP%20usage%20and%20parameters.ipynb).

The `n_neighbor` argument can range from 2 to n-1 where n is the number of rows in the data.

``` r
neighbors <- c(4, 8, 16, 32, 64, 128)



neighbors %>% 
  map_df(~umap(as.matrix(iris[,1:4]), n_neighbors = .x) %>% 
      mutate(Species = iris$Species, Neighbor = .x)) %>% 
  mutate(Neighbor = as.integer(Neighbor)) %>% 
  ggplot(aes(UMAP1, UMAP2, color = Species)) + 
    geom_point() + 
    facet_wrap(~ Neighbor, scales = "free")
```

![](img/unnamed-chunk-5-1.png)

The `min_dist` argument can range from 0 to 1.

``` r
dists <- c(0.001, 0.01, 0.05, 0.1, 0.5, 0.99)

dists %>% 
  map_df(~umap(as.matrix(iris[,1:4]), min_dist = .x) %>% 
      mutate(Species = iris$Species, Distance = .x)) %>% 
  ggplot(aes(UMAP1, UMAP2, color = Species)) + 
    geom_point() + 
    facet_wrap(~ Distance, scales = "free")
```

![](img/unnamed-chunk-6-1.png)

The `distance` argument can be many different distance functions.

``` r
dists <- c("euclidean", "manhattan", "canberra", "cosine", "hamming", "dice")

dists %>% 
  map_df(~umap(as.matrix(iris[,1:4]), metric = .x) %>% 
      mutate(Species = iris$Species, Metric = .x)) %>% 
  ggplot(aes(UMAP1, UMAP2, color = Species)) + 
    geom_point() + 
    facet_wrap(~ Metric, scales = "free")
```

![](img/unnamed-chunk-7-1.png)

Comparison to t-SNE and principal components analysis
-----------------------------------------------------

t-SNE and UMAP are both non-linear dimensionality reduction methods, in contrast to PCA. Because t-SNE is relatively slow, PCA is sometimes run first to reduce the dimensions of the data.

We compared UMAP to PCA and t-SNE alone, as well as to t-SNE run on data preprocessed with PCA. In each case, the data were subset to include only complete observations. The code to reproduce these findings are available in [`timings.R`](timings.R).

The first data set is the same iris data set used above (149 observations of 4 variables):

![t-SNE, PCA, and UMAP on iris](img/multiple_algorithms_iris.png)

Next we tried a cancer data set, made up of 699 observations of 10 variables:

![t-SNE, PCA, and UMAP on cancer](img/multiple_algorithms_cancer.png)

Third we tried a soybean data set. It is made up of 531 observations and 35 variables:

![t-SNE, PCA, and UMAP on soybeans](img/multiple_algorithms_bean.png)

Finally we used a large single-cell RNAsequencing data set, with 561 observations (cells) of 55186 variables (over 30 million elements)!

![t-SNE, PCA, and UMAP on rna](img/multiple_algorithms_rna.png)

PCA is orders of magnitude faster than t-SNE or UMAP (not shown). UMAP, though, is a substantial improvement over t-SNE both in terms of memory and time taken to run.

![Time to run t-SNE vs UMAP](img/multiple_algorithms_time.png)

![Memory to run t-SNE vs UMAP](img/multiple_algorithms_memory.png)

Related projects
----------------

-   [`umap`](https://github.com/tkonopka/umap): R implementation of UMAP
-   [`seurat`](https://github.com/satijalab/seurat): R toolkit for single cell genomics
-   [`smallvis`](https://github.com/jlmelville/smallvis): R package for dimensionality reduction of small datasets
