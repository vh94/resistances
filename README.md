
## Project for the Course Applied Omics MCB Coimbra 2022

Investigate potential Genes which cause antibiocial resistance in the Proteobacterium Helicobacter pylori.

- Helicobacter pylori was classified by the World Health Organization as a class 1 carcinogen
- H. pylori plays a major role in gastric ulcer, atrophic gastritis, and gastric carcinoma. 
- Triple therapy (a proton pump inhibitor combined with two antibiotics, like clarithromycin [CLR], metronidazole [MTZ]) are adopted to treat the infection
- increasing H. pylori antibiotic resistance has been reported globally over the past two decades

(see https://doi.org/10.3389/fphar.2021.666903)


Setting up the environment:
```bash
mamba install ncbi-datasets-cli abricate
```

#### 1. Download the assemblies of different strains of H.pylori as well as known plasmids form the NCBI genebank.

`GCA_accessions.txt` contains the accession identifiers for some (for now random) helicobacter pylori strain assemblies.
 
Using NCBI’s datasets API we download .fna files for these strains.

```bash
datasets download genome accession --inputfile GCA_accessions.txt --filename hpylori_data.zip
unzip hpylori_data.zip
```

helpful link for datasets API:
https://www.ncbi.nlm.nih.gov/datasets/docs/v2/how-tos/genomes/get-genome-metadata/



#### 2. Use the obtained sequences to run them against the databases such as resfinder, ncbibetalactamase and ARG-ANNOT using the CLI -tool **abricate**. 

resource on abricate: https://github.com/tseemann/abricate

!SHORTCOMING! abricate does not find point mutations leading to resistances.
https://github.com/ncbi/amr#ncbi-antimicrobial-resistance-gene-finder-amrfinderplus

create dirs for abricate analysis:

```bash
mkdir -p abricate_analysis/{fna_data,scripts,results}
```

copy downloaded fna files into abricate_analysis dir:
```bash
find hpylori_data/data -name '*.fna' -exec cp -t abricate_analysis/fna_data {} +
```

Avialable databases:
```bash
abricate --list | column -t
```

|DATABASE	|   SEQUENCES   |   DBTYPE	|  DATE		| DOI				|	content		|
|---------------|---------------|---------------|---------------|-------------------------------|-----------------------|
|vfdb         	| 2597		| nucl   	| 2021-Mar-27	| doi:10.1093/nar/gkv1239	| virulence factors
|argannot     	| 2223  	| nucl   	| 2021-Mar-27	| doi:10.1128/AAC.01310-13	| ARDGs
|megares      	| 6635  	| nucl    	| 2021-Mar-27	| doi:10.1093/nar/gkz1010	| ARGs, metal and biocides Res
|resfinder    	| 3077  	| nucl   	| 2021-Mar-27	| doi:10.1093/jac/dks261	| ARGs
|plasmidfinder	| 460   	| nucl   	| 2021-Mar-27	| doi:10.1128/AAC.02412-14	| unique plasmid replicon sequences from Enterobacteriaceae
|ecoli_vf     	| 2701  	| nucl   	| 2021-Mar-27	| _none_			| VFDB + additional factors
|card         	| 2631  	| nucl   	| 2021-Mar-27	| doi:10.1093/nar/gkw1004	| ARG's, products, phenotypes
|ncbi         	| 5386  	| nucl   	| 2021-Mar-27	| doi: 10.1128/AAC.00483-19	|
|ecoh         	| 597   	| nucl   	| 2021-Mar-27	| doi:10.1099/mgen.0.000064	|


update db (!this might break the database) DO NOT RUN!
```bash
abricate-get_db --db resfinder --force
```
Step 1: run abricate on fna files

```bash
abricate --db 'vfdb' abricate_analysis/fna_data/*.fna > abricate_analysis/results/results_vfdb.tab
```

Step 2: Create summary table:

```bash
abricate --summary abricate_analysis/results/results_vfdb.tab > abricate_analysis/results/summary_vfb.tab
```

Steps 1 & 2 are automatized in the script abricate_analysis/scripts/abricated_all_db_query.sh

it reads all Fasta (.fna) files from abricate_analysis/fna_data/ 
querys them against every installed database, 
it then creates a summary for each of the databases

#### 3. Analyse the findings



#### 4. compare with literature:

- doi.org/10.1038/s41575-021-00449-x 
- doi.org/10.3390/jcm8010053

more,see: `Hpyroli_resistance.bib`
