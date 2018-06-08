# Unit Imputation Barometric Pressure for HURDAT
library(HURDAT)
library(ggplot2)
library(lubridate)

data("AL_details")
data("EP_details")
data("CP_details")

# Filter each dataset by Year, Status, Record, !NA and combine into one dataframe
df <- bind_rows(AL_details %>% 
                    filter(!is.na(Wind), 
                           !is.na(Pressure), 
                           year(Datetime) >= 1970, 
                           Status %in% c("TS", "HU"), 
                           Record != "L") %>% 
                    select(Wind, Pressure) %>% 
                    mutate(Basin = "AL"),
                EP_details %>% 
                    filter(!is.na(Wind), 
                           !is.na(Pressure), 
                           year(Datetime) >= 1970, 
                           Status %in% c("TS", "HU"), 
                           Record != "L") %>% 
                    select(Wind, Pressure) %>% 
                    mutate(Basin = "EP"), 
                CP_details %>% 
                    filter(!is.na(Wind), 
                           !is.na(Pressure), 
                           year(Datetime) >= 1970, 
                           Status %in% c("TS", "HU"), 
                           Record != "L") %>% 
                    select(Wind, Pressure) %>% 
                    mutate(Basin = "CP"))

# Plot linear relationship
df %>% 
    ggplot(aes(x = Pressure, y = Wind, colour = Basin)) + 
    geom_point() + 
    stat_smooth(method = "lm") + 
    facet_grid(Basin ~ .) + 
    ggtitle("Scatter Plot of Pressure ~ Wind")

# Atlantic

lm_al <- lm(Pressure ~ Wind, data = df[df$Basin == "AL",])
summary(lm_al)
lm_al_pred <- predict(lm_al, df[df$Basin == "AL",])
res_al <- residuals(lm_al)

lm_al %>% 
    ggplot(aes(.fitted, .resid)) + 
    geom_point(colour = "red") + 
    theme(legend.position = "none") + 
    theme_bw() + 
    ggtitle("lm_al Residuals")

lm_al %>% 
    ggplot(aes(sample = Pressure)) + 
    geom_point(stat = "qq", colour = "red") + 
    theme_bw() + 
    ggtitle("Q-Q Plot for lm_al")

rmse_al <- sqrt(mean(res_al ^ 2))
rmse_al
rsq_al <- 1 - sum(res_al ^ 2) / sum((df[df$Basin == "AL",]$Wind - mean(df[df$Basin == "AL",]$Wind)) ^ 2)
rsq_al

# Central Pacific

lm_cp <- lm(Pressure ~ Wind, data = df[df$Basin == "CP",])
summary(lm_cp)
lm_cp_pred <- predict(lm_cp, df[df$Basin == "CP",])
res_cp <- residuals(lm_cp)

lm_cp %>% 
    ggplot(aes(.fitted, .resid)) + 
    geom_point(colour = "blue") + 
    theme(legend.position = "none") + 
    theme_bw() + 
    ggtitle("lm_cp Residuals")

lm_cp %>% 
    ggplot(aes(sample = Pressure)) + 
    geom_point(stat = "qq", colour = "blue") + 
    theme_bw() + 
    ggtitle("Q-Q Plot for lm_cp")

rmse_cp <- sqrt(mean(res_cp ^ 2))
rmse_cp
rsq_cp <- 1 - sum(res_cp ^ 2) / sum((df[df$Basin == "CP",]$Wind - mean(df[df$Basin == "CP",]$Wind)) ^ 2)
rsq_cp

# Eastern Pacific

lm_ep <- lm(Pressure ~ Wind, data = df[df$Basin == "EP",])
summary(lm_ep)
lm_ep_pred <- predict(lm_ep, df[df$Basin == "EP",])
res_ep <- residuals(lm_ep)

lm_ep %>% 
    ggplot(aes(.fitted, .resid)) + 
    geom_point(colour = "green") + 
    theme(legend.position = "none") + 
    theme_bw() + 
    ggtitle("lm_ep Residuals")

lm_ep %>% 
    ggplot(aes(sample = Pressure)) + 
    geom_point(stat = "qq", colour = "green") + 
    theme_bw() + 
    ggtitle("Q-Q Plot for lm_ep")

rmse_ep <- sqrt(mean(res_ep ^ 2))
rmse_ep
rsq_ep <- 1 - sum(res_ep ^ 2) / sum((df[df$Basin == "EP",]$Wind - mean(df[df$Basin == "EP",]$Wind)) ^ 2)
rsq_ep

# All Basins

lm_all <- lm(Pressure ~ Wind, data = df)
summary(lm_all)
lm_all_pred <- predict(lm_all, df)
res_all <- residuals(lm_all)

lm_all %>% 
    ggplot(aes(.fitted, .resid)) + 
    geom_point(colour = "black") + 
    theme(legend.position = "none") + 
    theme_bw() + 
    ggtitle("lm_all Residuals")

lm_all %>% 
    ggplot(aes(sample = Pressure)) + 
    geom_point(stat = "qq", colour = "black") + 
    theme_bw() + 
    ggtitle("Q-Q Plot for lm_all")

rmse_all <- sqrt(mean(res_all ^ 2))
rmse_all
rsq_all <- 1 - sum(res_all ^ 2) / sum((df$Wind - mean(df$Wind)) ^ 2)
rsq_all

# Predict
press_imp <- bind_rows(AL_details %>% 
                        filter(!is.na(Wind), 
                               is.na(Pressure)) %>%  
                        select(Wind, Pressure), 
                    EP_details %>% 
                        filter(!is.na(Wind), 
                               is.na(Pressure)) %>% 
                        select(Wind, Pressure), 
                    CP_details %>% 
                        filter(!is.na(Wind), 
                               is.na(Pressure)) %>% 
                        select(Wind, Pressure))

press_imp <- unique(df_pna)

press_imp$Pressure <- round(predict(lm_ep, press_imp))

press_imp %>% 
    ggplot(aes(x = Pressure, y = Wind)) + 
    geom_point() + 
    stat_smooth(method = "lm") + 
    theme_bw() + 
    ggtitle("Predicted Pressure v. Wind")
