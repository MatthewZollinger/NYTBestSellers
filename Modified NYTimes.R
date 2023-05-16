library(tidyverse)
library(rvest)
library(lubridate)

# function to acquire data
nytimesdata <- function(url) {
  current_html <- read_html(url)
  
  # acquires a specific node that stores titles
  titles <- html_nodes(current_html, ".css-5pe77f") %>%
    html_text() %>%
    str_to_title() %>%
    as_tibble()
  
  # acquires a specific node that stores author/illustrator names
  authors <- html_nodes(current_html, ".css-hjukut") %>%
    html_text() %>%
    # removes first three characters ("by ") and additional words
    str_replace("...", "") %>%
    str_replace_all(" by ", "") %>%
    str_replace_all("Illustrated", "") %>%
    str_replace_all("Created", "") %>%
    str_replace_all("with ", "") %>%
    str_replace_all("\\.", "") %>%
    str_replace_all("and ", "") %>%
    as_tibble()
  
  # combines authors and titles into one table
  nytimes <- tibble(titles, authors, .name_repair = "unique") %>%
    rename(BookTitle = value...1,
           AuthorName = value...2)
}
  
# 2022/05/15 - 2023/05/14 (bestseller list is published weekly)
last_year <- seq(as.Date("2022/05/15"), as.Date("2023/05/15"), by = "week") %>%
  # so the URL works - it takes /, not -
  str_replace_all("-", "/")
last_year_childrens_urls <- str_c("https://www.nytimes.com/books/best-sellers/",
                        last_year,
                        "/childrens-middle-grade-hardcover/")
last_year_fiction_urls <- str_c("https://www.nytimes.com/books/best-sellers/",
                                  last_year,
                                  "/combined-print-and-e-book-fiction/")

# running the below function takes a minute, but it works
last_year_childrens <- map_dfr(last_year_childrens_urls, nytimesdata)
last_year_fiction <- map_dfr(last_year_fiction_urls, nytimesdata)

# Which books had the most weeks on the list?
top_childrens_books <- last_year_childrens %>%
  group_by(BookTitle, AuthorName) %>%
  summarize(ListEntries = n()) %>%
  arrange(desc(ListEntries)) %>%
  mutate(List = "Childrens")

top_fiction_books <- last_year_fiction %>%
  group_by(BookTitle, AuthorName) %>%
  summarize(ListEntries = n()) %>%
  arrange(desc(ListEntries)) %>%
  mutate(List = "Fiction")

# combine both tables
top_combined_list <- top_childrens_books %>%
  bind_rows(top_fiction_books) %>%
  arrange(desc(ListEntries))

write.csv(top_combined_list, "BestsellerListsCombinedMay2023.csv")
