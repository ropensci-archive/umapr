library(data.table)
library(R6)

umap_obj <- R6Class("umap_obj",
                    public = list(
                      markers=NULL,
                      umap_table=NULL,

                      plot = function(marker){
                        markers <- self$markers
                        if(!marker %in% markers){stop("marker not in list of markers")}
                        umap_table <- self$umap_table
                        ggplot(umap_table, aes_string(x = "UMAP1", y = "UMAP2", color=marker)) +
                          geom_point()
                      },

                      initialize = function(umap_table, annotation=NULL){
                        self$umap_table <- umap_table
                        if(!is.null(annotation)){
                            self$annotation = annotation
                        }
                        markers <- colnames(umap_table)[!colnames(umap) %in% c("UMAP1","UMAP2")]
                        self$markers <- markers

                        invisible(self)
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
