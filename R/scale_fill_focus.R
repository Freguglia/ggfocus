#' @rdname scale_focus
#'
#' @examples
#' ggplot(iris,aes(x = Petal.Length, group = Species, fill = Species)) +
#'   geom_histogram() +
#'   scale_fill_focus(focus_levels = "versicolor", color_focus = "red")
#'
#' @export
scale_fill_focus <- function(focus_levels, color_focus = NULL,
                             color_other = "gray", palette_focus = "Set1"){
  structure(list(focus_levels = focus_levels,
                 color_focus = color_focus,
                 color_other = color_other,
                 palette_focus = palette_focus),
            class = "ggfocus_fill")
}

#' @export
#' @method ggplot_add ggfocus_fill
ggplot_add.ggfocus_fill <- function(object, plot, ...){

  p1 <- plot
  focus_levels <- object$focus_levels
  color_focus <- object$color_focus
  color_other <- object$color_other
  palette_focus <- object$palette_focus
  var <- p1$mapping$fill

  if(is.null(var)){
    message("'fill' isn't mapped by any variable. Use 'aes(fill = ...) + scale_fill_focus(...)")
    return(plot)
  }

  p1$data <- p1$data |>
    mutate(.marker_fill = ifelse(as.character(!!var) %in% focus_levels,
                                  as.character(!!var), "Other"))

  if(sum(p1$data$.marker_fill == "Other") == 0){
    stop("Every observation is focused. Use less values in 'focus_levels'.")
  }

  if(sum(p1$data$.marker_fill != "Other") == 0){
    message("There are no observations selected. Are the levels misspelled? Is the correct variable mapped to 'fill'?")
  }


  n_levels <- p1$data$.marker_fill |> unique() |> length()

  if(is.null(color_focus)){
    color_focus <- suppressWarnings(
      RColorBrewer::brewer.pal(n_levels-1, palette_focus)[1:(n_levels-1)])
  }

  if(length(color_focus)!=1 & length(color_focus)!=length(focus_levels)){
    stop("color_focus must be of length 1 or same length as focus_levels.")
  }
  color_values <- rep(color_other, n_levels)
  names(color_values) <- p1$data$.marker_fill |> unique()
  color_values[as.character(focus_levels)] <- color_focus

  p1 <- p1 +
    aes(fill = .marker_fill) +
    scale_fill_manual(values = color_values,
                      breaks = as.list(as.character(focus_levels)),
                      name = rlang::quo_text(var))
  return(p1)
}
