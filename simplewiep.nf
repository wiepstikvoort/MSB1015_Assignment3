#!/usr/bin/env nextflow

@Grab(group='io.github.egonw.bacting', module='managers-cdk', version='0.0.9')
@Grab(group='org.openscience.cdk', module='cdk-qsarmolecular', version='2.3')

import net.bioclipse.managers.CDKManager
import org.openscience.cdk.qsar.descriptors.molecular.JPlogPDescriptor
import org.openscience.cdk.interfaces.IAtomContainer

/* the channel sets the path to the short.tsv file for now, to do some tests and get the code 
* functioning. It splits the file into wikidata, and smiles, and tells it that you want as ouput 
* 1 row with the wikidata and 1 smiles 
* the buffer sets the size of the set, so that your computer can use as many threads as there are 
* rows in the set
*/

/* need to change short.tsv to the file that contains all smiles
*
*
*/


Channel
    .fromPath("./short_3_columns.tsv")
    .splitCsv(header: ['wikidata', 'smiles', 'isosmiles'], sep:'\t')
    .map{ row -> tuple(row.wikidata, row.smiles, row.isosmiles) }
    .buffer (size:2, remainder:true)
    .set { molecules_ch }

/* the process uses as input 1 set at a time.  
* the execution tells you that the first entry (entry[0]) is the wikidata, and the second entry
* is the smiles
* if there is a smiles, it prints the wikidata and the smiles
* if it does not have a smiles it prints that that url has no smiles
*/

process parseSMILES {
    input:
    each set from molecules_ch

    exec:
       for(entry in set) {
	  wikidata = entry[0]
          smiles = entry[1]
	  isosmiles = entry[2]

	  cdk = new CDKManager(".")

	  try {
	  mol = cdk.fromSMILES("$smiles")
	  jplog = new JPlogPDescriptor()
		JPLOGofMol = jplog.calculate(mol.getAtomContainer()).value.toString()
	  println "JPlogP value:" + JPLOGofMol	  
	  } catch (Exception exc) {
	   println "$exc" 
	  }
       }
   }



