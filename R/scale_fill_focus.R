#' @rdname scale_focus
#'
#' @description Color scale for `fill` aesthetics. This is an alternative use for \link{ggfocus} that uses the usual grammar of graphics.
#'
#' @param focus_levels character vector with levels to focus.
#' @param color_focus `fill` color for focused levels.
#' @param color_other `fill` color for other levels.
#'
#' @examples
#'  p <- ggplot(iris,aes(x = Petal.Length, group = Species, fill = Species)) + geom_histogram() +
#'   scale_fill_focus(focus_levels = "versicolor", color_focus = "red")
#'
#' @author Victor Freguglia
#'
#' @export
scale_fill_focus <- function(focus_levels = character(0),
                             color_focus = NULL,
                             color_other = "gray"){

  structure(list(focus_levels = focus_levels,
                 color_focus = color_focus,
                 color_other = color_other),
            class="ggfocus_fill")
}

#' @export
#' @method ggplot_add ggfocus_fill
ggplot_add.ggfocus_fill <- function(object, plot, object_name){

  p1 <- plot
  focus_levels <- object$focus_levels
  color_focus <- object$color_focus
  color_other <- object$color_other
  var <- p1$mapping$fill

  if(is.null(var)){stop("'fill' isn't mapped by any variable. Use 'aes(fill=...) + scale_fill_focus(...)")}
  data <- p1$data
  var_column <- data %>% select_(var) %>% lapply(as.character) %>% unlist
  if(".marker_fill" %in% colnames(data)){data$.marker_fill=NULL}
  .marker_fill <- ifelse(var_column %in% focus_levels, as.character(var_column),"Other")
  p1$data$.marker_fill <- .marker_fill
  n_levels <- .marker_fill %>% unique %>% length
  if(is.null(color_focus)){
    color_focus <- suppressWarnings(RColorBrewer::brewer.pal(n_levels-1,"Set1")[1:(n_levels-1)])
  }
  if(length(color_focus)!=1 & length(color_focus)!=length(focus_levels)){
    stop("color_focus must be of length 1 or same length as focus_levels.")}
  color_values <- rep(color_other,n_levels)
  names(color_values) <- .marker_fill %>% unique()
  color_values[focus_levels] = color_focus
  p1 <- p1 + aes(fill=.marker_fill) + scale_fill_manual(values=color_values,
                               breaks=as.list(as.character(focus_levels)),
                               name=(var))
  return(p1)
}
