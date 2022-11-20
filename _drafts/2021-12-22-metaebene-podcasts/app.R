
get_duration <- function(src){
  library(shinyjs)
  library(shiny)
  
  get_duration <- 'shinyjs.aud_duration = function(params) {
  var duration = myaudio.duration;
  Shiny.onInputChange("aud_duration", duration);
}' 
  
  ui <- fluidPage(
    useShinyjs(), 
    extendShinyjs(text = get_duration, functions = "aud_duration"),
    tags$audio(id = "myaudio", 
               src = src),
  )
  
  server <- function(input, output) {
    js$aud_duration()
    durations <- reactiveValues(duration = NA)
    
    observe({
      invalidateLater(1000)
     
      if(!is.null(isolate(input$aud_duration))){
        stopApp(input$aud_duration)
      }
    })
  }
  
  shiny::runGadget(ui, server)
}

get_duration("https://download.samplelib.com/mp3/sample-3s.mp3")
get_duration("https://forschergeist.de/podlove/file/2340/s/feed/c/mp3/fg089-geometrie-und-visualisierung.mp3")

library(tidyverse)

enclosures <- read_csv("enclosures.csv")


pmap(enclosures[1:2, ], function(url, length, type, podcast){
  dur <- get_duration(url)
  df <- tibble(url = url, podcast = podcast, duration = dur)
  write_csv(df, "encosures_duration.csv", append = TRUE)
})


