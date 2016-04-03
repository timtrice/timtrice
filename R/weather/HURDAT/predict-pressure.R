library(data.table)
library(ggplot2)
library(VIM)
library(knitr)
library(tidyr)

url <- "https://raw.githubusercontent.com/timtrice/datasets/master/weather/HURDAT/hurdat.tidyr.csv"

dt <- as.data.table(read.csv(url, stringsAsFactors = FALSE))

setkey(dt, ID)

base <- dt[, .(ID, Basin, YearNum, Datetime, Status, Wind, Pressure, Latitude)
          ][,Year := year(Datetime)]

# Show missing Wind/Pressure values
tmp <- as.data.frame(base[, .(Wind, Pressure)])
histMiss(tmp)

ggplot(data = tmp, aes(x = Wind, y = Pressure)) + 
    geom_point() + 
    geom_smooth(method = "lm")

# We can easily see we have a strong negative linear association between Wind and Pressure. Of course, differences in pressure create wind so this is not a surprise.

# But what I want to do is try to find the best linear fit to populate the missing pressure values. So I run a simple linear model on various data combinations in an attempt to find that best fit.

# Here, I run `lm()` on the dataset filtered only by removing NA values from both Wind and Pressure

model <- lm(Pressure ~ Wind, data = tmp)

modelTidy <- tidy(model)
modelTidy

modelGlance <- glance(model)
modelGlance

# What if we filter where the system is a tropical cyclone?

tmpSta <- base[Status %in% c("TD", "TS", "HU"), .(Wind, Pressure)]

modelSta <- lm(Pressure ~ Wind, data = tmpSta)

modelTidySta <- tidy(modelSta)
modelTidySta

modelGlanceSta <- glance(modelSta)
modelGlanceSta

# Hurricane reconnaissance began in the 1940's. And typically, it's Atlantic cyclones that are investigated. What results do we get if we add an additional filter on Atlantic storms and Year? 
tmpStaReco <- na.omit(base[Status %in% c("TD", "TS", "HU") & Basin == "AL" & Year > 1950, 
                  .(Wind, Pressure)])

modelStaReco <- lm(Pressure ~ Wind, data = tmpStaReco)

modelTidyStaReco <- tidy(modelStaReco)
modelTidyStaReco

modelGlanceStaReco <- glance(modelStaReco)
modelGlanceStaReco

# Predict

# `modelSta` has slightly better R-Squared and standard error results but `modelStaReco` has far better *AIC* and *BIC* values. 

# I want to run predictions on both models and determine which one has better results.

# I'll create a training and testing data set on all non-NA Wind and Pressure obs.

###############################################################################
# Status-only filter
set.seed(2016)
tmpStaNA <- na.omit(tmpSta)
idxStaNA <- sample(1:nrow(tmpStaNA), 0.8 * nrow(tmpStaNA))
trainStaNA <- tmpStaNA[idxStaNA,]
testStaNA <- tmpStaNA[-idxStaNA,]

trainStaNaLm <- lm(Pressure ~ Wind, data = trainStaNA)
testStaNA <- testStaNA[, PressPred := round(predict(trainStaNaLm, testStaNA))]

summary(modelSta)
summary(trainStaNaLm)
AIC(trainStaNaLm)
BIC(trainStaNaLm)

# Calculate prediction accuracy and error rates
cor(testStaNA[, .(Pressure, PressPred)])

# Calculate MinMaxAccuracy
MMAStaNA <- mean(apply(testStaNA[, .(Pressure, PressPred)], 1, min) / apply(testStaNA[, .(Pressure, PressPred)], 1, max))
MMAStaNA

# Calculate Mean Absolute Percentage Error 
MAPEStaNA <- mean(abs((testStaNA$PressPred - testStaNA$Pressure))/testStaNA$Pressure)
MAPEStaNA

ggplot(testStaNA) + 
    geom_point(aes(x = Wind, y = Pressure)) + 
    geom_smooth(aes(x = Wind, y = Pressure, colour = "blue")) + 
    geom_smooth(aes(x = Wind, y = PressPred, colour = "red"))

###############################################################################
# Status and Reco filter
tmpStaRecoNA <- na.omit(tmpStaReco)
idxStaRecoNA <- sample(1:nrow(tmpStaRecoNA), 0.8 * nrow(tmpStaRecoNA))
trainStaRecoNA <- tmpStaRecoNA[idxStaRecoNA,]
testStaRecoNA <- tmpStaRecoNA[-idxStaRecoNA,]

trainStaRecoNaLm <- lm(Pressure ~ Wind, data = trainStaRecoNA)
testStaRecoNA <- testStaRecoNA[, PressPred := round(predict(trainStaRecoNaLm, testStaRecoNA))]

summary(modelStaReco)
summary(trainStaRecoNaLm)
AIC(trainStaRecoNaLm)
BIC(trainStaRecoNaLm)

# Calculate prediction accuracy and error rates
cor(testStaRecoNA[, .(Pressure, PressPred)])

MMAStaRecoNA <- mean(apply(testStaRecoNA[, .(Pressure, PressPred)], 1, min) / apply(testStaRecoNA[, .(Pressure, PressPred)], 1, max))
MMAStaRecoNA

# Calculate Mean Absolute Percentage Error 
MAPEStaRecoNA <- mean(abs((testStaRecoNA$PressPred - testStaRecoNA$Pressure))/testStaRecoNA$Pressure)
MAPEStaRecoNA

ggplot(testStaRecoNA) + 
    geom_point(aes(x = Wind, y = Pressure)) + 
    geom_smooth(aes(x = Wind, y = Pressure, colour = "blue")) + 
    geom_smooth(aes(x = Wind, y = PressPred, colour = "red"))

# `modelSta` has a slightly better R-Squared, MMA and MAPE values but `modelStaReco` has far better F-Statistic, AIC and BIC values.

# So going back to our original `tmp` dataset, if we filter only on NA values, can we see how the two models stack against each other?
tmpNA <- as.data.table(na.omit(tmp))
tmpNA <- tmpNA[, ":=" (modelSta = round(predict(trainStaNaLm, tmpNA)), 
                        modelStaReco = round(predict(trainStaRecoNaLm, tmpNA)))]
tmpNA <- as.data.table(gather(tmpNA, model, prediction, modelSta, modelStaReco))

ggplot(tmpNA, aes(x = Wind, y = Pressure)) + 
    geom_point() + 
    geom_smooth(aes(y = prediction, group = factor(model), colour = factor(model))) + 
    geom_smooth(method = "lm") + 
    scale_colour_discrete(name = "Model")

# Neither of our models gives us a significant advantage over the base linear model (blue). In fact, as we saw in our output variables earlier, the differences are very minimal overall.

# Except! Is using a simple linear model really the way to go? I don't think so. We can see this by using a loess curve.

ggplot(tmpNA, aes(x = Wind, y = Pressure)) + 
    geom_point() + 
    geom_smooth()

# Using the loess curve which is weighted by n-nearest neighbors, we get much better fitting with the higher wind values. So, even though we do have a negative linear relationship, perhaps that relationship is exponential? 

modelExp = lm(Pressure ~ Wind + I(Wind^2), data = tmpNA)
modelExpTidy <- tidy(modelExp)

ggplot(tmpNA, aes(x = Wind, y = Pressure)) + 
    geom_point() + 
    geom_smooth() + 
    stat_function(
        fun = function(x) {
            modelExpTidy[1,2] + modelExpTidy[2,2] * x + modelExpTidy[3,2] * 
                x^2
        }, colour = "red")

idxtmpNA <- sample(1:nrow(tmpNA), 0.8 * nrow(tmpNA))
traintmpNA <- tmpNA[idxtmpNA,]
testtmpNA <- tmpNA[-idxtmpNA,]

traintmpNaLm <- lm(Pressure ~ Wind, data = traintmpNA)
testtmpNA <- testtmpNA[, PressPred := round(predict(traintmpNaLm, testtmpNA))]

summary(trainStaNaLm)
summary(traintmpNaLm)
AIC(traintmpNaLm)
BIC(traintmpNaLm)

# Calculate prediction accuracy and error rates
cor(testtmpNA[, .(Pressure, PressPred)])

MMAtmpNA <- mean(apply(testtmpNA[, .(Pressure, PressPred)], 1, min) / apply(testtmpNA[, .(Pressure, PressPred)], 1, max))
MMAtmpNA

# Calculate Mean Absolute Percentage Error 
MAPEtmpNA <- mean(abs((testtmpNA$PressPred - testtmpNA$Pressure))/testtmpNA$Pressure)
MAPEtmpNA

ggplot(testtmpNA) + 
    geom_point(aes(x = Wind, y = Pressure)) + 
    geom_point(aes(x = Wind, y = PressPred, colour = "red"))











# Clearly neither of the models have a significant edge over 

tmp <- na.omit(base[Status %in% c("TD", "TS", "HU"), .(Wind, Pressure)])
fit = lm(Pressure ~ Wind, data = tmp)
fs <- summary(fit)
# Get NA Pressure
pna <- base[is.na(Pressure) & !is.na(Wind), .(ID, Wind, Pressure)]

# I can't seem to get the predict function working within a data table. 
pna <- pna[, Pressure := round(fs$coefficients[1,1] + (fs$coefficients[2,1]) * Wind)]

# Drop Wind
pna <- pna[, ":=" (Wind = NULL)]

# Test
dupdt <- dt
dupdt <- dupdt[pna$ID, Pressure := pna$Pressure]

# dupdt summary
# Show missing Wind/Pressure values
tmp <- as.data.frame(dupdt[, .(Wind, Pressure)])
histMiss(tmp)

# Plot again w/ our new values
tmp <- na.omit(dt[, .(Wind, Pressure)])
ggplot(tmp, aes(x = Wind, y = Pressure)) + 
    geom_point() + 
    geom_smooth(method = "lm")

# Save CSV
#write.csv(pna, file = "./data/weather/HURDAT/hurdat.predict.pressure.csv", 
#          quote = FALSE, row.names = FALSE)

# And we're done
