#install.packages("ggplot")

#load necessary packages
library(ggplot2)

##JUMP RIGHT IN!

str(mpg)
View(mpg)
?mpg

#Variables of interest:
#displ = engine displacement ~ engine size 
#hwy = highway mileage per gallon
#drv = front-wheel, rear wheel, 4wd
#cty = city miles per gallon
#cyl = # of cylinders ~ displ but not exactly same 

## QPLOT aka Quick Plot

#qplot(x_var, y_var, data = dataframe_name)

#Hello World!
qplot(displ, hwy, data = mpg)

#Add some color
qplot(displ, hwy, data = mpg, color = I("red"))

#Add color by factor
qplot(displ, hwy, data = mpg, color = drv)
#What is a factor variable vs. continuous variable 
#color maps to type of drv, colors automatically specified, and legend added
#qplot(log(displ), hwy, data = mpg, color = drv)
#plot(mpg$displ, mpg$hwy, type="p", col="red")

#Change colors?
change_color <- qplot(displ, hwy, data = mpg, color = drv)
change_color2 <- qplot(displ, hwy, data = mpg, color = drv)

change_color + scale_color_manual(values=c("purple", "yellow", "green"))
change_color2 + scale_color_manual(values=c("f" = "purple", "r" = "yellow", "4" = "green"))

#Add regression

#Common Mistake
qplot(displ, hwy, data = mpg, geom = c("smooth"), se=FALSE)

#Add Points
qplot(displ, hwy, data = mpg, geom = c("point", "smooth"))
#note: added 95% confidence interval
#qplot(displ, hwy, data = mpg, geom = c("point", "smooth"), level=.99)

#Remove Confidence Interval
qplot(displ, hwy, data = mpg, geom = c("point", "smooth"), se=FALSE)
#loess = "local regression"

#Linear Regression
qplot(displ, hwy, data = mpg, geom = c("point", "smooth"), method = "lm", se=FALSE)

#Histogram
qplot(hwy, data = mpg)
#add colors for drv 
qplot(hwy, data = mpg, fill = drv)
#hist(mpg$hwy)

#Facets
#With a Histogram
qplot(hwy, data = mpg, facets = drv ~., fill = drv)
#With a Plot
qplot(displ, hwy, data = mpg, facets = .~drv, color = drv)
#Add Regressions by Factor
qplot(displ, hwy, data = mpg, geom = c("point", "smooth"), method = "lm", se=FALSE, facets = .~drv, color = drv)
#Keep as one graph
qplot(displ, hwy, data = mpg, geom = c("point", "smooth"), method = "lm", se=FALSE, facet_grid = .~class, color = drv)

##GGPLOT

#Build similar graph with ggplot
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth(method = "lm", se = F) +
  facet_grid(. ~drv) +
  labs(x="Engine Size", y = "Highway Mileage", title = "Highway Mileage by Engine Size", subtitle = "Created Using GGPlot")
#If yours looks a little different....its smart, might remember settings I have

#Facet_wraps
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth(method = "lm", se = F) +
  facet_grid(. ~class) + #change drv to class
  labs(x="Engine Size", y = "Highway Mileage", title = "Highway Mileage by Engine Size", subtitle = "Created Using GGPlot") +
  #facet_wrap(~class, nrow= 2)


#Lets make it pretty
ggplot(mpg, aes(displ, hwy)) +
geom_point(aes(color = cty, size = cyl)) + #, alpha = .5 - alpha not good for here, just to show
geom_smooth(method = "lm", se = F, color = "red") +
labs(x="Engine Size", y = "Highway Mileage", title = "Highway Mileage by Engine Size", subtitle = "Created Using GGPlot") +
theme(panel.background = element_rect(fill="black"),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      text = element_text(size=16, family="Times")
)

#Export these graphics
g <- ggplot(mpg, aes(displ, hwy)) +
geom_point(aes(color = cty, size = cyl)) + #, alpha = .5 - alpha not good for here, just to show
  geom_smooth(method = "lm", se = F, color = "red") +
  labs(x="Engine Size", y = "Highway Mileage", title = "Highway Mileage by Engine Size", subtitle = "Created Using GGPlot") +
  theme(panel.background = element_rect(fill="black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        text = element_text(size=16, family="Times")
  )
ggsave("/Users/Kalman/Documents/BDAA/mpg_graph.pdf", plot=g,  width=10, height=6)
#ggsave("/Users/Kalman/Documents/BDAA/mpg_graph.jpeg", plot=g,  width=10, height=6)
#Rule of Thumb:
  #-pdf to resize
  #-jpeg, png for static, but higher res


