#' @rdname scale_focus
#'
#' @param alpha_focus `alpha` value for focused levels. Defaults to 1.
#' @param alpha_other `alpha` value for other levels. Defaults to 0.05.
#'
#' @examples
#' ggplot(iris,aes(x = Petal.Length, y = Sepal.Length, alpha = Species)) +
#'  geom_point() +
#'  scale_alpha_focus(focus_levels = "versicolor")
#'
#'
#' @export
scale_alpha_focus <- function(focus_levels = character(0),
                              alpha_focus = 1,
                              alpha_other = 0.05){

  structure(list(focus_levels = focus_levels,
                 alpha_focus = alpha_focus,
                 alpha_other = alpha_other),
            class = "ggfocus_alpha")
}

#' @export
#' @method ggplot_add ggfocus_alpha
ggplot_add.ggfocus_alpha <- function(object, plot, object_name){

  p1 <- plot
  focus_levels <- object$focus_levels
  alpha_focus <- object$alpha_focus
  alpha_other <- object$alpha_other
  var <- p1$mapping$alpha

  if(is.null(var)){
    stop("'alpha' isn't mapped by any variable. Use '+ aes(alpha = ...)' before setting the focus scale.")
  }

  p1$data <- p1$data %>%
    mutate(.marker_alpha = ifelse(as.character(!!var) %in% focus_levels,
                                 as.character(!!var), "Other"))

  if(sum(p1$data$.marker_alpha == "Other") == 0){
    stop("Every observation is focused. Use less values in 'focus_levels'.")
  }

  if(sum(p1$data$.marker_alpha != "Other") == 0){
    message("There are no observations selected. Are the levels misspelled? Is the correct variable mapped to 'alpha'?")
  }


  n_levels <- p1$data$.marker_alpha %>% unique() %>% length()

  alpha_values <- rep(alpha_focus, n_levels)
  names(alpha_values) <- p1$data$.marker_alpha %>% unique()
  alpha_values["Other"] <- alpha_other

  p1 <- p1 +
    aes(alpha = .marker_alpha) +
    scale_alpha_manual(values = alpha_values,
                       breaks=NULL)
  return(p1)
}
