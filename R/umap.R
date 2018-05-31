#' umap
#'
#' @description Provides an interface to the UMAP algorithm implemented in Python.
#'
#' @references Leland McInnes and John Healy (2018). UMAP: Uniform Manifold 
#' Approximation and Projection for Dimension Reduction. 
#' ArXiv e-prints 1802.03426.
#'
#' @param data data frame or matrix. input data.
#' @param n_neighbors integer. The size of local neighborhood 
#' (in terms of number of neighboring sample points) used for manifold 
#' approximation. Larger values result in more global views of the manifold, 
#' while smaller values result in more local data being preserved. In general 
#' values should be in the range 2 to 100.
#' @param n_components integer The dimension of the space to embed into. This 
#' defaults to 2 to provide easy visualization, but can reasonably be set to 
#' any integer value in the range 2 to 100.
#' @param metric character. The metric to use to compute distances in high 
#' dimensional space. If a string is passed it must match a valid predefined 
#' metric. If a general metric is required a function that takes two 1d arrays 
#' and returns a float can be provided. For performance purposes it is required 
#' that this be a numba jit'd function. Valid string metrics include: euclidean, 
#' manhattan, chebyshev, minkowski, canberra, braycurtis, mahalanobis, 
#' wminkowski, seuclidean, cosine, correlation, haversine, hamming, jaccard, 
#' dice, russelrao, kulsinski, rogerstanimoto, sokalmichener, sokalsneath, yule. 
#' Metrics that take arguments (such as minkowski, mahalanobis etc.) can have 
#' arguments passed via the metric_kwds dictionary. At this time care must be 
#' taken and dictionary elements must be ordered appropriately; this will 
#' hopefully be fixed in the future.
#' @param n_epochs integer The number of training epochs to use in optimization.
#' @param alpha numeric. The initial learning rate for the embedding optimization.
#' @param init character. How to initialize the low dimensional embedding. 
#' Options are: 'spectral' (use a spectral embedding of the fuzzy 1-skeleton),
#' 'random' (assign initial embedding positions at random), 
#' * A numpy array of initial embedding positions.
#' @param spread numeric. The effective scale of embedded points. 
#' In combination with ``min_dist`` this determines how clustered/clumped the 
#' embedded points are.
#' @param min_dist numeric.  The effective minimum distance between embedded 
#' points. Smaller values will result in a more clustered/clumped embedding 
#' where nearby points on the manifold are drawn closer together, while larger 
#' values will result on a more even dispersal of points. The value should be 
#' set relative to the ``spread`` value, which determines the scale at which 
#' embedded points will be spread out.
#' @param set_op_mix_ratio numeric. Interpolate between (fuzzy) union and 
#' intersection as the set operation used to combine local fuzzy simplicial 
#' sets to obtain a global fuzzy simplicial sets. Both fuzzy set operations use 
#' the product t-norm. The value of this parameter should be between 0.0 and 
#' 1.0; a value of 1.0 will use a pure fuzzy union, while 0.0 will use a pure 
#' fuzzy intersection.
#' @param local_connectivity integer The local connectivity required -- i.e. 
#' the number of nearest neighbors that should be assumed to be connected at a 
#' local level. The higher this value the more connected the manifold becomes 
#' locally. In practice, this should be not more than the local intrinsic 
#' dimension of the manifold.
#' @param bandwidth numeric. The effective bandwidth of the kernel if we view 
#' the algorithm as similar to Laplacian eigenmaps. Larger values induce more 
#' connectivity and a more global view of the data, smaller values concentrate 
#' more locally.
#' @param gamma numeric. Weighting applied to negative samples in low 
#' dimensional embedding optimization. Values higher than one will result in 
#' greater weight being given to negative samples.
#' @param negative_sample_rate numeric. The number of negative edge/1-simplex 
#' samples to use per positive edge/1-simplex sample in optimizing the low 
#' dimensional embedding.
#' @param a numeric. More specific parameters controlling the embedding. 
#' If NULL, these values are set automatically as determined by ``min_dist`` 
#' and ``spread``.
#' @param b numeric. More specific parameters controlling the embedding. 
#' If NULL, these values are set automatically as determined by ``min_dist`` 
#' and ``spread``.
#' @param random_state integer. If integer, random_state is the seed used by the 
#' random number generator; If NULL, the random number generator is the 
#' RandomState instance used by `np.random`.
#' @param metric_kwds reticulate dictionary. Arguments to pass on to the metric, 
#' such as the ``p`` value for Minkowski distance.
#' @param angular_rp_forest logical. Whether to use an angular random projection 
#' forest to initialise the approximate nearest neighbor search. This can be 
#' faster, but is mostly on useful for metric that use an angular style distance 
#' such as cosine, correlation etc. In the case of those metrics angular forests 
#' will be chosen automatically.
#' @param verbose logical. Controls verbosity of logging.
#'
#' @return matrix
#' @export
#' @importFrom assertthat assert_that is.count is.flag
#' @importFrom reticulate dict
#'
#' @examples
#' umap(as.matrix(iris[, 1:4]))
#' umap(iris[, 1:4])
umap <- function(data,
                 n_neighbors = 15L,
                 n_components = 2L,
                 metric = "euclidean",
                 n_epochs = NULL,
                 alpha = 1.0,
                 init = "spectral",
                 spread = 1.0,
                 min_dist = 0.1,
                 set_op_mix_ratio = 1.0,
                 local_connectivity = 1L,
                 bandwidth = 1.0,
                 gamma = 1.0,
                 negative_sample_rate = 5L,
                 a = NULL,
                 b = NULL,
                 random_state = NULL,
                 metric_kwds = dict(),
                 angular_rp_forest = FALSE,
                 verbose = FALSE) {
  assert_that(is.matrix(data) | is.data.frame(data), msg = "Data must be a data frame or a matrix.")
  if (!all(unlist(lapply(data, is.numeric)))) stop("All columns should be numeric.")
  assert_that(is.count(n_neighbors))
  assert_that(is.count(n_components))
  assert_that(is.character(metric), msg = "Valid string metrics include: euclidean, manhattan, chebyshev, minkowski, canberra, braycurtis, mahalanobis, wminkowski, seuclidean, cosine, correlation, haversine, hamming, jaccard, dice, russelrao, kulsinski, rogerstanimoto, sokalmichener, sokalsneath, yule.")
  assert_that(is.null(n_epochs) | is.count(n_epochs), msg = "n_epochs is not a count (a single positive integer)")
  assert_that(is.numeric(alpha))
  assert_that(init %in% c("spectral", "random"), msg = "init must be one of 'spectral', 'random', or a numpy array of initial embedding positions")
  assert_that(is.numeric(spread))
  assert_that(is.numeric(min_dist))
  assert_that(is.numeric(set_op_mix_ratio))
  assert_that(is.count(local_connectivity))
  assert_that(is.numeric(bandwidth))
  assert_that(is.numeric(gamma))
  assert_that(is.count(negative_sample_rate))
  assert_that(is.null(a) | is.numeric(a))
  assert_that(is.null(b) | is.numeric(b))
  assert_that(is.null(random_state) | is.count(random_state))
  assert_that(is_dict(metric_kwds), msg = "metric_kwds must be a Python dictionary object, you can create it using 'reticulate::dict()'")
  assert_that(is.flag(angular_rp_forest))
  assert_that(is.flag(verbose))

  umap_vec <- umap_module$UMAP(
    n_neighbors = as.integer(n_neighbors),
    n_components = as.integer(n_components),
    metric = metric,
    n_epochs = n_epochs,
    alpha = alpha,
    init = init,
    spread = spread,
    min_dist = min_dist,
    set_op_mix_ratio = set_op_mix_ratio,
    local_connectivity = local_connectivity,
    bandwidth = bandwidth,
    gamma = gamma,
    negative_sample_rate = as.integer(negative_sample_rate),
    a = a,
    b = a,
    random_state = random_state,
    metric_kwds = metric_kwds,
    angular_rp_forest = angular_rp_forest,
    verbose = verbose
  )$fit_transform(as.matrix(data))
  
  colnames(umap_vec) <- paste0("UMAP", seq_len(ncol(umap_vec)))
  
  output <- data.frame(cbind(data, umap_vec))
  
  #make_umap_object(output)
  output
}

is_dict <- function(x) {
  inherits(x, "python.builtin.dict")
}
