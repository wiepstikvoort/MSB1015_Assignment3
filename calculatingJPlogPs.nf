#!/usr/bin/env nextflow

@Grab(group='io.github.egonw.bacting', module='managers-cdk', version='0.0.9')
@Grab(group='org.openscience.cdk', module='cdk-qsarmolecular', version='2.3')

import net.bioclipse.managers.CDKManager
import org.openscience.cdk.qsar.descriptors.molecular.JPlogPDescriptor
import org.openscience.cdk.interfaces.IAtomContainer


/* The channel sets the path to use as input the compounds_from_query.tsv file. This is the file 
* that contains all compounds with their smiles and/or isosmiles. The header tells the file what the
* names of the columns are, and the tuple sets the different columns to wikidata, smiles or 
* isosmiles per row. 
* To change the level of parallelization of the running of the code, the size in the buffer needs to 
* be changed. If size equals 1, the process is unparallelized. Please refer to the README.md for 
* further information.
*/

Channel
    .fromPath("./compounds_from_query.tsv")
    .splitCsv(header: ['wikidata', 'smiles', 'isosmiles'], sep:'\t')
    .map{ row -> tuple(row.wikidata, row.smiles, row.isosmiles) }
    .buffer (size:1, remainder:true)
    .set { molecules_ch }

/* The input for the process uses 1 set at a time, that is why changing the size of the set is 
* changing the level of parallelization. 
*/

process parseSMILES {
    input:
    each set from molecules_ch

/* The for(entry in set) sets the variable names. As nextflow starts counting at 0, the first column
* is entry[0] and is set to be named wikidata, as it is the wikidata url to the compound.
*/
    exec:
       for(entry in set) {
	  wikidata = entry[0]
          smiles = entry[1]
	  isosmiles = entry[2]

/* Setting the variable name cdk to contain the functionality that CDKManager(".") has. The same goes 
* for setting the variable name jplog.
*/

	  cdk = new CDKManager(".")

/* The try-catch contains the parsing of the smiles, the conversion to an Iatomcontainer object, and 
* the retrieving of the JPLogP value. It catches errors, when it comes across them.
* The if-statement is called when the JPLogP contains an NaN, so it was unable to calculate a value
* from the information in the SMILES. The isoSMILES is then parsed, converted, and used to calculate
* the JPLogP value for that compound.
* After the if-statement, the JPLogP value (retrieved through either the SMILES or isoSMILES) is 
* printed to the command line. 
*/
	  try {
	  mol = cdk.fromSMILES("$smiles")
	  jplog = new JPlogPDescriptor()
		JPLOGofMol = jplog.calculate(mol.getAtomContainer()).value.toString()
	
	  if (JPLOGofMol == "NaN") {
	  println "Using isoSMILES ..."
	  isomol = cdk.fromSMILES("$isosmiles")
	  JPLOGofMol = jplog.calculate(isomol.getAtomContainer()).value.toString()
	  }

	  println "JPlogP value:" + JPLOGofMol	  
	  } catch (Exception exc) {
	   println "$exc" 
	  }
       }
   }

/* The line that prints when the code is using the isoSMILES is a checkpoint. The code will let you
* know when it cannot use the SMILES in this way, and will therefore use the isoSMILES.
*/

