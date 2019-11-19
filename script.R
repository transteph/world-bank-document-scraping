# --------------- script.r -----------------------
#
#     Winter 2019 Research Traineeship
#   
#    Stephanie Tran
# 
# --------------------------------------------------

# required packages
install.packages('car')
install.packages('rio')
install.packages('dplyr')   
install.packages('plyr')  
install.packages('openxlsx')
install.packages('readr')
install.packages('tidyverse')   
install.packages('rvest')
install.packages('stringr')   
install.packages('rebus')
install.packages('lubridate')  


# ----------------------------
#    --- SETTING UP ---
# 
#----------------------------
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


# ----------------------------------------
#
# Scrape 1/4:   WORKING PAPERS (n = 1102)
#
# ----------------------------------------


# ----------------------------------------
#   Collect page listings of reports
# ----------------------------------------


# Each page listing past the first one follows pattern of
# https://www.worldbank.org/en/topic/health/research/all?qterm=&lang_exact=English&docty_exact=Working+Paper&os=1100
# min os=20, max=1100

baseUrl <- 'https://www.worldbank.org/en/topic/health/research/all?qterm=&lang_exact=English&docty_exact=Working+Paper&os='
listOfListings <- str_c(baseUrl, seq(20,1100,20))

# First page link follows different base url. Add to listofListings vector
# https://www.worldbank.org/en/topic/health/research/all?docty_exact=Working+Paper&qterm=&lang_exact=English
listOfListings <- append(listOfListings, 'https://www.worldbank.org/en/topic/health/research/all?docty_exact=Working+Paper&qterm=&lang_exact=English')


# 
# ----------------------------------------
#   Collect links to every report page
# ----------------------------------------

# report links found within html element div.n07v4-title  
# testListing <- read_html("https://www.worldbank.org/en/topic/health/research/all?qterm=&lang_exact=English&docty_exact=Working+Paper&os=840")

# create vector of links of reports from every listing pages
allReportsLinks <- 
   listOfListings %>%
      lapply(read_html) %>%
      lapply(html_nodes,".n07v4-title a") %>%
      lapply(html_attr, 'href') %>%
      lapply(trimws) 
 
# combine all sublists in allReportsLinks (due to links being collected from each page) into one list
allReportsLinks <- unlist(allReportsLinks, recursive = FALSE)
allReportsLinks

# --------------------------------------------------------
#   Export list of links and listings into Excel file
# --------------------------------------------------------

# Create a blank workbook
OUT <- createWorkbook()

# Add some sheets to the workbook
addWorksheet(OUT, "allReportsLinks")
addWorksheet(OUT, "listOfListings")

# Write the data to the sheets
writeData(OUT, sheet = "allReportsLinks", x = allReportsLinks)
writeData(OUT, sheet = "listOfListings", x = listOfListings)

# Export the file
saveWorkbook(OUT, "all-report-links.xlsx")


# 
# -----------------------------------------------------
#   Extract report details from each report page
#
#   Details to extract: paperTitle, abstract, docDate, reportNum
#
# ----------------------------------------
# 


#
#--------------------------------------
# function: getReportInfo()
#
#----------------------

getReportInfo <- function(r_url){

# get report number
r_num <- read_html(r_url) %>%
  html_nodes("meta[name=citation_technical_report_number]")  %>%
  html_attr("content") 

#  paper title
r_title <- read_html(r_url) %>%
  html_nodes("meta[name=citation_title]")  %>%
  html_attr("content") 

#  abstract
r_abstract <- read_html(r_url) %>%
  html_nodes("#detail_abstract")  %>%
  html_text() 

# get date and time
r_date <- read_html(r_url) %>%
  html_nodes("meta[name=citation_publication_date]")  %>%
  html_attr("content") 

# Combine into a tibble
one_report <- tibble(Report_number = r_num,
                     Title = r_title,
                     Abstract = r_abstract,
                     Date = r_date, 
                     URL = r_url)
}


#-----------------------------------------------
#
# apply scrape function to all report links
#
#-----------------------------------------------


# # TEST
# 
# sampleLinks <- c(allReportsLinks[1], allReportsLinks[2], allReportsLinks[3], allReportsLinks[4])
# sampleLinks
#
# reportsTable <- map(sampleLinks, getReportInfo)
# reportsTable <- bind_rows(reportsTable) 
# reportsTable


# run function on first set of websites
reportsTable <- map_dfr(allReportsLinks[0:51], getReportInfo)
# View(reportsTable)

# write first set of websites into Excel file
write.xlsx(reportsTable, 'first-cut.xlsx')


# add next set of websites to reportsTable
reportsTable <- bind_rows(map_dfr(allReportsLinks[51:54], getReportInfo), reportsTable )

reportsTable <- bind_rows(map_dfr(allReportsLinks[54:80], getReportInfo), reportsTable )






