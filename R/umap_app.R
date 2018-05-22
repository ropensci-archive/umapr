#' Open a shiny app to explore the data in a UMAP embedding.
#'
#' @param umap output of a call to `umap`
#'
#' @return Open an interactive shiny app to explore the data.
#' @export
run_umap_shiny <- function(umap){

  #umapobj <- deparse(substitute(umap_obj))

  #umap <- umap_obj$umap_table
  #markers <- umap_obj
  markers <- colnames(umap)[!colnames(umap) %in% c("UMAP1", "UMAP2")]

  #if(is.null(markers)){  markers <- umap_obj$markers}

  # Define UI for application that draws a histogram
  ui <- shiny::fluidPage(

    # Application title
    shiny::titlePanel("UMAP Explorer"),

    # Sidebar with a slider input for number of bins
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::selectInput("marker", label = "Select Variable to Color By", choices = markers, selected = markers[1])
      ),

      # Show a plot of the generated distribution
      shiny::mainPanel(
        shiny::plotOutput("umapPlot")
      )
    )
  )

  # Define server logic required to draw a histogram
  server <- function(input, output) {

    output$umapPlot <- shiny::renderPlot({

      #umap$plot(input$marker)
       out_plot <- ggplot2::ggplot(umap, ggplot2::aes_string(x = "UMAP1", y = "UMAP2", color=input$marker)) +
        ggplot2::geom_point()

      #umap_obj$plot(input$marker)

      out_plot
    })
  }

  # Run the application
  shiny::shinyApp(ui = ui, server = server)


}

