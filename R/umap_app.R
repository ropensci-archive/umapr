runUmapShiny <- function(umap, markers=NULL){

  umap <- deparse(substitute(umap))

  runApp("umapShiny")

}
