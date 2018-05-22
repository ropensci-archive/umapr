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

  #umap <- umap_obj$umap_table
  markers <- umap_obj$markers
  #if(is.null(markers)){  markers <- umap_obj$markers}

  library(shiny)

  # Define UI for application that draws a histogram
  ui <- fluidPage(

    # Application title
    titlePanel("UMAP Explorer"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        selectInput("marker", label = "Select Variable to Color By", choices = markers, selected = markers[1])
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
     # out_plot <- ggplot2::ggplot(umap, aes_string(x = "UMAP1", y = "UMAP2", color=input$marker)) +
      #  geom_point()
      
      umap_obj$plot(input$marker)

      #out_plot
    })
  }

  # Run the application
  shinyApp(ui = ui, server = server)


}


#' Title
#'
#' @param umap
#' @param markers
#'
#' @return
#' @export
#'
#' @examples
run_umap_shiny <- function(umap){
  
  #umapobj <- deparse(substitute(umap_obj))
  
  #umap <- umap_obj$umap_table
  #markers <- umap_obj
  markers <- colnames(umap)[!colnames(umap) %in% c("UMAP1", "UMAP2")]
  
  #if(is.null(markers)){  markers <- umap_obj$markers}
  
  library(shiny)
  
  # Define UI for application that draws a histogram
  ui <- fluidPage(
    
    # Application title
    titlePanel("UMAP Explorer"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        selectInput("marker", label = "Select Variable to Color By", choices = markers, selected = markers[1])
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
       out_plot <- ggplot2::ggplot(umap, aes_string(x = "UMAP1", y = "UMAP2", color=input$marker)) +
        geom_point()
      
      #umap_obj$plot(input$marker)
      
      out_plot
    })
  }
  
  # Run the application
  shinyApp(ui = ui, server = server)
  
  
}

