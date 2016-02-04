library(data.table)

url <- "https://raw.githubusercontent.com/timtrice/datasets/master/weather/HURDAT/hurdat.tidyr.csv"

dt <- as.data.table(read.csv(url, stringsAsFactors = FALSE))

setkey(dt, ID)

# t test
tmp <- na.omit(dt[, .(Wind, Pressure)])
t.test(tmp$Pressure, tmp$Wind)
# p-value less than 2.2e-16 or 0.00000000000000022

# correlation test
cor <- cor.test(tmp$Pressure, tmp$Wind)

# Linear model
fit = lm(Pressure ~ Wind, data = tmp)
fs <- summary(fit)
co <- coef(fs)
predict(fit)

# Predict barometric pressure based on wind
wind <- 180
1.027e+03 + (-6.602e-01) * wind

pna <- dt[is.na(Pressure) & !is.na(Wind), .(ID, Wind, Pressure)]
pna <- pna[, Pressure := round(fs$coefficients[1,1] + (fs$coefficients[2,1]) * Wind)]
pna <- pna[, Wind := NULL]

# Write.csv
write.csv(pna, file = "hurdat.predict.pressure.csv", quote = FALSE, 
    row.names = FALSE)
