# global reference to umap (will be initialized in .onLoad)
umap_module <- NULL

.onLoad <- function(libname, pkgname) {
  # use superassignment to update global reference to umap
  umap_module <<- reticulate::import("umap")
}
