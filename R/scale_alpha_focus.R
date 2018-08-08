scale_alpha_focus <- function(focus_levels,alpha_focus=1,alpha_other=0.05){
  structure(list(focus_levels = focus_levels,
                 alpha_focus = alpha_focus,
                 alpha_other = alpha_other),class="ggfocus_alpha")
}

ggplot_add.ggfocus_alpha <- function(object, plot, objectname){
  p1 <- plot
  focus_levels <- object$focus_levels
  alpha_focus <- object$alpha_focus
  alpha_other <- object$alpha_other
  var <- p1$mapping$alpha
  data <- p1$data
  var_column <- data %>% select(!!var) %>% lapply(as.character) %>% unlist
  if(".marker" %in% colnames(data)){data$.marker=NULL}
  .marker <- ifelse(var_column %in% focus_levels, as.character(var_column),"Other")
  p1$data$.marker <- .marker
  n_levels <- .marker %>% unique %>% length
  alpha_values <- rep(alpha_focus,n_levels)
  names(alpha_values) <- .marker %>% unique()
  alpha_values["Other"] = alpha_other
  p1 <- p1 + aes(alpha=.marker) + scale_alpha_manual(values=alpha_values,breaks=NULL)
  return(p1)
}
