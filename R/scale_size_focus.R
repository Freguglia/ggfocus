#' @rdname scale_focus
#'
#' @param size_focus `size` value for focused levels. Defaults to 3.
#' @param size_other `size` value for other levels. Defaults to 1.
#'
#' @examples
#' ggplot(iris,aes(x = Petal.Length, y = Sepal.Length, size = Species)) +
#'  geom_point() +
#'  scale_size_focus(focus_levels = "versicolor")
#'
#'
#' @export
scale_size_focus <- function(focus_levels = character(0),
                              size_focus = 3,
                              size_other = 1){

  structure(list(focus_levels = focus_levels,
                 size_focus = size_focus,
                 size_other = size_other),
            class = "ggfocus_size")
}

#' @export
#' @method ggplot_add ggfocus_size
ggplot_add.ggfocus_size <- function(object, plot, object_name){

  p1 <- plot
  focus_levels <- object$focus_levels
  size_focus <- object$size_focus
  size_other <- object$size_other
  var <- p1$mapping$size

  if(is.null(var)){
    stop("'size' isn't mapped by any variable. Use '+ aes(size = ...)' before setting the focus scale.")
  }

  p1$data <- p1$data %>%
    mutate(.marker_size = ifelse(as.character(!!var) %in% focus_levels,
                                  as.character(!!var), "Other"))

  if(sum(p1$data$.marker_size == "Other") == 0){
    stop("Every observation is focused. Use less values in 'focus_levels'.")
  }

  if(sum(p1$data$.marker_size != "Other") == 0){
    message("There are no observations selected. Are the levels misspelled? Is the correct variable mapped to 'alpha'?")
  }


  n_levels <- p1$data$.marker_size %>% unique() %>% length()

  size_values <- rep(size_focus, n_levels)
  names(size_values) <- p1$data$.marker_size %>% unique()
  size_values["Other"] <- size_other

  p1 <- p1 +
    aes(size = .marker_size) +
    scale_size_manual(values = size_values,
                       breaks=NULL)
  return(p1)
}
