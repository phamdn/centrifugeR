library(shiny)
library(shinythemes)
library(centrifugeR)


ui <- fluidPage(
    theme = shinytheme("cosmo"),

    titlePanel("centrifugeR: Non-trivial Balance of Centrifuge Rotors"),

    sidebarLayout(
        sidebarPanel(
            numericInput(
                "n",
                "Enter the number of rotor holes (n):",
                value = 30,
                min = 4,
                max = 48,
                step = 1
            ),

            textOutput("invalid_k"),
            hr(),
            uiOutput("select_k"),
            p("Theoretical ways of decomposition:"),
            tableOutput("decompose"),
            hr(),
            uiOutput("select_way"),
            hr(),
            h4("Reference"),
            p(
                "Pham, Duy Nghia. 2020. “centrifugeR: Non-Trivial Balance of Centrifuge Rotors.” engrXiv. January 28.",
                a("doi:10.31224/osf.io/4xs38.", href = "https://doi.org/10.31224/osf.io/4xs38")
            )
        ),

        mainPanel(
            h4("Configuration of tubes", align = "center"),
            plotOutput("fig"),
            hr(),
            h4("Holes to be filled", align = "center"),
            column(12, align = "center", tableOutput("hole")),
            hr()
        )
    )
)

server <- function(input, output, session) {
    ip1 <- reactive({
        rotor(input$n)$check
    })

    output$invalid_k <- renderText({
        paste(
            "The numbers of tubes that cannot be loaded:",
            paste(ip1()$invalid, collapse = ", ")

        )
    })

    output$select_k <- renderUI({
        selectInput("k",
                    "Select the number of tubes (k):",
                    ip1()$valid,

                    selected = 7)
    })

    ip2 <- reactive({
        rotor(input$n, input$k, elapse = 15)$load
    })

    output$decompose <- renderTable({
        ip2()$decompose

    }, rownames = T, striped = T)

    output$select_way <- renderUI({
        selectInput("w",
                    "Select the valid way of decomposition:",
                    row.names(na.omit(ip2()$hole)))

    })

    ip3 <- reactive({
        rotor(input$n, input$k, elapse = 15)$load$visual
    })



    output$fig <- renderPlot({
        ip3()[input$w]
    })

    output$hole <- renderTable({
        ip2()$hole[input$w,]

    }, rownames = F)



}


shinyApp(ui = ui, server = server)
