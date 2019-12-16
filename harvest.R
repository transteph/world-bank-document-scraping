# --------------- harvest.r -----------------------
#
#     Winter 2019 Research Traineeship
#   
#     Stephanie Tran ( stephanietran.ca )
# 
# --------------------------------------------------

# load scrape function
source("scrape.R")

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


# --------------------------------------------------
# A.1.	Development Knowledge and Learning (n=3)
# --------------------------------------------------

# retrieve document metadata from Open Knowledge Repository
r <- GET("https://openknowledge.worldbank.org/oai/request?verb=ListRecords&metadataPrefix=oai_dc&set=col_10986_31460")
r <- content(r, as="parsed")


#write_xml(r, "r.xml", options="format")
# see xml namespaces
# xml_ns(r)
abstract = xml_find_all(r, ".//dc:description") %>% xml_text() %>% str_squish()
# find records and put metadata into data table
a1 <- data.table( 
  category = "Working Papers",
  subcategory = 1,
  "id"   = xml_find_all(r, ".//d1:identifier") %>% xml_text(),
  title = xml_find_all(r, ".//dc:title" ) %>% xml_text(),
  "abstract" = abstract,
  date  = xml_find_all(r, ".//d1:datestamp") %>% xml_text(),
  stringsAsFactors = FALSE )

# Create a blank workbook
OUT <- createWorkbook()

# Add some sheets to the workbook
addWorksheet(OUT, "a1")

# Write the data to the sheets
writeDataTable(OUT, sheet = "a1", x = a1)


# --------------------------------------------------
# A.2.	ESMAP papers (n=364)
# --------------------------------------------------
#     parse url components 
# base url for query 
base <- "https://openknowledge.worldbank.org/oai/request?verb=ListRecords&metadataPrefix=oai_dc&set=col_10986_"

# base url with resumption token
base0 <- "https://openknowledge.worldbank.org/oai/request?verb=ListRecords&resumptionToken=oai_dc///col_10986_"

# id of subcategory
temp_id <- "17456"
temp_url <- paste0(base, temp_id)

# url for queries past first 100 docs
temp_url0 <- paste0(base0, temp_id)

# retrieve metadata first 100 docs
r0 <- GET(temp_url)
r0 <-content(r0, as="parsed")
# first 100 docs of a2 parsed.

# retrieve metadata of rest of docs

# r1 <- GET("https://openknowledge.worldbank.org/oai/request?verb=ListRecords&resumptionToken=oai_dc///col_10986_17456/100")
r1 <- GET(paste0(temp_url0, "/100"))
r1 <-content(r1, as="parsed")

r2 <- GET(paste0(temp_url0, "/200"))
r2 <-content(r2, as="parsed")

r3 <- GET(paste0(temp_url0, "/300"))
r3 <-content(r3, as="parsed")

# variable rx to hold combined scrapes
rx <- r0

# combine all queries into r0
to_add <- xml_children(r1)
for (child in to_add) {
  xml_add_child(rx, child)
}

to_add <- xml_children(r2)
for (child in to_add) {
  xml_add_child(rx, child)
}

to_add <- xml_children(r3)
for (child in to_add) {
  xml_add_child(rx, child)
}

# *** Not all metadata is present for each record. Using fixed loop
# *** to make sure lengths of columns are the same

# check length of id
r_id <-  xml_find_all(rx, ".//d1:identifier") %>% xml_text()
i <- length(r_id)


# put metadata into data table
category = "Working Papers"
subcategory = 2
id   = xml_find_all(rx, ".//d1:identifier") %>% xml_text()
title = xml_find_all(rx, ".//dc:title" ) %>% xml_text()
abstract = xml_find_all(rx, ".//dc:description") %>% xml_text() %>% str_squish()
date  = xml_find_all(rx, ".//d1:datestamp") %>% xml_text()

a2 <- data.table( 
  "category" = category,
  "subcategory" = subcategory,
  'id' = id[1:i],
  'title' = title[1:i],
  'abstract'= abstract[1:i],
  'date'  = date[1:i],
  stringsAsFactors = FALSE )


# Add some sheets to the workbook
addWorksheet(OUT, "a2")

# Write the data to the sheets
writeDataTable(OUT, sheet = "a2", x = a2)


# --------------------------------------------------
# A.3.	Extractive Industries for Development (n=37)
# --------------------------------------------------

# id of subcategory
temp_id <- "16297"
temp_url <- paste0(base, temp_id)

# url for queries past first 100 docs
temp_url0 <- paste0(base0, temp_id)

# retrieve metadata first 100 docs
r0 <- GET(temp_url)
r0 <-content(r0, as="parsed")

# check length of id
r_id <-  xml_find_all(r0, ".//d1:identifier") %>% xml_text()
i <- length(r_id)


# put metadata into data table
category = "Working Papers"
subcategory = 3
id   = xml_find_all(r0, ".//d1:identifier") %>% xml_text()
title = xml_find_all(r0, ".//dc:title" ) %>% xml_text()
abstract = xml_find_all(r0, ".//dc:description") %>% xml_text() %>% str_squish()
date  = xml_find_all(r0, ".//d1:datestamp") %>% xml_text()

a3 <- data.table( 
  "category" = category,
  "subcategory" = subcategory,
  'id' = id[1:i],
  'title' = title[1:i],
  'abstract'= abstract[1:i],
  'date'  = date[1:i],
  stringsAsFactors = FALSE )

# Add some sheets to the workbook
addWorksheet(OUT, "a3")

# Write the data to the sheets
writeDataTable(OUT, sheet = "a3", x = a3)

# --------------------------------------------------
# A.4.		Global Partnership for Education WP Series on Learning (n=11)
# --------------------------------------------------

# id of subcategory
temp_id <- "16245"
temp_url <- paste0(base, temp_id)

# url for queries past first 100 docs
temp_url0 <- paste0(base0, temp_id)

# retrieve metadata first 100 docs
r0 <- GET(temp_url)
r0 <-content(r0, as="parsed")

# check length of id
r_id <-  xml_find_all(r0, ".//d1:identifier") %>% xml_text()
i <- length(r_id)


# put metadata into data table
category = "Working Papers"
subcategory = 4
id   = xml_find_all(r0, ".//d1:identifier") %>% xml_text()
title = xml_find_all(r0, ".//dc:title" ) %>% xml_text()
abstract = xml_find_all(r0, ".//dc:description") %>% xml_text() %>% str_squish()
date  = xml_find_all(r0, ".//d1:datestamp") %>% xml_text()

a4 <- data.table( 
  "category" = category,
  "subcategory" = subcategory,
  'id' = id[1:i],
  'title' = title[1:i],
  'abstract'= abstract[1:i],
  'date'  = date[1:i],
  stringsAsFactors = FALSE )

# Add some sheets to the workbook
addWorksheet(OUT, "a4")

# Write the data to the sheets
writeDataTable(OUT, sheet = "a4", x = a4)

# --------------------------------------------------
# A.5.	Health, Nutrition and Population (HNP) (n=349)
# --------------------------------------------------

# id of subcategory
temp_id <- "12995"
temp_url <- paste0(base, temp_id)

# url for queries past first 100 docs
temp_url0 <- paste0(base0, temp_id)

# retrieve metadata first 100 docs
r0 <- GET(temp_url)
r0 <-content(r0, as="parsed")

r1 <- GET(paste0(temp_url0, "/100"))
r1 <-content(r1, as="parsed")

r2 <- GET(paste0(temp_url0, "/200"))
r2 <-content(r2, as="parsed")

r3 <- GET(paste0(temp_url0, "/300"))
r3 <-content(r3, as="parsed")

# variable rx to hold combined scrapes
rx <- r0

# combine all queries into r0
to_add <- xml_children(r1)
for (child in to_add) {
  xml_add_child(rx, child)
}

to_add <- xml_children(r2)
for (child in to_add) {
  xml_add_child(rx, child)
}

to_add <- xml_children(r3)
for (child in to_add) {
  xml_add_child(rx, child)
}

# *** Not all metadata is present for each record. Using fixed loop
# *** to make sure lengths of columns are the same

# check length of id
r_id <-  xml_find_all(rx, ".//d1:identifier") %>% xml_text()
i <- length(r_id)
i


# put metadata into data table
category = "Working Papers"
subcategory = 5
id   = xml_find_all(rx, ".//d1:identifier") %>% xml_text()
title = xml_find_all(rx, ".//dc:title" ) %>% xml_text()
abstract = xml_find_all(rx, ".//dc:description") %>% xml_text() %>% str_squish()
date  = xml_find_all(rx, ".//d1:datestamp") %>% xml_text()

a5 <- data.table( 
  "category" = category,
  "subcategory" = subcategory,
  'id' = id[1:i],
  'title' = title[1:i],
  'abstract'= abstract[1:i],
  'date'  = date[1:i],
  stringsAsFactors = FALSE )

# combine all
# combined_papers <- rbind(a1, a2, fill=TRUE)
# Add some sheets to the workbook
addWorksheet(OUT, "a5")

# Write the data to the sheets
writeDataTable(OUT, sheet = "a5", x = a5)

# --------------------------------------------------
# A.6.		Justice and Development (n=39)
# --------------------------------------------------

# id of subcategory
temp_id <- "16599"
temp_url <- paste0(base, temp_id)

# url for queries past first 100 docs
temp_url0 <- paste0(base0, temp_id)

# retrieve metadata first 100 docs
r0 <- GET(temp_url)
r0 <-content(r0, as="parsed")

# check length of id
r_id <-  xml_find_all(r0, ".//d1:identifier") %>% xml_text()
i <- length(r_id)
i

# put metadata into data table
category = "Working Papers"
subcategory = 6
id   = xml_find_all(r0, ".//d1:identifier") %>% xml_text()
title = xml_find_all(r0, ".//dc:title" ) %>% xml_text()
abstract = xml_find_all(r0, ".//dc:description") %>% xml_text() %>% str_squish()
date  = xml_find_all(r0, ".//d1:datestamp") %>% xml_text()

a6 <- data.table( 
  "category" = category,
  "subcategory" = subcategory,
  'id' = id[1:i],
  'title' = title[1:i],
  'abstract'= abstract[1:i],
  'date'  = date[1:i],
  stringsAsFactors = FALSE )

# Add some sheets to the workbook
addWorksheet(OUT, "a6")

# Write the data to the sheets
writeDataTable(OUT, sheet = "a6", x = a6)

# --------------------------------------------------
# A.7.		Other papers (n=1630)
# --------------------------------------------------

# id of subcategory
temp_id <- "11866"

# scrape through listings and create data table a7
a7 <- createDT(7, base, base0, temp_id, 1631)

# Add some sheets to the workbook
addWorksheet(OUT, "a7")

# Write the data to the sheets
writeDataTable(OUT, sheet = "a7", x = a7)
# --------------------------------------------------------
#   Export into Excel file
# --------------------------------------------------------

# Export the file
saveWorkbook(OUT, "temp1.xlsx")

# # run function on first set of websites
# reportsTable <- map_dfr(a1_links, getReportInfo)
# # View(reportsTable)
# 
# # write first set of websites into Excel file
# write.xlsx(reportsTable, 'first-cut.xlsx')
# 
# 
# # add next set of websites to reportsTable
# reportsTable <- bind_rows(map_dfr(allReportsLinks[51:54], getReportInfo), reportsTable )
# 
# reportsTable <- bind_rows(map_dfr(allReportsLinks[54:80], getReportInfo), reportsTable )
# 
# 
# 
# 


