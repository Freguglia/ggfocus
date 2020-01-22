#' @rdname scale_focus
#'
#' @param linetype_focus vector of `linetype` value(s) for focused levels with
#' length 1 or equal to `focus_levels`. Defaults to 1.
#' @param linetype_other `linetype` value for other levels. Defaults to 3.
#'
#' @export
scale_linetype_focus <- function(focus_levels, linetype_focus = 1,
                                 linetype_other = 3){
  structure(list(focus_levels = focus_levels,
                 linetype_focus = linetype_focus,
                 linetype_other = linetype_other),
            class = "ggfocus_linetype")
}

#' @export
#' @method ggplot_add ggfocus_linetype
ggplot_add.ggfocus_linetype <- function(object, plot, object_name){

  p1 <- plot
  focus_levels <- object$focus_levels
  linetype_focus <- object$linetype_focus
  linetype_other <- object$linetype_other
  var <- p1$mapping$linetype

  if(is.null(var)){
    stop("'linetype' isn't mapped by any variable. Use '+ aes(linetype = ...)' before setting the focus scale.")
  }

  p1$data <- p1$data %>%
    mutate(.marker_linetype = ifelse(as.character(!!var) %in% focus_levels,
                                 as.character(!!var), "Other"))

  if(sum(p1$data$.marker_linetype == "Other") == 0){
    stop("Every observation is focused. Use less values in 'focus_levels'.")
  }

  if(sum(p1$data$.marker_linetype != "Other") == 0){
    message("There are no observations selected. Are the levels misspelled? Is the correct variable mapped to 'linetype'?")
  }


  n_levels <- p1$data$.marker_linetype %>% unique() %>% length()

  linetype_values <- numeric(n_levels)
  names(linetype_values) <- p1$data$.marker_linetype %>% unique()
  linetype_values["Other"] <- linetype_other
  linetype_values[names(linetype_values) != "Other"] <- linetype_focus

  p1 <- p1 +
    aes(linetype = .marker_linetype) +
    scale_linetype_manual(values = linetype_values,
                       breaks = focus_levels,
                       name = rlang::quo_text(var))
  return(p1)
}
