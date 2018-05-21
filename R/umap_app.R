#' Title
#'
#' @param umap
#' @param markers
#'
#' @return
#' @export
#'
#' @examples
runUmapShiny <- function(umap_obj, markers=NULL){

  umapobj <- deparse(substitute(umap_obj))

  #umap <- umapobj$umap_table
  #markers <- umapobj$parameters

  shiny::runApp("umapShiny")

}
