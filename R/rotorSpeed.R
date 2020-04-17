#' Calculate RPM/RCF
#'
#' \code{rotorSpeed} converts rotational speed to relative centrifuge force and vice versa.
#'
#' @param radius a numeric, the centrifugal radius in millimeters.
#' @param value a numeric, the rotational speed in revolutions per minute or the
#'   relative centrifuge force in × g.
#' @param type the type of the above-mentioned \code{value}, "rpm" for
#'   rotational speed or "rcf" for relative centrifuge force.
#'
#' @return \code{rotorSpeed} returns a numeric that is the rotational speed in
#'   revolutions per minute or the relative centrifuge force in × g.
#'
#' @references Rickwood D, editor. Centrifugation: a practical approach. London:
#'   Information Retrieval Ltd; 1978. 224 p.
#'
#' @examples
#' rotorSpeed(100, 12000, "rpm")
#' rotorSpeed(100, 6000, "rcf")
#'
#' @export
rotorSpeed <- function (radius, value, type) {
    message(paste("Centrifugal radius is", radius, "mm."))
    if (!type %in% c("rpm", "rcf")) stop('Only "rpm" and "rcf" are valid.')
    if (type == "rpm") {
        message(paste("Rotational speed is", value, "rpm."))
        message(paste("Relative centrifuge force is"))
        return(rcf = 1.118 * radius * (value / 1000) ^ 2)
    }
    if (type == "rcf") {
        message(paste("Relative centrifuge force is", value, "\u00d7", "g."))
        message(paste("Rotational speed is"))
        return(rpm = 1000 * sqrt(value / (1.118 * radius)))
    }
}
