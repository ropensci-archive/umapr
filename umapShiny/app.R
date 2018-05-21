#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#umap <- get(umap, envir = .GlobalEnv)

#umap <- read.delim("../tests/umap_output.txt")
#markers <- colnames(umap)[!colnames(umap) %in% c("UMAP1","UMAP2")]

markers <- umap$markers
print(markers)

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

      umap$plot(input$marker)
     #ggplot(umap, aes_string(x = "UMAP1", y = "UMAP2", color=input$marker)) +
      #  geom_point()
   })
}

# Run the application
shinyApp(ui = ui, server = server)

