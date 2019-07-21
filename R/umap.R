#' umap
#'
#' @description Provides an interface to the UMAP algorithm implemented in Python.
#'
#' @references Leland McInnes and John Healy (2018). UMAP: Uniform Manifold
#' Approximation and Projection for Dimension Reduction.
#' ArXiv e-prints 1802.03426.
#'
#' @param data data frame or matrix. input data.
#' @param include_input logical. Attach input data to UMAP embeddings if desired.
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
#' @param learning_rate numeric. The initial learning rate for the embedding optimization.
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
#' @param repulsion_strength numeric. Weighting applied to negative samples in 
#' low dimensional embedding optimization. Values higher than one will result in
#'  greater weight being given to negative samples.
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
#' @param transform_queue_size numeric. For transform operations (embedding new points
#'  using a trained model_ this will control how aggressively to search for 
#'  nearest neighbors. Larger values will result in slower performance but
#'   more accurate nearest neighbor evaluation.
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
#' @param target_n_neighbors integer. The number of nearest neighbors to use to 
#' construct the target simplcial set. If set to -1 use the n_neighbors value.
#' @param target_metric character or function. The metric used to measure distance
#' for a target array is using supervised dimension reduction. By default this is
#' ‘categorical’ which will measure distance in terms of whether categories match
#' or are different. Furthermore, if semi-supervised is required target values of 
#' -1 will be trated as unlabelled under the ‘categorical’ metric. If the target
#' array takes continuous values (e.g. for a regression problem) then metric of 
#' ‘l1’ or ‘l2’ is probably more appropriate.
#' @param target_metric_kwds reticulate dictionary. Keyword argument to pass to 
#' the target metric when performing supervised dimension reduction. If None then
#' no arguments are passed on.
#' @param target_weight numeric. weighting factor between data topology and target 
#' topology. A value of 0.0 weights entirely on data, a value of 1.0 weights 
#' entirely on target. The default of 0.5 balances the weighting equally between 
#' data and target.
#' @param transform_seed integer. Random seed used for the stochastic aspects of 
#' the transform operation. This ensures consistency in transform operations.
#' @param verbose logical. Controls verbosity of logging.
#'
#' @return matrix
#' @export
#' @importFrom assertthat assert_that is.count is.flag
#' @importFrom reticulate dict r_to_py py_module_available py_install import use_condaenv py_available
#'
#' @examples
#' #test only if umap python module 
#' if(reticulate::py_module_available("umap")){}
#' 
#' #import umap library (and load python module)
#' 
#' library("umapr")
#' umap(as.matrix(iris[, 1:4]))
#' umap(iris[, 1:4])
#' 
#' 
#' }
umap <- function(data,
                 include_input = TRUE,
                 n_neighbors = 15L,
                 n_components = 2L,
                 metric = "euclidean",
                 n_epochs = NULL,
                 learning_rate = 1.0,
                 alpha = 1.0,
                 init = "spectral",
                 spread = 1.0,
                 min_dist = 0.1,
                 set_op_mix_ratio = 1.0,
                 local_connectivity = 1L,
                 repulsion_strength = 1.0,
                 bandwidth = 1.0,
                 gamma = 1.0,
                 negative_sample_rate = 5L,
                 transform_queue_size = 4.0,
                 a = NULL,
                 b = NULL,
                 random_state = NULL,
                 metric_kwds = dict(),
                 angular_rp_forest = FALSE,
                 target_n_neighbors = -1L,
                 target_metric = "categorical",
                 target_metric_kwds = dict(),
                 target_weight =  0.5,
                 transform_seed = 42L,
                 verbose = FALSE) {
  assert_that(is.matrix(data) | is.data.frame(data), msg = "Data must be a data frame or a matrix.")
  if (!all(unlist(lapply(data, is.numeric)))) stop("All columns should be numeric.")
  assert_that(is.logical(include_input))
  assert_that(is.count(n_neighbors))
  assert_that(is.count(n_components))
  assert_that(is.character(metric), msg = "Valid string metrics include: euclidean, manhattan, chebyshev, minkowski, canberra, braycurtis, mahalanobis, wminkowski, seuclidean, cosine, correlation, haversine, hamming, jaccard, dice, russelrao, kulsinski, rogerstanimoto, sokalmichener, sokalsneath, yule.")
  assert_that(is.null(n_epochs) | is.count(n_epochs), msg = "n_epochs is not a count (a single positive integer)")
  assert_that(is.numeric(learning_rate))
  assert_that(is.numeric(alpha))
  assert_that(init %in% c("spectral", "random"), msg = "init must be one of 'spectral', 'random', or a numpy array of initial embedding positions")
  assert_that(is.numeric(spread))
  assert_that(is.numeric(min_dist))
  assert_that(is.numeric(set_op_mix_ratio))
  assert_that(is.count(local_connectivity))
  assert_that(is.numeric(repulsion_strength))
  assert_that(is.numeric(bandwidth))
  assert_that(is.numeric(gamma))
  assert_that(is.count(negative_sample_rate))
  assert_that(is.numeric(transform_queue_size))
  assert_that(is.null(a) | is.numeric(a))
  assert_that(is.null(b) | is.numeric(b))
  assert_that(is.null(random_state) | is.count(random_state))
  assert_that(is_dict(metric_kwds), msg = "metric_kwds must be a Python dictionary object, you can create it using 'reticulate::dict()'")
  assert_that(is.flag(angular_rp_forest))
  assert_that(is.integer(target_n_neighbors))
  assert_that(is.character(target_metric) | is.function(target_metric))
  assert_that(is_dict(target_metric_kwds))
  assert_that(is.numeric(target_weight))
  assert_that(is.integer(transform_seed))
  assert_that(is.flag(verbose))
  
  # keyword "alpha" was renamed "initial_alpha" in a later version of the
  # python library, try running it both ways in case of failure
  
  
  modules <- py_module_available("umap")
  if(!modules){
    install_python_modules <- function(method = "auto", conda = "auto") {
      py_install("umap-learn", method = method, conda = conda)
    }
    tryCatch(install_python_modules(), 
             error = function(e) {
               modules <- FALSE
             },
             finally = "umap-learn installed")
    modules <- py_module_available("umap")
  } else {
    print("umap-learn already installed")
  }
  
  umap_module <- import("umap")
  
  umap_vec <- tryCatch(
    umap_module$UMAP(
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
      gamma = r_to_py(gamma),
      negative_sample_rate = as.integer(negative_sample_rate),
      a = a,
      b = b,
      random_state = random_state,
      metric_kwds = metric_kwds,
      angular_rp_forest = angular_rp_forest,
      verbose = verbose
    )$fit_transform(as.matrix(data)),
    error = function(e) {
      if (grepl("alpha", e$message)) {
        umap_module$UMAP(
          n_neighbors = r_to_py(as.integer(n_neighbors)),
          n_components = r_to_py(as.integer(n_components)),
          metric = r_to_py(metric),
          n_epochs = r_to_py(n_epochs),
          learning_rate = r_to_py(as.numeric(learning_rate)),
          init = r_to_py(init),
          min_dist = r_to_py(as.numeric(min_dist)),
          spread = r_to_py(as.numeric(spread)),
          set_op_mix_ratio = r_to_py(as.numeric(set_op_mix_ratio)),
          local_connectivity = r_to_py(as.integer(local_connectivity)),
          repulsion_strength = r_to_py(as.numeric(repulsion_strength)),
          negative_sample_rate = r_to_py(as.integer(negative_sample_rate)),
          transform_queue_size = r_to_py(as.numeric(transform_queue_size)),
          a = r_to_py(a),
          b = r_to_py(b),
          random_state = r_to_py(random_state),
          metric_kwds = r_to_py(metric_kwds),
          angular_rp_forest = r_to_py(angular_rp_forest),
          target_n_neighbors = as.integer(target_n_neighbors),
          target_metric = r_to_py(target_metric),
          target_metric_kwds = r_to_py(target_metric_kwds),
          target_weight =  r_to_py(target_weight),
          transform_seed = r_to_py(as.integer(transform_seed)),
          verbose = r_to_py(verbose)
        )$fit_transform(r_to_py(as.matrix(data)))
      } else {
        stop(e)
      }
    }
  )
  colnames(umap_vec) <- paste0("UMAP", seq_len(ncol(umap_vec)))
  
  # attach input data to UMAP embeddings if desired
  if (include_input) {
    output <- data.frame(cbind(data, umap_vec))
  } else {
    output <- data.frame(umap_vec)
  }
  
  #make_umap_object(output)
  output
}

is_dict <- function(x) {
  inherits(x, "python.builtin.dict")
}

# global reference to umap (will be initialized in .onLoad)
umap_module <<- NULL

.onLoad <- function(libname, pkgname) {
  # use superassignment to update global reference to umap
  if(py_available()){
    use_condaenv("r-reticulate")
    modules <- py_module_available("umap")
    if(!modules){
      install_python_modules <- function(method = "auto", conda = "auto") {
        py_install("umap-learn", method = method, conda = conda)
      }
      tryCatch(install_python_modules(), 
               error = function(e) {
                 modules <- FALSE
               })
      modules <- py_module_available("umap")
    }
    if (suppressWarnings(suppressMessages(requireNamespace("reticulate")))) {
      
      if (modules) {
        ## assignment in parent environment!
        umap_module <- import("umap", delay_load = TRUE)
      } else {
        install_python_modules()
      }
    }
  }
}

.onAttach <- function(libname, pkgname) {
  if(py_available()){
    use_condaenv("r-reticulate")
    modules <- py_module_available("umap")
    if(!modules){
      install_python_modules <- function(method = "auto", conda = "auto") {
        py_install("umap-learn", method = method, conda = conda)
      }
      tryCatch(install_python_modules(), 
               error = function(e) {
                 modules <- FALSE
               },
               finally = "umap-learn installed")
      modules <- py_module_available("umap")
    }
  } else{
    packageStartupMessage("Warning message:
Python not installed
Please install anaconda or miniconda
https://conda.io/projects/conda/en/latest/user-guide/install/index.html")
  }
  if(py_available() && py_module_available("umap")){
  umap_module <- import("umap")
  packageStartupMessage("umap-learn python module loaded successfully")
  } else {
    packageStartupMessage("Warning message:
umap-learn module is not installed
Please run one of the following:
conda install -n r-reticulate -c conda-forge umap-learn
conda activate r-reticulate; pip install umap-learn")
  }
}
