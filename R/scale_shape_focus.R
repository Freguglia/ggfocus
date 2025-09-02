#' @rdname scale_focus
#'
#' @param shape_focus `shape` value for focused levels. Defaults to 8.
#' @param shape_other `shape` value for other levels. Defaults to 1.
#'
#' @examples
#' ggplot(iris,aes(x = Petal.Length, y = Sepal.Length, shape = Species)) +
#'  geom_point() +
#'  scale_shape_focus(focus_levels = "versicolor")
#'
#'
#' @export
scale_shape_focus <- function(focus_levels,
                             shape_focus = 8,
                             shape_other = 1){

  structure(list(focus_levels = focus_levels,
                 shape_focus = shape_focus,
                 shape_other = shape_other),
            class = "ggfocus_shape")
}

#' @export
#' @method ggplot_add ggfocus_shape
ggplot_add.ggfocus_shape <- function(object, plot, ...){

  p1 <- plot
  focus_levels <- object$focus_levels
  shape_focus <- object$shape_focus
  shape_other <- object$shape_other
  var <- p1$mapping$shape

  if(is.null(var)){
    stop("'shape' isn't mapped by any variable. Use '+ aes(shape = ...)' before setting the focus scale.")
  }

  p1$data <- p1$data |>
    mutate(.marker_shape = ifelse(as.character(!!var) %in% focus_levels,
                                 as.character(!!var), "Other"))

  if(sum(p1$data$.marker_shape == "Other") == 0){
    stop("Every observation is focused. Use less values in 'focus_levels'.")
  }

  if(sum(p1$data$.marker_shape != "Other") == 0){
    message("There are no observations selected. Are the levels misspelled? Is the correct variable mapped to 'shape'?")
  }


  n_levels <- p1$data$.marker_shape |> unique() |> length()


  shape_values <- numeric(n_levels)
  names(shape_values) <- p1$data$.marker_shape |> unique()
  shape_values["Other"] <- shape_other
  shape_values[names(shape_values) != "Other"] <- shape_focus

  p1 <- p1 +
    aes(shape = .marker_shape) +
    scale_shape_manual(values = shape_values,
                       breaks = focus_levels,
                       name = rlang::quo_text(var))
  return(p1)
}
