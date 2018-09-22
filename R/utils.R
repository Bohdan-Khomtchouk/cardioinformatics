#' plot a matrix into heatmap
#' 
#' @import ggplot
#' @export
plot.heatmap <- function(X) {
    mm = reshape2::melt(X)
    p = ggplot(mm) +
        geom_tile(aes(x=Var1,y=Var2,fill=value)) +
        scale_fill_gradient2(low='red', mid='white', high='steelblue') +
        theme(axis.text.x = element_text(angle=30,hjust=1), axis.title.x = element_blank(), axis.title.y = element_blank()) +
        coord_fixed() 
    return(p)   
}