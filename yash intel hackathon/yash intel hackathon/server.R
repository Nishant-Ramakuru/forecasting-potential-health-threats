library(shiny)
library(shinydashboard)
source("user.R")
library(shinyjs)

my_username <- c("test","admin")
my_password <- c("test","123")



shinyServer(function(input, output,session) {
  
  observe({print(paste("Connected ",session$clientData$url_hostname,":",session$clientData$url_port,sep=''))})
  USER <- reactiveValues(Logged = F,changethis=F,ggtemp=1)
 ui1 <- function(){
    tagList(
      div(id = "login",
          wellPanel(
            tags$a(img(src = 'logo.png',height = "290px",style = "display: block;width:100%;margin-left: auto;margin-right: auto;")),
              textInput(label="",placeholder =  "Patient ID","userName"),
              passwordInput("passwd",label=NULL,placeholder =  "Password"),
              actionButton("Login", "Log in",style="color:#FFFFFF;background:#3c2501;width:100%;")))
              ,tags$style(type="text/css", "#login { 
                                    display: block;margin-left: auto;margin-right: auto;
                                    width: 25%;
                                    box-shadow: 10px 10px 5px #888888;            
                                    margin-top:5%
                                    border: 1px solid #808080;}")
    )}
  
  observe({ 
    if (USER$Logged == FALSE) {
      if (!is.null(input$Login)) {
        if (input$Login > 0) {
          Username <- isolate(input$userName)
          Password <- isolate(input$passwd)
          Id.username <- which(my_username == Username)
          Id.password <- which(my_password == Password)
          if (length(Id.username) > 0 & length(Id.password) > 0) {
            if (Id.username == Id.password) {
              USER$Logged <- TRUE
              print(paste("Connection ",session$clientData$url_hostname,"...Logged in as ",Username,sep=''))
              
              
            }
            else
            {
              observe({session$sendCustomMessage(type = 'msg',message=list(text='Incorrect Credentials...'))})
            }
          }
          else
          {
            observe({session$sendCustomMessage(type = 'msg',message=list(text='Incorrect Credentials...'))})
          }
        }
      }
    }
  })
  observe({
    if (USER$Logged == FALSE) {
      output$page <- renderUI({
        do.call(bootstrapPage,c("",ui1()))
      })
     
    }
    if (USER$Logged == TRUE)    {
      output$page <- renderUI({mybody})
      shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
      shinyjs::show(selector = "body > div > header")
      output$side <- renderUI({myside})
     
    observe({
      #output$csvdata<-renderTable(read.csv("data.csv"))
 output$theimage<-renderUI({img(src = 'body.jpg',height = "580px",style = "display: block;width:100%;margin-left: auto;margin-right: auto;")
 
    })
 
   
 observeEvent(USER$ggtemp,{
      observe({
        
        temp<-read.csv("data.csv")
          output$plot1<-renderPlot({
          gg<-tail(temp,20)
          par(bg="black",fg="white",col.axis="white")
          matplot(gg$ECG,type="l",col="green",lwd=3)})
       })
      
      
      output$rate <- renderValueBox({
        temp<-read.csv("data.csv")
        if(0>(head(tail(temp,2),1)$humidity-tail(temp,1)$humidity)){
        valueBox(
          paste(tail(temp,1)$humidity), "Skin Moisture", icon = icon("arrow-down", lib = "glyphicon"),
          color = "aqua"
        )}
        else{
          valueBox(
            paste(tail(temp,1)$humidity), "Skin Moisture", icon = icon("arrow-up", lib = "glyphicon"),
            color = "aqua"
          )}
      })
       
       output$rate1 <- renderValueBox({
         temp<-read.csv("data.csv")
         if(0>(head(tail(temp,2),1)$temp-tail(temp,1)$temp)){
           valueBox(
             paste(tail(temp,1)$temp), "Body Temprature", icon = icon("arrow-down", lib = "glyphicon"),
             color = "maroon"
           )}
         else{
           valueBox(
             paste(tail(temp,1)$temp), "Body Temprature", icon = icon("arrow-up", lib = "glyphicon"),
             color = "maroon"
           )}
       })
       
       output$rate2 <- renderValueBox({
         temp<-read.csv("data.csv")
         if(0>(head(tail(temp,2),1)$spo2-tail(temp,1)$spo2)){
           valueBox(
             paste(tail(temp,1)$spo2), "SPO2%", icon = icon("arrow-down", lib = "glyphicon"),
             color = "olive"
           )}
         else{
           valueBox(
             paste(tail(temp,1)$spo2), "SPO2%", icon = icon("arrow-up", lib = "glyphicon"),
             color = "olive"
           )}
       })
       
       output$rate3 <- renderValueBox({
         temp<-read.csv("data.csv")
         if(0>(head(tail(temp,2),1)$pulserate-tail(temp,1)$pulserate)){
           valueBox(
             paste(tail(temp,1)$pulserate), "Pulse Rate", icon = icon("arrow-down", lib = "glyphicon"),
             color = "yellow"
           )}
         else{
           valueBox(
             paste(tail(temp,1)$pulserate), "Pulse Rate", icon = icon("arrow-up", lib = "glyphicon"),
             color = "yellow"
           )}
       })
       
       observe({
         temp1<-read.csv("data.csv")
         gg1<-read.csv("1.csv",col.names = c("name"))
         a1<-mean(gg1$name)
         gg2<-read.csv("2.csv",col.names = c("name"))
         a2<-mean(gg2$name)
         gg3<-read.csv("3.csv",col.names = c("name"))
         a3<-mean(gg3$name)
         gg4<-read.csv("4.csv",col.names = c("name"))
         a4<-mean(gg4$name)
         gg5<-read.csv("5.csv",col.names = c("name"))
         a5<-mean(gg5$name)
        # temp1<-rbind(temp1,c(a1,a2,a3,a4,a5))
         temp1<-rbind(temp1,rnorm(5))
         write.csv(temp1,file = "data.csv",row.names = F)
       })
       delay(1000,USER$ggtemp<-USER$ggtemp+1)
    })
    })
    }
  })
})