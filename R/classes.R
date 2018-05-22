library(R6)
library(ggplot2)

umap_obj <- R6Class("umap_obj",
                    public = list(
                      markers=NULL,
                      umap_table=NULL,

                      plot = function(marker){
                        markers <- self$markers
                        if(!marker %in% markers){stop("marker not in list of markers")}
                        ggplot2::ggplot(self$umap_table, ggplot2::aes_string(x = "UMAP1", y = "UMAP2", color=marker)) +
                          ggplot2::geom_point()
                      },

                      initialize = function(umap_table, annotation=NULL){
                        
                        self$umap_table <- umap_table
                        if(!is.null(annotation)){
                            self$annotation = annotation
                        }
                        markers <- colnames(umap_table)[!colnames(umap_table) %in% c("UMAP1","UMAP2")]
                        
                        self$markers <- markers
                        invisible(self)
                      },
                      
                      explore = function(markers=NULL){
                        runUmapShiny(self)
                      },
                      
                      set_markers = function(markers=NULL){
                        self$markers 
                        
                      },
                      
                      returnData = function(){
                        return(self$umap_table)
                      }

                    ))

#' Title
#'
#' @param umap_result - output of running
#' @param annotation - optional annotation file
#'
#' @return - a umap object that includes plotting
#' @export
#'
#' @examples
#'
#' library(flowCore)
#'
#' umap_table <- umap()
make_umap_object <- function(umap_result, annotation=NULL){
  umapobj <-umap_obj$new(umap_table=umap_result, annotation=annotation)
  return(umapobj)
}
