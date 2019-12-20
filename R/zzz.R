#' @importFrom dplyr select_ mutate
#' @importFrom ggplot2 aes scale_alpha_manual scale_color_manual scale_fill_manual scale_size_manual scale_shape_manual
#' @importFrom rlang enquo
#' @importFrom magrittr %>%
NULL

#' @export
magrittr::'%>%'

#' @importFrom ggplot2 ggplot_add
#' @export
ggplot_add

#' @export
#' @rdname scale_focus
#' @usage NULL
scale_colour_focus <- scale_color_focus

globalVariables(c(".marker_color",
                  ".marker_fill",
                  ".marker_alpha",
                  ".marker_size",
                  ".marker_shape",
                  ".marker_linetype"))
