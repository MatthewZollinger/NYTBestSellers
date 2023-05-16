# NYTBestSellers
An old R script I made to scrape info from a few New York Times best seller lists. Specifically, it scrapes the Children's Middle Grade Hardcover and Fiction lists, cleans the data up, and summarizes by how many weeks the book was on the list in the times specified.

There are three files in this repo:

-**Project Code NYTimes.R**: the original file, which I submitted as a final project for my Introduction to R Programming class. It uses the rvest library to scrape a year's worth of weekly Children's and Fiction best seller list - the last week of said year being the week that I submitted the project (February 28, 2021). It summarizes each list individually by number of weeks spent on the list, then combines them and outputs a file called "BestSellerListsCombined.csv".

-**Modified NYTimes.R**: a slightly modified version of the previous file, only this time the dates now cover the last year up to now (last day is May 14, 2023). Its output file is called "BestSellerListsCombinedMay2023.csv".

-**BestSellerListsCombinedMay2023.csv**: the final output of "ModifiedNYTimes.R". Both lists combined and sorted in descending order by number of weeks spent on a list.
