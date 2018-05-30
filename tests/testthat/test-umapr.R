context("UMAP wrapper tests")
library(umapr)
library(reticulate)

# From https://cran.r-project.org/web/packages/reticulate/vignettes/package.html
# helper function to skip tests if we don't have the 'foo' module
skip_if_no_umap <- function() {
  have_umap <- py_module_available("umap")
  if (!have_umap)
    skip("umap not available for testing")
}

skip_if_no_sklearn.datasets <- function() {
  have_sklearn.datasets <- py_module_available("sklearn.datasets")
  if (!have_sklearn.datasets)
    skip("sklearn.datasets not available for testing")
}

# Here we perform the actual testing
test_that("Things work as expected", {
  skip_if_no_umap()
  skip_if_no_sklearn.datasets()

  # Generate/Load some data
  set.seed(1)
  data = cbind(matrix(rexp( 100 * 10, runif(1, 1E-5, 1E-3) ), 100, 10))

  # The function should check the input types to make sure they are correct
  expect_error(umap(data = "Not a matrix"), "Data must be a data frame or a matrix")
  expect_error(umap(data = "This is not a matrix or a data frame"), "Data must be a data frame or a matrix.")
  expect_error(umap(data = data, n_neighbors = "Not count"), "n_neighbors is not a count")
  expect_error(umap(data = data, n_components = "Not count"), "n_components is not a count")
  # metric must be one of the options listed here: https://github.com/lmcinnes/umap/blob/bf1c3e5c89ea393c9de10bd66c5e3d9bc30588ee/umap/umap_.py#L1211
  expect_error(umap(data = data, metric = "not a valid metric"), "Valid metrics are")
  expect_error(umap(data = data, n_epochs = "Not count"), "n_epochs is not a count")
  expect_error(umap(data = data, alpha = "Not numeric"), "alpha is not a numeric")
  expect_error(umap(data = data, init = "not a valid init"), "init must be one of 'spectral', 'random', or a numpy array of initial embedding positions")
  expect_error(umap(data = data, spread = "Not numeric"), "spread is not a numeric")
  expect_error(umap(data = data, min_dist = "Not numeric"), "min_dist is not a numeric")
  expect_error(umap(data = data, set_op_mix_ratio = "Not numeric"), "set_op_mix_ratio is not a numeric")
  expect_error(umap(data = data, local_connectivity = 2.4), "local_connectivity is not a count")
  expect_error(umap(data = data, bandwidth = "Not numeric"), "bandwidth is not a numeric")
  expect_error(umap(data = data, gamma = "Not numeric"), "gamma is not a numeric")
  expect_error(umap(data = data, negative_sample_rate = 2.4), "negative_sample_rate is not a count")
  expect_error(umap(data = data, a = "Not numeric"), "not TRUE")
  expect_error(umap(data = data, b = "Not numeric"), "not TRUE")
  expect_error(umap(data = data, random_state = 2.4), "not TRUE")
  expect_error(umap(data = data, metric_kwds = 2.4), "metric_kwds must be a Python dictionary object")
  expect_error(umap(data = data, angular_rp_forest = 2.4), "angular_rp_forest is not a flag")
  expect_error(umap(data = data, verbose = 2.4), "verbose is not a flag")

  # try running umap with the same seed twice, see if you get the same thing
  expect_true(identical(umap(data = data, random_state = 3L),
                        umap(data = data, random_state = 3L)))
})

# test_that("R6 tests",
#           {
#
#               set.seed(1)
#               data = cbind(matrix(rexp( 100 * 10, runif(1, 1E-5, 1E-3) ), 100, 10))
#               colnames(data) <- c(letters[1:10])
#               out <- umap(data)
#
#               expect_equal(class(out)[1], "umap_obj")
#               pl <- out$plot("a")
#               expect_equal(class(pl)[-1], "ggplot")
#
#
#           })
