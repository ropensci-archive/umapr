runUmapShiny <- function(umap, markers=NULL){

  umap <- deparse(substitute(umap))

  shiny::runApp("umapShiny")

}
