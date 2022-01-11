## DataFEWsion workshop
## Author: Fernando E. Miguez
## Date: 2022-01-11

library(apsimx)
library(ggplot2)

#### Retrieving and visualizing weather data ####

## This code 'gets' the data through a call to IEM
ames.iem <- get_iem_apsim_met(lonlat = c(-93.77, 42.02), 
                              dates = c("1990-01-01", "2021-12-31"))
## There is a summary function which provides some summaries per year
summary(ames.iem)
## Quick visualization for just a few years, but it is still hard to see
plot(ames.iem, years = 2012:2015)
## Cumulative is sometimes easier to see
plot(ames.iem, years = 2012:2015, cumulative = TRUE, climatology = TRUE)
## 2012 stands out as a fairly warm year
## We can also add the climatology
plot(ames.iem, 
     met.var = "rain", 
     years = 2012:2015, 
     cumulative = TRUE, 
     climatology = TRUE)
## So clearly 2012 stands out as a HOT and DRY year
## Let's look at more recent data
plot(ames.iem, 
     years = 2018:2021, 
     cumulative = TRUE, 
     climatology = TRUE)

plot(ames.iem, 
     met.var = "rain", 
     years = 2018:2021, 
     cumulative = TRUE, 
     climatology = TRUE)
## Combining summary utilities and plotting
## This needs ggplot2
p1 <- plot(ames.iem,
           summary = TRUE,
           compute.frost = TRUE,
           met.var = "frost_days")
p1 + geom_smooth(method = "lm", se = FALSE)

#### Comparing sources of weather data ####

pwr <- get_power_apsim_met(lonlat = c(-93.77, 42.02), 
                           dates = c("2010-01-01","2021-12-10"))

iem <- get_iem_apsim_met(lonlat = c(-93.77, 42.02), 
                         dates = c("2010-01-01","2021-12-10"))

## Comparing variables. We only select the first 6 columns from POWER
cmp <- compare_apsim_met(pwr[, 1:6], iem, labels = c("POWER", "IEM"))
## Let's compare solar radiation
plot(cmp, met.var = "radn") ## IEM has a poitive bias
plot(cmp, met.var = "radn", plot.type = "ts", cumulative = TRUE) 
## Let's compare precipitation
plot(cmp, met.var = "rain") ## The difference is smaller
plot(cmp, met.var = "rain", plot.type = "ts", cumulative = TRUE) 

#### US Soil Database SSURGO (USDA/NRCS) ####

## This line gets data from SSURGO, but just the tables
ams.tbls <- get_ssurgo_tables(lonlat = c(-93.77, 42.02))
## Let's see the structure
names(ams.tbls)
class(ams.tbls)
ams.tbls$mapunit.shp

## Retrieving an area
ams.tbls2 <- get_ssurgo_tables(lonlat = c(-93.77, 42.02), shift = 300)
ams.tbls2$mapunit.shp$mukey <- as.factor(ams.tbls2$mapunit.shp$mukey)
plot(ams.tbls2$mapunit.shp[, "mukey"], key.pos = 1)

## Looking at soil profiles
sps <- get_ssurgo_soil_profile(lonlat = c(-93.77, 42.02), nsoil = 2)
sps[[1]]$metadata$SoilType
sps[[2]]$metadata$SoilType

plot(sps[[1]], property = "Carbon")
cmp.soils <- compare_apsim_soil_profile(sps[[1]], 
                                        sps[[2]], 
                                        labels = c("Clarion", "Storden"))
plot(cmp.soils, soil.var = "Carbon")

#### Global Soil Database ISRIC/SoilGrids ####

ams.sgrds <- get_isric_soil_profile(lonlat = c(-93.77, 42.02))
plot(ams.sgrds, property = "water")
