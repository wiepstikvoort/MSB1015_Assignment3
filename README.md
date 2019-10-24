# MSB1015_Assignment3
## Welcome!
Welcome to the repository of Assignment 3 for the course MSB1015 'Scientific Programming' 2019, taught at Maastricht University. The assignment was to use Nextflow, and compare the running times of the code between using different numbers of threads.

## Goal of the project
The goals was to gather information on the difference in running times of a piece of code, when the computing is parallelized or not parallelized. Parallelization means that multiple threads on your computer can work at the same time. In this case, multiple threads can work on different smiles and calculate the JPlogP values. Doing this one by one, on one thread, would logically increase the running time of the code. 

## Set up of methods
The compounds in the compounds_from_query.tsv file, are retrieved through the SPARQL query that can be found in the compounds_from_query.R.  

The query searches for any compounds that have either a SMILES (P233) or an isoSMILES (P2017) on wikidata. The url to the wikidata page of the compound is in the same row as the SMILES and/or the isoSMILES. There should not be any compounds that have neither a SMILES or an isoSMILES, because the query is set up in a way that it searches for SMILES and isoSMILES and then links the compound url to that and not the other way around.  

This assignment has a focus on parallelization. The parallelizing of different processes at once is set inside the channel (please see calculatingJPlogPs.nf). The buffer splits the rows of the compounds_from_query.tsv file into sets of size: x. If x = 1, then the code is unparallelized, because the sets (which in this case is equal to the rows) are used as input for the process one by one. If x = 2, the sets have size 2, therefore there can be two processes at once. However, how many processes can be run at the same time, depends on the number of thread a computer has. If you have 12 threads, then it can handle 12 processes at once. If you have 4 threads, it can handle 4 processes etc.  


## How to run the code

## Results

This part will contain information and screenshots of the running times.

| Size of set | Running time |
|-------------|--------------|
| 1           | 7m 6s        |
| 2           | 4m 59s       |
| 4           | 3m 8s        |
| 8           | 2m 16s       |
| 20          | 1m 39s       |
| 100,000     | 2m 20s       |

## Sources used for template code
Egon Willighagen and Martina Summer-Kutmon provided template code that were essential for the running of the code.

To find more information on the config file, usage, and template code, please visit:  
https://www.nextflow.io/docs/latest/config.html

To find information and template code for the SPARQL query, please visit:  
https://cran.r-project.org/web/packages/WikidataQueryServiceR/WikidataQueryServiceR.pdf
(used documentation version: 0.1.1)

To find more information on how to use, and which methods the descriptor contains, please visit:  
http://cdk.github.io/cdk/latest/docs/api/org/openscience/cdk/qsar/descriptors/molecular/JPlogPDescriptor.html


## List of author(s)
Wiep Stikvoort
