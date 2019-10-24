# MSB1015_Assignment3
## Welcome!
Welcome to the repository of Assignment 3 for the course MSB1015 'Scientific Programming' 2019, taught at Maastricht University. The assignment was to use Nextflow, and compare the running times of the code between using different numbers of threads.

## Goal of the project
The goals was to gather information on the difference in running times of a piece of code, when the computing is parallelized or not parallelized. Parallelization means that multiple threads on your computer can work at the same time. In this case, multiple threads can work on different smiles and calculate the JPlogP values. Doing this one by one, on one thread, would logically increase the running time of the code.  
The JPlogP is an improved logP predictor, as compared to older methods [1]. The logP value says something about the partition coefficient, which describes the hydrofobicity of a compound. 

[1] Plante J, Werner S. JPlogP: an improved logP predictor trained using predicted data. Journal of Cheminformatics. 2018;10(1):61.

## Set up of methods
The compounds in the compounds_from_query.tsv file, are retrieved through the SPARQL query that can be found in the compounds_from_query.R. 

The query searches for any compounds that have either a Simplified Molecular-Input Line-Entry Specification, a.k.a. SMILES, (P233) or an isomeric SMILES, a.k.a. isoSMILES, (P2017) on wikidata. The url to the wikidata page of the compound is in the same row as the SMILES and/or the isoSMILES. There should not be any compounds that have neither a SMILES or an isoSMILES, because the query is set up in a way that it searches for SMILES and isoSMILES and then links the compound url to that and not the other way around.  

This assignment has a focus on parallelization. The parallelizing of different processes at once is set inside the channel (please see calculatingJPlogPs.nf). The buffer splits the rows of the compounds_from_query.tsv file into sets of size: x. If x = 1, then the code is unparallelized, because the sets (which in this case is equal to the rows) are used as input for the process one by one. If x = 2, the sets have size 2, therefore there can be two processes at once. However, how many processes can be run at the same time, depends on the number of thread a computer has. If you have 12 threads, then it can handle 12 processes at once. If you have 4 threads, it can handle 4 processes etc.  

#### Pseudocode 
The pseudocode for calculatingJPlogPs.nf
- Setting up the channel, including the buffer that defines the set size
- Setting up the process
- Input for the process is set by set
- Setting up which entry from the set is the wikidata url, the SMILES and the isoSMILES
- Defining cdk as a new CDKManager
- Set up a try-catch to parse the SMILES
- Retrieve an IAtomContainer Object from the parsed SMILES and calculate the JPlogP value
- Set up an if statement that calculates the JPlogP values in the same manner with the isoSMILES, when the SMILES returned an NaN
- In that same if statement print that you are using the isoSMILES as a sort of checkpoint
- Print the JPlogP values

Make sure that your file that contains the compounds is in the same directory as the main file that uses the compounds and (iso)SMILES. 
Further documentation on the code can be found in the comments in calculatingJPlogPs.nf. 

## How to run the code
Download the ZIP folder. Or download the calculatingJPlogPs.nf and compounds_from_query.tsv and save them in the same directory. Then run the calculingJPlogPs.nf on a linux command line (either your computer command line, or a linux subsystem command line). The JPlogPs are then printed on the command line. Make sure that Nextflow is loaded on the linux (sub)system to be able to run the file. 

To run the query, please run the compounds_from_query.R file in R or Rstudio. 

## Results
Running the code with different set sizes, will output different running times. The results can be found in table 1.

| Size of set | Running time |
|-------------|--------------|
| 1           | 7m 6s        |
| 2           | 4m 59s       |
| 4           | 3m 8s        |
| 8           | 2m 16s       |
| 20          | 1m 39s       |
| 100,000     | 2m 20s       |
###### Table 1 - Results from the running of calculatingJPlogPs.nf with different set sizes

It can be seen that the running time decreases as the set size increases. As explained in the Set up of methods section, this is what would be expected. As the computer is allowed to run more processes at once, it will do so, which will decrease the running time. The only thing which seems unexpected is the increase in running time between set sizes 20 and 100,000. The set size of 100,000 should give the computer a 'free will' on what it wants to do with the processes, as it can do as many processes at once as it wants to. However, it might be that other processes were already occupying the threads, and therefore the running time for the biggest set size is higher then for a set size of 20.  
  
Another unexpected find was the 0.0 values for the JPlogP when the isoSMILES was used instead of the SMILES. This can be due to the used descriptor (JPlogPDescriptor). It might be that the descriptor cannot deal with isoSMILES and will therefore return 0.0 as JPlogP.

## Sources used for template code
Egon Willighagen and Martina Summer-Kutmon provided template code that were essential for the running of the code.

To find more information on the config file, usage, and template code, please visit:  
https://www.nextflow.io/docs/latest/config.html

To find information and template code for the SPARQL query, please visit:  
https://cran.r-project.org/web/packages/WikidataQueryServiceR/WikidataQueryServiceR.pdf
(used documentation version: 0.1.1)

To find more information on how to use, and which methods the descriptor contains, please visit:  
http://cdk.github.io/cdk/latest/docs/api/org/openscience/cdk/qsar/descriptors/molecular/JPlogPDescriptor.html

The following book was used for template code, as well as information on the logP value and its meaning:
https://egonw.github.io/cdkbook/


## List of author(s)
Wiep Stikvoort
