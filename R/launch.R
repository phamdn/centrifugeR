#' Run the Shiny App
#'
#' @export
launch <- function() {
    runApp(system.file("shiny", package = "centrifugeR"))
}
