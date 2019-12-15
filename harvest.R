# --------------- harvest.r -----------------------
#
#     Winter 2019 Research Traineeship
#   
#     Stephanie Tran ( stephanietran.ca )
# 
# --------------------------------------------------

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
#install.packages('xml2')
install.packages('XML')

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


# 
# A.1.	Development Knowledge and Learning 
#
# retrieve document metadata from Open Knowledge Repository
a1 <- GET("https://openknowledge.worldbank.org/oai/request?verb=ListRecords&metadataPrefix=oai_dc&set=col_10986_31460")
r<-content(a1, as="parsed")
write_xml(r, "test.xml", options="format")
# see xml namespaces
# xml_ns(r)

# find records and put metadata into data table
dt <- data.table( 
  category = "Working Papers",
  subcategory = 1,
  id   = xml_find_all(r, ".//dc:identifier") %>% xml_text(),
  title = xml_find_all( r, ".//dc:title" ) %>% xml_text(),
  abstract = xml_find_all(r, ".//dc:description") %>% xml_text(),
  date  = xml_find_all(r, ".//d1:datestamp") %>% xml_text(),
  stringsAsFactors = FALSE )


# --------------------------------------------------------
#   Export into Excel file
# --------------------------------------------------------

# Create a blank workbook
OUT <- createWorkbook()

# Add some sheets to the workbook
addWorksheet(OUT, "dt")

# Write the data to the sheets
writeDataTable(OUT, sheet = 1, x = dt)

# Export the file
saveWorkbook(OUT, "abstract-collection.xlsx")





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


