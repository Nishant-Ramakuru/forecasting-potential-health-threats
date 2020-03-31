library(shinydashboard)

myside<-list(
      sidebarMenu(
        menuItem("Results", tabName = "kstab", icon = icon("line-chart"))
        
  
    ))
mybody<-list(
      tabItems(
        tabItem(
          tabName = "kstab",
          fluidRow(
            box(width = 4,solidHeader = T,status ="primary",
               # fluidRow(tableOutput("csvdata"))
               htmlOutput("theimage")
                
                ),
            column(width=8,
                fluidRow(valueBoxOutput("rate",width = 6),valueBoxOutput("rate1",width = 6)),
                fluidRow(valueBoxOutput("rate3",width = 6),valueBoxOutput("rate2",width = 6)),  
                box(width=12,plotOutput("plot1",height="330px",width="100%"))
            
          )
          )
        )
      
      )
    )
         