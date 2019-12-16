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
  
  # url for queries past first 100 docs
  temp_url0 <- paste0(base0, temp_id)
  
  # retrieve metadata first 100 docs
  r0 <- GET(temp_url)
  r0 <-content(r0, as="parsed")

  
  # each page lists 100, so find how many pages to look through
  num_cycles <- (ceiling(n / 100) - 1)
  print(paste("num_cycles:", num_cycles))
  
  
  # cycle through rest of listings 
  # return list of metadata from each page
  for (pp in 1:num_cycles){
    print(paste("cycle #", pp))
    
      pg_num = pp * 100
      print(paste("pg_num:", pg_num))
      
      s <- GET(paste0(temp_url0, "/", pg_num))
      s <-content(s, as="parsed")
      
      print(paste(pp, "Is S na?", is.na(s)))
      
      to_add <- xml_children(s)
      
      query <- for (child in to_add) {
        xml_add_child(r0, child)
      }
  }

# check length of id
r_id <-  xml_find_all(r0, ".//d1:identifier") %>% xml_text()
l <- length(r_id)


a <- data.table( 
  "category" = category,
  "subcategory" = subcategory,
  'id' = id[1:l],
  'title' = title[1:l],
  'abstract'= abstract[1:l],
  'date'  = date[1:l],
  stringsAsFactors = FALSE )

return (a)

}

