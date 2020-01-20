library(tidyverse)
library(hexSticker)
library(ggfocus)

set.seed(1)
letters[1:15] %>%
  lapply(function(x)
    data.frame(u1 = cumsum(rnorm(100) - 1/2),
               u2 = cumsum(rnorm(100) - 1/2))) %>%
  bind_rows(.id = "u3") %>%
  ggplot(aes(x = u1, y = u2,
             group = u3, alpha = factor(u3), linetype = u3,
             color = factor(u3))) +
  geom_line() +
  scale_color_focus(c(1,2,3), c("Blue", "Red", "Yellow"), "White") +
  scale_alpha_focus(c(1,2,3), 1, 0.3) +
  scale_linetype_focus(c(1,2,3), 1, 1) +
  guides(color = "none", alpha = "none", linetype = "none") +
  theme_void() -> p

library(showtext)
## Loading Google fonts (http://www.google.com/fonts)
font_add_google("Roboto", "roboto")
## Automatically use showtext to render text for future devices
showtext_auto()

a <- sticker(p, package = "ggfocus",
             s_x = 0.8, s_y =  .8, s_width = 2, s_height = 1.7,
             h_fill = "black", h_color = "darkblue",
             p_y = 1.4, p_size = 18, p_x = 0.65, p_family = "roboto",
             p_color = "white",
             url = "https://github.com/Freguglia/ggfocus",
             u_color = "white", u_size = 3.5,
             dpi = 300,
             filename = "sticker/ggfocus_sticker.png")
