# Please uncomment the next line if you do not have the WikidataQueryServiceR package installed.
# install.packages('WikidataQueryServiceR')
library(WikidataQueryServiceR)

query <- 'SELECT DISTINCT ?compound ?smiles ?isosmiles WHERE {
  	?compound wdt:P233 | wdt:P2017 [] .
  	OPTIONAL { ?compound wdt:P233 ?smiles }
  	OPTIONAL { ?compound wdt:P2017 ?isosmiles }
	}'

results <- query_wikidata(query)

write.table(results, file = "compounds_from_query.tsv", sep = "\t", row.names = FALSE, quote = FALSE)
