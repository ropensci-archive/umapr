#' umap
#'
#' @param data input data matrix
#' @param ... arguments to umap object
#'
#' @return matrix
#' @export
#'
#' @examples
#' umap(as.matrix(iris[, 1:4]))
umap <- function(data, ...) {
  if (!is.matrix(data)) stop("`data` should be a matrix.")
  if (!all(unlist(lapply(data, is.numeric)))) stop("All columns should be numeric.")

  umap_module$UMAP(...)$fit_transform(data)
}
