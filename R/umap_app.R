#' Title
#'
#' @param umap
#' @param markers
#'
#' @return
#' @export
#'
#' @examples
runUmapShiny <- function(umap_obj){

  #umapobj <- deparse(substitute(umap_obj))

  umap <- umap_obj$umap_table
  markers <- umap_obj$markers

  #markers <- colnames(umap)[!colnames(umap) %in% c("UMAP1","UMAP2")]

  #markers <- umap$markers
  #print(markers)

  #head(umap)

  library(shiny)

  # Define UI for application that draws a histogram
  ui <- fluidPage(

    # Application title
    titlePanel("UMAP Explorer"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        selectInput("marker", label = "Select Marker to Color By", choices = markers, selected = markers[1])
      ),

      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("umapPlot")
      )
    )
  )

  # Define server logic required to draw a histogram
  server <- function(input, output) {

    output$umapPlot <- renderPlot({

      #umap$plot(input$marker)
      out_plot <- ggplot(umap, aes_string(x = "UMAP1", y = "UMAP2", color=input$marker)) +
        geom_point()

      out_plot
    })
  }

  # Run the application
  shinyApp(ui = ui, server = server)


}
