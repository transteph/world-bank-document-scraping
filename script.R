# --------------- script.r -----------------------
#
#     Winter 2019 Research Traineeship
#   
#     Stephanie Tran ( stephanietran.ca )
# 
# --------------------------------------------------

# load scrape function
source("scrape-function.R")

# required packages
# install.packages('car')
# install.packages('rio')
# install.packages('dplyr')   
# install.packages('plyr')  
# install.packages('openxlsx')
# install.packages('readr')
# install.packages('tidyverse')   
# install.packages('rvest')
# install.packages('stringr')   
# install.packages('rebus')
# install.packages('lubridate')  
# install.packages('httr')
# install.packages('xml2')
# install.packages('XML')
# install.packages("oai")
install.packages('anytime')

# --------------------------------------------------
#    --- SETTING UP ---
# 
# --------------------------------------------------
library(car)    
library(rio)
library(dplyr)
library(plyr)
library(openxlsx)
library(readr)    
# General-purpose data wrangling
library(tidyverse)  
# Parsing of HTML/XML files  
library(rvest)    
# String manipulation
library(stringr)   
# Verbose regular expressions
library(rebus)     
# Eases DateTime manipulation
library(lubridate)
library(data.table)
library(httr)
library(xml2)
library(XML)
library(purrr)
library(ggplot2)
library(anytime)
# --------------------------------------------------
#
#         --- DOCUMENTS TO SCRAPE --- 
#
#   A) Working Papers ( https://openknowledge.worldbank.org/handle/10986/8 )
#    n =  10191
#     1.	Development Knowledge and Learning 
#     2.	ESMAP papers 
#     3.	Extractive Industries for Development 
#     4.	Global Partnership for Education WP Series on Learning 
#     5.	Health, Nutrition and Population (HNP) Discussion Papers 
#     6.	Justice and Development Working Paper Series 
#     7.	Other papers 
#     8.	Policy Research Notes 
#     9.	Policy Research Working Papers 
#     10.	Social Protection and Jobs Discussion Papers 
#     11.	South Asia Human Development Sector Discussion Papers 
#     12.	SSA Transport Policy Program Papers .
#     13.	Transport Papers 
#     14.	UNICO Studies Series 
#     15.	Water and Sanitation Program 
#     16.	Water Papers 
#     17.	World Development Report Background Papers
#
#   B) Technical Papers ( https://openknowledge.worldbank.org/handle/10986/18022 )
#   n = 574
#
#   C) Speeches of World Bank presidents ( https://openknowledge.worldbank.org/handle/10986/24239)
#     n = 238
#
# --------------------------------------------------

#     Varaibles for url components 
# base url for query 
base <- "https://openknowledge.worldbank.org/oai/request?verb=ListRecords&metadataPrefix=oai_dc&set=col_10986_"

# base url with resumption token
base0 <- "https://openknowledge.worldbank.org/oai/request?verb=ListRecords&resumptionToken=oai_dc///col_10986_"

# Create a blank workbook
OUT <- createWorkbook()

cat <- 1
# --------------------------------------------------
# A.1.	Development Knowledge and Learning (n=3)
# --------------------------------------------------

# id of subcategory
temp_id <- "31460"

# scrape through listings and create data table a1
a1 <- createDT('a', cat,  1, base, base0, temp_id, 3)

# --------------------------------------------------
# A.2.	ESMAP papers (n=364)
# --------------------------------------------------

# id of subcategory
temp_id <- "17456"
# scrape through listings and create data table a2
a2 <- createDT('a', cat,  2, base, base0, temp_id, 364)

# --------------------------------------------------
# A.3.	Extractive Industries for Development (n=37)
# --------------------------------------------------

# id of subcategory
temp_id <- "16297"

# scrape through listings and create data table a3
a3 <- createDT('a', cat,  3, base, base0, temp_id, 37)

# --------------------------------------------------
# A.4.		Global Partnership for Education WP Series on Learning (n=11)
# --------------------------------------------------

# id of subcategory
temp_id <- "16245"
# scrape through listings and create data table a4
a4 <- createDT('a', cat,  4, base, base0, temp_id, 11)

# --------------------------------------------------
# A.5.	Health, Nutrition and Population (HNP) (n=349)
# --------------------------------------------------

# id of subcategory
temp_id <- "12995"

# scrape through listings and create data table a4
a5 <- createDT('a', cat,  5, base, base0, temp_id, 349)

# --------------------------------------------------
# A.6.		Justice and Development (n=39)
# --------------------------------------------------

# id of subcategory
temp_id <- "16599"

# scrape through listings and create data table a6
a6 <- createDT('a', cat,  6, base, base0, temp_id, 39)

# --------------------------------------------------
# A.7.		Other papers (n=1630)
# --------------------------------------------------

# id of subcategory
temp_id <- "11866"

# scrape through listings and create data table a7
a7 <- createDT('a', cat,  7, base, base0, temp_id, 1631)

# --------------------------------------------------
# A.8.	Policy Research Notes (n=4)
# --------------------------------------------------

# id of subcategory
temp_id <- "24267"

a8 <- createDT('a', cat,  8, base, base0, temp_id, 4)

# --------------------------------------------------
# A.9.Policy Research Working Papers (n=6804)
# --------------------------------------------------

# id of subcategory
temp_id <- "9"

a9<- createDT('a', cat,  9, base, base0, temp_id, 6804)

# --------------------------------------------------
# A.10. Social Protection and Jobs Discussion Papers (n=153)
# --------------------------------------------------

# id of subcategory
temp_id <- "13084"

a10 <- createDT('a', cat,  10, base, base0, temp_id, 153)


# --------------------------------------------------
# A.11. South Asia Human Development Sector  (n=64)
# --------------------------------------------------

# id of subcategory
temp_id <- "16283"

a11 <- createDT('a', cat,  11, base, base0, temp_id, 64)


# --------------------------------------------------
# A.12. SSA Transport Policy Program 
# --------------------------------------------------

# number of documents
n = 38

# id of subcategory
temp_id <- "16282"

a12 <- createDT('a', cat,  12, base, base0, temp_id, n)

# --------------------------------------------------
# A.13. Transport Papers
# --------------------------------------------------
subcat_id <- 13

# number of documents
n <- 71

# id of subcategory
temp_id <- "16994"

a13 <- createDT('a', cat,  subcat_id, base, base0, temp_id, n)

# --------------------------------------------------
# A.14. UNICO Studies Series
# --------------------------------------------------
subcat_id <- 14

n <- 39

temp_id <- "13083"

a14 <- createDT('a', cat,  subcat_id, base, base0, temp_id, n)

# --------------------------------------------------
# A.15. Water and Sanitation Program
# --------------------------------------------------
subcat_id <- 15
n <- 117
temp_id <- "16996"
a15 <- createDT('a', cat,  subcat_id, base, base0, temp_id, n)


# --------------------------------------------------
# A.16. Water Papers
# --------------------------------------------------
subcat_id <- 16
n <- 127
temp_id <- "16997"
a16 <- createDT('a', cat,  subcat_id, base, base0, temp_id, n)


# --------------------------------------------------
# A.17. World Development Report Background Papers
# --------------------------------------------------
subcat_id <- 17
n <- 366
temp_id <- "7735"
a17 <- createDT('a', cat,  subcat_id, base, base0, temp_id, n)

# --------------------------------------------------------
#   Combine working paper tables
# --------------------------------------------------------

working_papers <- rbind(a1, a2, a3, a4, a5, a6, a7, a8, a9,
                         a10, a11, a12, a13, a14, a15, a16, a17,
                         fill=TRUE)

# Add some sheets to the workbook
addWorksheet(OUT, "Working Papers")

# Write the data to the sheets
writeDataTable(OUT, sheet =  "Working Papers", x = working_papers)
saveWorkbook(OUT, "Working Papers0.xlsx")


# ------------------------------------------------------------------------------------
#
#
#  Technical Papers ( https://openknowledge.worldbank.org/handle/10986/18022 )
#  Speeches of World Bank presidents ( https://openknowledge.worldbank.org/handle/10986/24239)
#
# -------------------------------------------------------------------------------------
cat <- 2
# --------------------------------------------------
# B.1. Carbon Pricing Leadership Coalition Reports
# --------------------------------------------------
subcat_id <- 1
n <- 5
temp_id <- "32456"
b1 <- createDT('b', cat,  subcat_id, base, base0, temp_id, n)

# --------------------------------------------------
# B.2.	East Asia and Pacific Clean Stove Initiative
# --------------------------------------------------
subcat_id <- 2
n <- 7
temp_id <- "18024"
b2 <- createDT('b', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# B.3.	Enterprise Surveys
# --------------------------------------------------
subcat_id <- 3
n <- 157
temp_id <- "20825"
b3 <- createDT('b', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# B.4.	Environment Department Papers
# --------------------------------------------------
subcat_id <- 4
n <- 51
temp_id <- "18025"
b4 <- createDT('b', cat,  subcat_id, base, base0, temp_id, n)

# --------------------------------------------------
# B.5.	LAC Occasional Paper Series
# --------------------------------------------------
subcat_id <- 5
n <- 17
temp_id <- "18023"
b5 <- createDT('b', cat,  subcat_id, base, base0, temp_id, n)

# --------------------------------------------------
# B.6.	Partnership for Market Readiness Technical Papers
# --------------------------------------------------
subcat_id <- 6
n <- 29
temp_id <- "21357"
b6 <- createDT('b', cat,  subcat_id, base, base0, temp_id, n)

# --------------------------------------------------
# B.7.	Systems Approach for Better Education Results (SABER)
# --------------------------------------------------
subcat_id <- 7
n <- 274
temp_id <- "18026"
b7 <- createDT('b', cat,  subcat_id, base, base0, temp_id, n)

# --------------------------------------------------
# B.8.	Urban Development Series Knowledge Papers
# --------------------------------------------------
subcat_id <- 8
n <- 19
temp_id <- "18027"
b8 <- createDT('b', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# B.9.	Water Sector Board DPs
# --------------------------------------------------
subcat_id <- 9
n <- 16
temp_id <- "18028"
b9 <- createDT('b', cat,  subcat_id, base, base0, temp_id, n)

# -----------------------------------------------------------------
#
#  Speeches of World Bank presidents 
# ( https://openknowledge.worldbank.org/handle/10986/24239 )
#
# -----------------------------------------------------------------
cat <- 3
# --------------------------------------------------
# C.1.	Speeches by David R. Malpass
# --------------------------------------------------
subcat_id <- 1
n <- 3
temp_id <- "32342"
c1 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)

# --------------------------------------------------
# C.2.	Speeches by Jim Yong Kim
# --------------------------------------------------
subcat_id <- 2
n <- 94
temp_id <- "24240"
c2 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# C.3.	Speeches by Robert B. Zoellick
# --------------------------------------------------
subcat_id <- 3
n <- 20
temp_id <- "24241"
c3 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# C.4.	Speeches by Paul Wolfowitz
# --------------------------------------------------
subcat_id <- 4
n <- 34
temp_id <- "24242"
c4 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# C.5.	Speeches by James D. Wolfensohn
# --------------------------------------------------
subcat_id <- 5
n <- 36
temp_id <- "24243"
c5 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# C.6.	Speeches by Lewis Preston
# --------------------------------------------------
subcat_id <- 6
n <- 1
temp_id <- "24244"
c6 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# C.7.	Speeches by Barber Conable
# --------------------------------------------------
subcat_id <- 7
n <- 4
temp_id <- "24245"
c7 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# C.8.	Speeches by Alden W. Clausen
# --------------------------------------------------
subcat_id <- 8
n <- 4
temp_id <- "24246"
c8 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# C.9.	Speeches by Robert S. McNamara
# --------------------------------------------------
subcat_id <- 9
n <- 3
temp_id <- "24247"
c9 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# C.10.	Speeches by George Woods
# --------------------------------------------------
subcat_id <- 10
n <- 7
temp_id <- "31682"
c10 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# C.11.	Speeches by Eugene R. Black
# --------------------------------------------------
subcat_id <- 11
n <- 23
temp_id <- "31683"
c11 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# C.12.	Speeches by John J. McCloy
# --------------------------------------------------
subcat_id <- 12
n <- 9
temp_id <- "31684"
c12 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)
# --------------------------------------------------
# C.13.	Speeches by Eugene Meyer 
# --------------------------------------------------
subcat_id <- 13
n <- 3
temp_id <- "31685"
c13 <- createDT('c', cat,  subcat_id, base, base0, temp_id, n)

# --------------------------------------------------------
#   Combine  tables
# --------------------------------------------------------


technical_papers <- rbind(b1, b2, b3, b4, b5, b6, b7, b8, b9,
                         fill=TRUE)
addWorksheet(OUT, "Technical Papers")
writeDataTable(OUT, sheet = "Technical Papers", x = technical_papers)



speeches <- rbind(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, 
                  c11, c12, c13,
                          fill=TRUE)
addWorksheet(OUT, "Speeches")
writeDataTable(OUT, sheet = "Speeches", x = speeches)


# # make xlsx files for each type
write.xlsx(technical_papers, "Technical Papers.xlsx")
write.xlsx(speeches, "Speeches.xlsx")

combined_papers <- rbind(a1, a2, a3, a4, a5, a6, a7, a8, a9,
                         a10, a11, a12, a13, a14, a15, a16, a17,
                         b1, b2, b3, b4, b5, b6, b7, b8, b9,
                         c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, 
                         c11, c12, c13,
                         fill=TRUE)

# # --------------------------------------------------------
# #   Export into Excel file
# # --------------------------------------------------------


All <- createWorkbook()

addWorksheet(All, "all")
writeDataTable(All, sheet = "all", x = combined_papers)
addWorksheet(All, "Working Papers")
writeDataTable(All, sheet =  "Working Papers", x = working_papers)
addWorksheet(All, "Technical Papers")
writeDataTable(All, sheet = "Technical Papers", x = technical_papers)
addWorksheet(All, "Speeches")
writeDataTable(All, sheet = "Speeches", x = speeches)

# export to file
saveWorkbook(All, "all-papers-final.xlsx")


# ------------------------------------------------------------------
#
#     Data Analysis
#
# ------------------------------------------------------------------

all <- copy(combined_papers)
max(all$date) #  "2020"
min(all$date) # "1946-09-30"

all$date <- anydate(all$date)  

date_plot <- ggplot(all, aes(as.numeric(year(date)),fill = category)) +
  geom_bar(stat="count", position = "dodge") + 
  scale_fill_brewer(palette = "Set1") 
