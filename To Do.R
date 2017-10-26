#To Do - Make the scraper work on the web automatically (look at what ol' mate survey dude did)
all.games <- read_html("https://afltables.com/afl/stats/biglists/bg3.txt")
attendances <- read_html("https://afltables.com/afl/crowds/summary.html")
table <- html_table(attendances)
more.table <- table[[1]]