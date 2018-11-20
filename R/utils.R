#' plot a matrix into heatmap
#' 
#' @import ggplot2
#' @export
plot.heatmap <- function(X) {
    mm = reshape2::melt(X)
    p = ggplot2::ggplot(mm) +
        geom_tile(aes(x=Var1,y=Var2,fill=value)) +
        scale_fill_gradient2(low='red', mid='white', high='steelblue') +
        theme(axis.text.x = element_text(angle=30,hjust=1), axis.title.x = element_blank(), axis.title.y = element_blank()) +
        coord_fixed() 
    return(p)   
}

ggplotColours <- function(n=6, h=c(0, 360) +15){
    if ((diff(h)%%360) < 1) h[2] <- h[2] - 360/n
    hcl(h = (seq(h[1], h[2], length = n)), c = 100, l = 65)
}
