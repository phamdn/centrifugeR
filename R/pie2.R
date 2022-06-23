#' Draw a Rotor
#'
#' \code{pie2} was modified after \code{\link{pie}}. This is not meant to be
#' called directly.
#'
#' @param x See \code{\link{pie}} for more details.
#' @param labels See \code{\link{pie}} for more details.
#' @param edges See \code{\link{pie}} for more details.
#' @param radius See \code{\link{pie}} for more details.
#' @param clockwise See \code{\link{pie}} for more details.
#' @param init.angle See \code{\link{pie}} for more details.
#' @param density See \code{\link{pie}} for more details.
#' @param angle See \code{\link{pie}} for more details.
#' @param col See \code{\link{pie}} for more details.
#' @param border See \code{\link{pie}} for more details.
#' @param lty See \code{\link{pie}} for more details.
#' @param main See \code{\link{pie}} for more details.
#' @param panel a letter for labeling panel.
#' @param ... See \code{\link{pie}} for more details.
#'
#' @return \code{pie2} returns a figure.
#'
#'
#' @export
pie2 <- function (x, labels = names(x), edges = 200, radius = 0.8, clockwise = FALSE,
          init.angle = if (clockwise) 90 else 0, density = NULL, angle = 45,
          col = NULL, border = NULL, lty = NULL, main = NULL, panel = NULL, ...)
{
    if (!is.numeric(x) || any(is.na(x) | x < 0))
        stop("'x' values must be positive.")
    if (is.null(labels))
        labels <- as.character(seq_along(x))
    else labels <- as.graphicsAnnot(labels)
    x <- c(0, cumsum(x)/sum(x))
    dx <- diff(x)
    nx <- length(dx)
    plot.new()
    pin <- par("pin")
    xlim <- ylim <- c(-1, 1)
    if (pin[1L] > pin[2L])
        xlim <- (pin[1L]/pin[2L]) * xlim
    else ylim <- (pin[2L]/pin[1L]) * ylim
    dev.hold()
    on.exit(dev.flush())
    plot.window(xlim, ylim, "", asp = 1)
    if (is.null(col))
        col <- if (is.null(density))
            c("white", "lightblue", "mistyrose", "lightcyan",
              "lavender", "cornsilk")
    else par("fg")
    if (!is.null(col))
        col <- rep_len(col, nx)
    if (!is.null(border))
        border <- rep_len(border, nx)
    if (!is.null(lty))
        lty <- rep_len(lty, nx)
    angle <- rep(angle, nx)
    if (!is.null(density))
        density <- rep_len(density, nx)
    twopi <- if (clockwise)
        -2 * pi
    else 2 * pi
    t2xy <- function(t) {
        t2p <- twopi * t + init.angle * pi/180
        list(x = radius * cos(t2p), y = radius * sin(t2p))
    }
    for (i in 1L:nx) {
        n <- max(2, floor(edges * dx[i]))
        P <- t2xy(seq.int(x[i], x[i + 1], length.out = n))
        polygon(c(P$x, 0), c(P$y, 0), density = density[i], angle = angle[i],
                border = border[i], col = col[i], lty = lty[i])
        P <- t2xy(mean(x[i + 0:1]))
        lab <- as.character(labels[i])
        if (!is.na(lab) && nzchar(lab)) {
            lines(c(1, 1.05) * P$x, c(1, 1.05) * P$y)
            text(1.15 * P$x, 1.15 * P$y, labels[i], xpd = TRUE,
                 adj = 0.5, ...)
        }
    }
    mtext(main, side = 1, adj = 0.5, line = 2, font=2, cex = 1.5)
    mtext(panel, side = 3, adj = 0.1, line = 1, font=2, cex = 1.5)
    invisible(NULL)
}
