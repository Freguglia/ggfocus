#' @title Focus scale for color aesthetics
#'
#' @description Creates a color scale that focus on specific levels.
#'
#' @param focus_levels character vector with levels to focus.
#' @param color_focus `color` for focused levels.
#' @param color_other `color` for other levels.
#'
#' @examples
#'  ggplot(iris,aes(x = Petal.Length, y = Sepal.Length, color = Species)) +
#'  geom_point() +
#'  scale_color_focus(focus_levels = "setosa", color_focus = "red")
#'
#' @export
scale_color_focus <- function(focus_levels,
                              color_focus = NULL,
                              color_other = "black",
                              palette_focus = "Set1"){

  structure(list(focus_levels = focus_levels,
                 color_focus = color_focus,
                 color_other = color_other,
                 palette_focus = palette_focus),
            class = "ggfocus_color")
}

#' @export
#' @method ggplot_add ggfocus_color
ggplot_add.ggfocus_color <- function(object, plot, object_name){

  p1 <- plot
  focus_levels <- object$focus_levels
  color_focus <- object$color_focus
  color_other <- object$color_other
  palette_focus <- object$palette_focus
  var <- p1$mapping$colour

  if(is.null(var)){
    message("'color' isn't mapped in any variable. Use 'aes(color=...)' before creating the focus scale.")
    return(plot)
  }
  data <- p1$data
  var_column <- data %>% select_(var) %>% lapply(as.character) %>% unlist

  if(".marker_color" %in% colnames(data)){
    data$.marker_color=NULL
  }
  .marker_color <- ifelse(var_column %in% focus_levels, as.character(var_column), "Other")
  p1$data$.marker_color <- .marker_color
  n_levels <- .marker_color %>% unique %>% length

  if(is.null(color_focus)){
    color_focus <- suppressWarnings(
      RColorBrewer::brewer.pal(n_levels-1, palette_focus)[1:(n_levels-1)])
  }
  if(length(color_focus)!=1 & length(color_focus)!=length(focus_levels)){
    stop("color_focus must be of length 1 or same length as focus_levels.")}
  color_values <- rep(color_other,n_levels)
  names(color_values) <- .marker_color %>% unique()
  color_values[focus_levels] = color_focus
  p1 <- p1 + aes(color=.marker_color) + scale_color_manual(values=color_values,
                                                     breaks = as.list(as.character(focus_levels)),
                                                     name = (var))
  return(p1)
}


