#' centrifugeR: Non-Trivial Balance of Centrifuge Rotors
#'
#' Find the numbers of test tubes that can be balanced in centrifuge rotors and
#' show various ways to load them. Refer to Pham (2020)
#' \doi{10.31224/osf.io/4xs38} for more information on package
#' functionality.
#'
#' @author Duy Nghia Pham \email{nghiapham@@yandex.com}
#'
#' @docType package
#'
#' @name centrifugeR-package
#'
#' @section Guidelines: centrifugeR helps obtain the perfect centrifuge balance.
#'   Call \code{\link{rotor}} to know how many tubes can be loaded into the
#'   rotor and see different ways to place these tubes. Alternatively, call
#'   \code{\link{launch}} to run the Shiny app. Also, call
#'   \code{\link{rotorVerify}} to verify the balance of pre-existing tube
#'   configurations. Call \code{\link{rotorSpeed}} for RPM/RCF conversion.
#'
#' @section Copyright: centrifugeR: Non-Trivial Balance of Centrifuge Rotors.
#'   Copyright (C) 2020-2022 Duy Nghia Pham \cr \cr centrifugeR is free
#'   software: you can redistribute it and/or modify it under the terms of the
#'   GNU General Public License as published by the Free Software Foundation,
#'   either version 3 of the License, or (at your option) any later version. \cr
#'   \cr centrifugeR is distributed in the hope that it will be useful, but
#'   WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
#'   or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#'   for more details. \cr \cr You should have received a copy of the GNU
#'   General Public License along with centrifugeR.  If not, see
#'   \url{https://www.gnu.org/licenses/}.
#'
#' @importFrom grDevices palette rainbow recordPlot as.graphicsAnnot dev.flush
#'   dev.hold
#' @importFrom graphics pie par lines plot.new plot.window polygon text title
#'   mtext
#' @importFrom utils capture.output
#' @importFrom pracma factors dot
#' @import shiny shinythemes
NULL
