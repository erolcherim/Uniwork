#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#www.rstudio.com/products/shiny/shiny-server/
#este host gratis

library(shiny)

# 

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  fluidRow(
    column(3),
    column(6, tags$br(),tags$h1("Probabilitatea aparitiei unui cancer esofagian, in functie de consumul de alcool si tutun"), tags$h3("Cherim Erol, Martinas Paul, Roman Robert"))
  ),
  fluidRow(
    column(2),
    column(8,tags$h2("")
    )),
  fluidRow(
  column(2),
  column(8,
  tabsetPanel( #tags$p("Parametri"),tags$br(),
    tabPanel(tags$div(tags$img(src='paramv.png', width="40px", align = "center")),
      fluidRow(
        column(4, offset = 4, 
               #actionButton(inputId = "clicks", label = "click me"),
               #actionButton(inputId = "up", label = "update"),
               ##textInput(inputId = "titlu",
               #          label = "alege titlul histogramei",
                #         placeholder = "titlul tau"),
               tags$br(),tags$br(),
               tags$h2("Risk-Calculator"),
               sliderInput(inputId = "varsta", 
                           label = "Introduceti varsta",
                           value = 40, min = 25, max= 100),
               selectInput(
                 inputId = "alcool",
                 label= "Cantitate de alcool consumata pe zi",
                 choices = c("0-39g/day" = "0-39g/day","40-79" = "40-79","80-119" = "80-119","120+" = "120+"),
                 selected = "0-39g/day",
                 multiple = FALSE,
                 selectize = TRUE,
                 width = NULL,
                 size = NULL
               ),
               selectInput(
                 inputId = "tutun",
                 label= "Cantitate de tutun consumata pe zi",
                 choices = c("0-9g/day" = "0-9g/day","10-19" = "10-19","20-29" = "20-29","30+" = "30+"),
                 selected = "0-9g/day",
                 multiple = FALSE,
                 selectize = TRUE,
                 width = 800,
                 size = NULL
               )
               ),
        column(4)
      )  
  ),
  tabPanel(tags$div(tags$img(src='heartv.png', width="40px", align = "center")),
  # Application title
  #textOutput("varsta"),
  #textOutput("alcool"),
  #textOutput("tutun")
  tags$h2("Probabillitatea da a fi afectat de un cancer esofagian in functie de datele dvs este ", tags$h1(textOutput("raport"))),
    ),
  tabPanel(tags$div(tags$img(src='tigarav.png', width="40px", align = "center")),
             
             mainPanel(
               plotOutput("tabacoPlot",
                          height = "700px",
                          width = "1000px")
             )
           ),
  tabPanel(tags$div(tags$img(src='mug.png', width="40px", align = "center")),
           
           mainPanel(
             plotOutput("alcoholPlot",
                        height = "700px",
                        width = "1000px")
           )
  )
  )
  )
  )
  )
probabilitate <- function (age, alc, tob)
{
  if(age<25)
  {
    stop("Varsta minima este 25")
  }
  if(age>=25&&age<=34)
  {
    vage <- subset(esoph, subset = agegp == "25-34")
  }
  if(age>=35&&age<=44)
  {
    vage <- subset(esoph, subset = agegp == "35-44")
  }
  if(age>=45&&age<=54)
  {
    vage <- subset(esoph, subset = agegp == "45-54")
  }
  if(age>=55&&age<=64)
  {
    vage <- subset(esoph, subset = agegp == "55-64")
  }
  if(age>=65&&age<=74)
  {
    vage <- subset(esoph, subset = agegp == "65-74")
  }
  if(age>=75)
  {
    vage <- subset(esoph, subset = agegp == "75+")
  }
  
  
  if(alc<=0)
  {
    stop("Cantatitea de alcool nu poate fi negativa")
  }
  if(alc>0&&alc<=39)
  {
    valc <- subset(vage, subset = alcgp == "0-39g/day")
  }
  if(alc>=40&&alc<=79)
  {
    valc <- subset(vage, subset = alcgp == "40-79")
  }
  if(alc>=80&&alc<=119)
  {
    valc <- subset(vage, subset = alcgp == "80-119")
  }
  if(alc>=120)
  {
    valc <- subset(vage, subset = alcgp == "120+")
  }
  
  if(tob<=0)
  {
    stop("Cantatitea de tutun nu poate fi negativa")
  }
  if(tob>0&&tob<=9)
  {
    vtob <- subset(valc, subset = tobgp == "0-9g/day")
  }
  if(tob>=10&&tob<=19)
  {
    vtob <- subset(valc, subset = tobgp == "10-19")
  }
  if(tob>=20&&tob<=29)
  {
    vtob <- subset(valc, subset = tobgp == "20-29")
  }
  if(tob>=30)
  {
    vtob <- subset(valc, subset = tobgp == "30+")
  }
  if(length(vtob$ncases)>0)
  {
    controlsage <- sum(vage$ncontrols)
    result <- vtob$ncases*100/controlsage
    return(result)
  }
  else
  {
    warning("Nu exista memorata combinatia de valori")
  }
} 

# Define server logic required to draw a histogram
server <- function(input, output) {
    #user input graphic
    
    output$raport <- renderText({probabilitate(input$varsta,input$alcool, input$tutun)})
    #output$varsta <- renderText({input$varsta}) 
    #output$alcool <- renderText({input$alcool})
    #output$tutun <- renderText({input$tutun})
    observeEvent(input$clicks, {print(as.numeric(input$clicks))}) #afisaza in consola nr de clickuri
  
    output$hist <- renderPlot({
      hist(rnorm(input$varsta), col = c("darkslategray3","darkslategray2"), xlab="Random Numbers", main=" Random numbers histogram")
      })
    
    output$tabacoPlot <- renderPlot({
      cases_by_age <- aggregate(esoph$ncases, by=list(agegp = esoph$agegp), FUN = sum)
      controls_by_age <- aggregate(esoph$ncontrols, by=list(agegp = esoph$agegp), FUN = sum)
      #total_cases <- sum(esoph$ncases)
      
      
      percentage_of_total <- cases_by_age$x * 100 / controls_by_age$x
      
      vect_col <- c("hotpink", "green", "blue", "red", "yellow", "cyan")
      
      barplot ( height = percentage_of_total,
                names.arg = cases_by_age$agegp,
                xlab = "Categorie de varsta",
                ylab = "Procentaj de cazuri",
                col = vect_col,
                cex.main = 0.7)
      #------------------------------------------------------------------------------------
      tob1 <- subset(esoph, subset = tobgp == "0-9g/day")
      cases_by_age_tobacco1 <- aggregate(cbind(tob1$ncases, tob1$ncontrols), by=list(agegp = tob1$agegp), FUN=sum)
      #cases_by_age_tobacco1
      proctb1 <- cases_by_age_tobacco1$V1*100/cases_by_age_tobacco1$V2
      #proctb1
      
      tob2 <- subset(esoph, subset = tobgp == "10-19")
      cases_by_age_tobacco2 <- aggregate(cbind(tob2$ncases, tob2$ncontrols), by=list(agegp = tob2$agegp), FUN=sum)
      #cases_by_age_tobacco2
      proctb2 <- cases_by_age_tobacco2$V1*100/cases_by_age_tobacco2$V2
      #proctb2
      
      tob3 <- subset(esoph, subset = tobgp == "20-29")
      cases_by_age_tobacco3 <- aggregate(cbind(tob3$ncases, tob3$ncontrols), by=list(agegp = tob3$agegp), FUN=sum)
      #cases_by_age_tobacco3
      proctb3 <- cases_by_age_tobacco3$V1*100/cases_by_age_tobacco3$V2
      #proctb3
      
      tob4 <- subset(esoph, subset = tobgp == "30+")
      cases_by_age_tobacco4 <- aggregate(cbind(tob4$ncases, tob4$ncontrols), by=list(agegp = tob4$agegp), FUN=sum)
      #cases_by_age_tobacco4
      proctb4 <- cases_by_age_tobacco4$V1*100/cases_by_age_tobacco4$V2
      #proctb4
      
      #-------------------------------------------------------------------------------------
      tob_t <- cbind("0-9"=proctb1, "10-19"=proctb2, "20-29"=proctb3, "30+"=proctb4)
      vect_col4 <- c("darkslategray2",
                     "darkslategray3",
                     "darkslategray4",
                     "darkslategrey")
      par(bg="transparent")
      barplot(t(tob_t),
              names.arg = cases_by_age$agegp,
              xlab = "Categorie varsta",
              main = "Distributia procentajelor cazurilor de 
        cancer pentru fiecare categorie de consum de tutun",
              col.main = "white",
              ylab = "Procentaj cazuri",
              col = vect_col4,
              col.axis = "white",
              col.lab = "white",
              beside=TRUE
      )
      legend("topleft", legend=c("0-9g/day","10-19g/day","20-29g/day","30+g/day"), fill=vect_col4, bg = "white")
    })
    
    #--------------------alcohol------------
    output$alcoholPlot <- renderPlot({
      cases_by_age <- aggregate(esoph$ncases, by=list(agegp = esoph$agegp), FUN = sum)
      controls_by_age <- aggregate(esoph$ncontrols, by=list(agegp = esoph$agegp), FUN = sum)
      #total_cases <- sum(esoph$ncases)
      
      
      percentage_of_total <- cases_by_age$x * 100 / controls_by_age$x
      
      vect_col <- c("hotpink", "green", "blue", "red", "yellow", "cyan")
      barplot ( height = percentage_of_total,
                names.arg = cases_by_age$agegp,
                xlab = "Categorie de varsta",
                ylab = "Procentaj de cazuri",
                col = vect_col,
                cex.main = 0.7)
      #------------------------------------------------------------------------------------
      alc1 <- subset(esoph, subset = alcgp == "0-39g/day")
      cases_by_age_alcohol1 <- aggregate(cbind(alc1$ncases, alc1$ncontrols), by=list(agegp = alc1$agegp), FUN=sum)
      cases_by_age_alcohol1
      procalc1 <- cases_by_age_alcohol1$V1*100/cases_by_age_alcohol1$V2
      procalc1
      
      alc2 <- subset(esoph, subset = alcgp == "40-79")
      cases_by_age_alcohol2 <- aggregate(cbind(alc2$ncases, alc2$ncontrols), by=list(agegp = alc2$agegp), FUN=sum)
      cases_by_age_alcohol2
      procalc2 <- cases_by_age_alcohol2$V1*100/cases_by_age_alcohol2$V2
      procalc2
      
      alc3 <- subset(esoph, subset = alcgp == "80-119")
      cases_by_age_alcohol3 <- aggregate(cbind(alc3$ncases, alc3$ncontrols), by=list(agegp = alc3$agegp), FUN=sum)
      cases_by_age_alcohol3
      procalc3 <- cases_by_age_alcohol3$V1*100/cases_by_age_alcohol3$V2
      procalc3
      
      alc4 <- subset(esoph, subset = alcgp == "120+")
      cases_by_age_alcohol4 <- aggregate(cbind(alc4$ncases, alc4$ncontrols), by=list(agegp = alc4$agegp), FUN=sum)
      cases_by_age_alcohol4
      procalc4 <- cases_by_age_alcohol4$V1*100/cases_by_age_alcohol4$V2
      procalc4
      
      #-------------------------------------------------------------------------------------
      alc_t <- cbind("0-39"=procalc1, "40-79"=procalc2, "80-119"=procalc3, "120+"=procalc4)
      vect_col4 <- c("darkslategray2",
                     "darkslategray3",
                     "darkslategray4",
                     "darkslategrey")
      par(bg="transparent")
      barplot(t(alc_t),
              names.arg = cases_by_age$agegp,
              xlab = "Categorie varsta",
              ylab = "Procentaj cazuri",
              main = "Distributia procentajelor cazurilor de 
        cancer pentru fiecare categorie de consum de alcool",
              col = vect_col4,
              col.main = "white",
              col.axis = "white",
              col.lab = "white",
              beside=TRUE
      )
      legend("topleft", legend=c("0-39g/day","40-79g/day","80-119g/day", "120+g/day"), fill=vect_col4, bg="white")
    })
    
    
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
