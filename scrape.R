# function to scrape metadata

# createDT
# Returns data table with meta data of all docs within subcategory
#
# base = base URL
# base0 = base URL with renumeration token
# subid = subcategory id
# n = number of total docs

createDT <- function (subcat, base, base0, subid, n) {
  
  temp_url <- paste0(base, subid)
  
  # retrieve metadata first 100 docs
  rr <- GET(temp_url)
  rr <-content(rr, as="parsed")
  
  # each page lists 100, so find how many pages to look through
  num_cycles <- (ceiling(n / 100) - 1)
 # print(paste("num_cycles:", num_cycles))
  
  # url for queries past first 100 docs
  temp_url0 <- paste0(base0, subid)
  
  # cycle through rest of listings 
  # return list of metadata from each page
  for (pp in 1:num_cycles){
      # print(paste("cycle #", pp))
      pg_num = pp * 100
     # print(paste("pg_num:", pg_num))
      
      s <- GET(paste0(temp_url0, "/", pg_num))
    #  print(paste("url:", paste0(temp_url0, "/", pg_num)))
      s <-content(s, as="parsed")
      
      to_add <- xml_children(s)
      
      query <- for (child in to_add) {
        xml_add_child(rr, child)
      }
  }

# check length of id
r_id <-  xml_find_all(rr, ".//d1:identifier") %>% xml_text()
l <- length(r_id)
print(paste("length of total list:", l))

# put metadata into data table
z_category = "Working Papers"
z_id   = xml_find_all(rr, ".//d1:identifier") %>% xml_text()
z_title = xml_find_all(rr, ".//dc:title" ) %>% xml_text()
z_abstract = xml_find_all(rr, ".//dc:description") %>% xml_text() %>% str_squish()
z_date  = xml_find_all(rr, ".//d1:datestamp") %>% xml_text()


a <- data.table( 
  "category" = z_category,
  "subcategory" = subcat,
  'id' = z_id[1:l],
  'title' = z_title[1:l],
  'abstract'= z_abstract[1:l],
  'date'  = z_date[1:l],
  stringsAsFactors = FALSE )

print(paste("blank cells:", sum(is.na(a))))

return (a)

}

