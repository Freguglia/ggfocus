#' @title (Deprecated) Sets focus scales to an existing `ggplot` object
#'
#' @description
#'
#' `ggfocus()` is deprecated. Add focus scales with `scale_color_focus()`,
#' `scale_fill_focus()`, `scale_alpha_focus()`, ... instead.
#'
#' Creates a `ggplot` object with focus scales from another `ggplot` object.
#'
#' @param p a `ggplot` object.
#' @param var Sets.
#' @param focus_levels levels to be highlited.
#' @param focus_aes list of aesthetics used to highlight. "color","alpha" and "fill" are available.
#' @param color_focus vector of colors (or a single color) for focused levels.
#' @param color_other color for non-focused levels.
#' @param alpha_focus,alpha_other alpha value for focused and non-focused levels.
#'
#' @return a ggplot object with focusing scales.
#'
#' @examples
#' library(ggplot2)
#' p <- ggplot(iris,aes(x=Sepal.Length,y=Petal.Length)) + geom_point()
#' ggfocus(p, Species, "versicolor")
#'
#' @author Victor Freguglia
#' @export
ggfocus <- function(p,
                    var, focus_levels,
                    focus_aes=c("color","alpha","fill"),
                    color_focus = NULL, color_other = "black",
                    alpha_focus = 1, alpha_other = 0.05){

  message("The function 'ggfocus()' is deprecated, consider using the family scale_*_focus() instead.")

  p1 <- p
  data <- p$data
  var <- enquo(var)
  var_column <- data %>% select_(var) %>% lapply(as.character) %>% unlist
  if("Other" %in% focus_levels){stop("'Other' cannot be the name of a focus level.")}

  if(".marker" %in% colnames(data)){data$.marker=NULL}

  .marker <- ifelse(var_column %in% focus_levels, as.character(var_column),"Other")
  p1$data$.marker <- .marker
  n_levels <- .marker %>% unique %>% length
  if("color" %in% focus_aes){
    if(is.null(color_focus)){
      color_focus <- suppressWarnings(RColorBrewer::brewer.pal(n_levels-1,"Set1")[1:(n_levels-1)])
    }
    if(length(color_focus)!=1 & length(color_focus)!=length(focus_levels)){
      stop("color_focus must be of length 1 or same length as focus_levels.")}
    color_values <- rep(color_other,n_levels)
    names(color_values) <- .marker %>% unique()
    color_values[focus_levels] = color_focus
    p1 <- p1 + aes(color=.marker) + scale_color_manual(values=color_values,
                                                       breaks=as.list(as.character(focus_levels)),
                                                       name=(var))
  }
  if("fill" %in% focus_aes){
    if(is.null(color_focus)){
      color_focus <- suppressWarnings(RColorBrewer::brewer.pal(n_levels-1,"Set1")[1:(n_levels-1)])
    }
    if(length(color_focus)!=1 & length(color_focus)!=length(focus_levels)){
      stop("color_focus must be of length 1 or same length as focus_levels.")}
    color_values <- rep(color_other,n_levels)
    names(color_values) <- .marker %>% unique()
    color_values[focus_levels] = color_focus
    p1 <- p1 + aes(fill=.marker) + scale_fill_manual(values=color_values,
                                                       breaks=as.list(as.character(focus_levels)),
                                                       name=(var))
  }
  if("alpha" %in% focus_aes){
    alpha_values <- rep(alpha_focus,n_levels)
    names(alpha_values) <- .marker %>% unique()
    alpha_values["Other"] = alpha_other
    p1 <- p1 + aes(alpha=.marker) + scale_alpha_manual(values=alpha_values,breaks=NULL)
  }
  p1
}
