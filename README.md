# Anedot Ruby Gem API project

## Goals
- Complete the project in under 4 hours. 
- Take incomplete requirements and build a prototype.
- Use dependencies to parse an HTML Craigslist Webpage.

##Dependencies
- Git
- Bundler
- Ruby 2.5.3 or greater
- Nokogiri 

## Steps - *Commit after each step*
1. Initialize a new .git repository with this readme
2. Create a basic cl_reader.rb which includes dependencies
3. Parse https://seattle.craigslist.org/search/cta?format=rss&query=jeep and print raw results
4. Print each item in the format Date - Title
5. Use a regular expression to extract model year to print each line: Model Year - Date - Title
6. Total any dollar amounts and print result
7. Calculate tax of 8.9% on total dollar amount
8. use `git bundle create your_name.bundle master` and respond to this email with bundle attached
