#' @name scale_focus
#' @title Focus scales for `ggplot` objects
#'
#' @description Scale that focus on specific levels.
#'
#' @param focus_levels character vector with levels to focus on.
#' @param color_focus color(s) for focused levels (a single value or a vector
#' with the same length as the number of highlighted levels).
#' @param color_other color for other levels.
#' @param palette_focus If `color_focus` is not specified, provide a pelette
#' from RColorBrewer to pick colors.
#'
#' @note Use \code{RColorBrewer::display.brewer.all()} to see the palettes
#' available.
#'
#' @examples
#' ggplot(iris, aes(x = Petal.Length, y = Sepal.Length, color = Species)) +
#'  geom_point() +
#'  scale_color_focus(focus_levels = "setosa", color_focus = "red")
#'
#' ggplot(iris, aes(x = Petal.Length, y = Sepal.Length, color = Species)) +
#'  geom_point() +
#'  scale_color_focus(focus_levels = c("setosa", "virginica"), color_focus = c("red", "blue"))
#'
#' ggplot(mtcars, aes(x = wt, y = mpg, color = rownames(mtcars))) +
#'  geom_point() +
#'  scale_color_focus(focus_levels = c("Mazda RX4", "Merc 230"), palette_focus = "Set2")
#'
#' @export
scale_color_focus <- function(focus_levels, color_focus = NULL,
                              color_other = "gray", palette_focus = "Set1"){
  structure(list(focus_levels = focus_levels,
                 color_focus = color_focus,
                 color_other = color_other,
                 palette_focus = palette_focus),
            class = "ggfocus_color")
}

#' @export
#' @method ggplot_add ggfocus_color
ggplot_add.ggfocus_color <- function(object, plot, ...){

  p1 <- plot
  focus_levels <- object$focus_levels
  color_focus <- object$color_focus
  color_other <- object$color_other
  palette_focus <- object$palette_focus
  var <- p1$mapping$colour

  if(is.null(var)){
    message("'color' isn't mapped in any variable. Use 'aes(color = ...)' before setting the focus scale.")
    return(plot)
  }

  p1$data <- p1$data %>%
    mutate(.marker_color = ifelse(as.character(!!var) %in% focus_levels,
           as.character(!!var), "Other"))

  if(sum(p1$data$.marker_color == "Other") == 0){
    stop("Every observation is focused. Use less values in 'focus_levels'.")
  }

  if(sum(p1$data$.marker_color != "Other") == 0){
    message("There are no observations selected. Are the levels misspelled? Is the correct variable mapped to 'color'?")
  }

  n_levels <- p1$data$.marker_color %>% unique() %>% length()

  if(is.null(color_focus)){
    color_focus <- suppressWarnings(
      RColorBrewer::brewer.pal(n_levels-1, palette_focus)[1:(n_levels-1)])
  }

  if(length(color_focus)!=1 & length(color_focus)!=length(focus_levels)){
    stop("color_focus must be of length 1 or same length as focus_levels.")
  }
  color_values <- rep(color_other, n_levels)
  names(color_values) <- p1$data$.marker_color %>% unique()
  color_values[as.character(focus_levels)] <- color_focus

  p1 <- p1 +
    aes(color = .marker_color) +
    scale_color_manual(values = color_values,
                       breaks = as.list(as.character(focus_levels)),
                       name = rlang::quo_text(var))
  return(p1)
}

