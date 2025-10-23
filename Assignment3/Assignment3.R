#Assignment 3
# Exercise 1
# 
library(haven)
library(ggplot2)
library(stargazer)
data <- read_dta("Assignment3/Data/chap5-cps.dta")

data$wage <- exp(data$lnwage)
cps78 <- subset(data,year==1978)
cps85 <- subset(data,year==1985)

mean <- c(mean(cps78$lnwage, na.rm = TRUE),mean(cps85$lnwage, na.rm = TRUE))
sd <- c(sd(cps78$lnwage, na.rm = TRUE),sd(cps85$lnwage, na.rm = TRUE))
exp1 <- c(mean(exp(cps78$lnwage), na.rm = TRUE),mean(exp(cps85$lnwage), na.rm = TRUE))
exp2 <- c(exp(mean[1]),exp(mean[2]))
meansd <- data.frame (Mean_Lnwage =mean, SD_Lnwage = sd,Arithmetic_mean=exp1,Geometric_mean=exp2)

rownames(meansd) <- c("CPS78","CPS85")

ggplot(cps78, aes(y = lnwage, x = wage)) +
  geom_point(alpha = 0.6, color = "steelblue") +
  labs(
    y = "Ln(Wage)",
    x = "Wage"
  ) +
  theme_minimal()

plot_lnwage_wage78 <- ggplot(cps78, aes(x = wage, y = lnwage)) +
  geom_point(color = "black", alpha = 0.3, size = 2) +
  geom_hline(yintercept = mean[1], linetype = "dashed", color ="red") +
  annotate(geom = "text",x = 20,y = mean[1]+0.1,label = paste("Mean Ln(Wage)=",round(mean[1],2)),color = "red")+
  geom_vline(xintercept = exp1[1], linetype = "dashed", color = "blue") +
  annotate(geom = "text",x = exp1[1]+0.5,y = 2.8,label = paste("Geometric mean=",round(exp1[1],2)),color = "blue",angle = 90)+
  coord_cartesian(ylim = c(0, 3.5),xlim=c(0,30)) +
  theme_bw(base_size = 13) +
  labs(x = "Wage",y = "Ln(Wage)") +
  theme(legend.position = "none",plot.margin = margin(10, 10, 10, 10))
plot_lnwage_wage78
ggsave(filename = "Assignment3/Figures/plot_lnwage_wage78.png",plot = plot_lnwage_wage78,width = 7,height = 4.5,units = "in",dpi = 300)

stargazer(data.frame(cps78[,c("lnwage","wage")]),type = "latex",title = "Summary Statistics cps78",digits = 2,out = "Assignment3/Tables/summary_cps78.tex")

