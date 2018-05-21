library(reticulate)
library(tidyverse)

umap <- import("umap")
sklearn.datasets_module <- import("sklearn.datasets")

digits <- sklearn.datasets_module$load_digits()

umap_out <- umap$UMAP()$fit_transform(digits$data)
colnames(umap_out) <- c("UMAP1","UMAP2")
umap <- cbind(digits$data, umap_out) %>% data.frame()

#runUmapShiny(umap)

umapout <- make_umap_object(umap_result = umap)

#umapout$plot("V4")

runUmapShiny(umap)
