theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "steelblue",
  base_font = font_google("Poppins"),
  heading_font = font_google("Poppins", w = 600),
  
  
  "nav-link-color" = "steelblue",
  "nav-pills-link-active-bg" = "steelblue",
  "nav-pills-link-active-color" = "#ffffff",
)


ui <- fluidPage(
  theme = theme,
  
  tags$head(
    tags$style(HTML("
      .nav-pills .nav-link:not(.active):hover {
        color: steelblue !important;                    
        background-color: rgba(70,130,180,0.15); 
        border: 1px solid steelblue !important; 
      } 
      .nav-pills .nav-link:not(.active):hover { border: none !important; }"))),
  
  titlePanel(h1("King County House Prices", class = "h4 display-4 text-center mb-4")),
  
  tags$hr(
    style = "
    width: 80%;
    margin-left: auto;          
    margin-right: auto;
    border: 0;                   
    border-top: 3px solid #4682B4; 
    opacity: 1;                  
    margin-top: 4px;
    margin-bottom: 16px;"
  ),
  
  div(class = "container",  
      tabsetPanel(
        id   = "mainTabs",
        type = "pills",
        tabPanel(
          title  = tagList(icon("map"),   "Map"),
          value  = "mapTab",
          leafletOutput("zipmap", height = "80vh")
        ),
        tabPanel(
          title  = tagList(icon("chart-bar"), "Graphs"),
          value  = "graphsTab",
          fluidRow(
            column(width = 6, plotOutput("histPrice", height = 450)),
            column(width = 6, plotOutput("yearLine",  height = 450))),
          fluidRow(
            column(12, plotOutput("heatViewCond", height = 450)))
          
        )
      )
  )
)