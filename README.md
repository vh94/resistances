
## project in Applied Omics

### Investigate potential Genes which cause antibiocial resistance in the Proteobacterium Helicobacter pylori.
- Helicobacter pylori was classified by the World Health Organization as a class 1 carcinogen
- H. pylori plays a major role in gastric ulcer, atrophic gastritis, and gastric carcinoma. 
- Triple therapy (a proton pump inhibitor combined with two antibiotics, like clarithromycin [CLR], metronidazole [MTZ]) are adopted to treat the infection
- increasing H. pylori antibiotic resistance has been reported globally over the past two decades

(see https://doi.org/10.3389/fphar.2021.666903)

#### 1. Download the assemblies of different strains of H.pylori as well as known plasmids form the NCBI genebank.

```bash
datasets download genome accession --inputfile GCA_accessions.txt --filename hpylori_data.zip
unzip hpylori_data.zip
```

helpful link for datasets API:
https://www.ncbi.nlm.nih.gov/datasets/docs/v2/how-tos/genomes/get-genome-metadata/



#### 2. Use the obtained sequences to run them against the databases such as resfinder, ncbibetalactamase and ARG-ANNOT using the CLI -tool **abricate**. 

resource on abricate: https://github.com/tseemann/abricate/blob/master/README.md

!SHORTCOMING! abricate does not find point mutations leading to resistances.

https://github.com/ncbi/amr#ncbi-antimicrobial-resistance-gene-finder-amrfinderplus

does!



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
|argannot     	| 2223  	| nucl   	| 2021-Mar-27	| doi:10.1128/AAC.01310-13	|
|megares      	| 6635  	| nucl    	| 2021-Mar-27	| doi:10.1093/nar/gkz1010	| resistance genes to antimicrobial drugs,sequences for metal and biocides
|resfinder    	| 3077  	| nucl   	| 2021-Mar-27	| doi:10.1093/jac/dks261	|
|plasmidfinder	| 460   	| nucl   	| 2021-Mar-27	| doi:10.1128/AAC.02412-14	|
|ecoli_vf     	| 2701  	| nucl   	| 2021-Mar-27	| _none_			| VFDB + additional factors
|card         	| 2631  	| nucl   	| 2021-Mar-27	| doi:10.1093/nar/gkw1004	|
|ncbi         	| 5386  	| nucl   	| 2021-Mar-27	| doi: 10.1128/AAC.00483-19	|	
|ecoh         	| 597   	| nucl   	| 2021-Mar-27	| doi:10.1099/mgen.0.000064	|




update db (!this might break the database)
```bash
abricate-get_db --db resfinder --force
```
step 1: run abricate on fna files

```bash
abricate --db 'vfdb' abricate_analysis/fna_data/*.fna > abricate_analysis/results/results_vfdb.tab
```

step 2: Create summary table:

```bash
abricate --summary abricate_analysis/results/results_vfdb.tab > abricate_analysis/results/summary_vfb.tab
```

Steps 1 & 2 are automatized in the script abricate_analysis/scripts/abricated_all_db_query.sh
it reads all Fasta (.fna) files from abricate_analysis/fna_data/ and querys them against every installed database, it then creates a summary for the database

#### 3. Analyse the findings





#### 4. compare with literature:
In the article https://doi.org/10.1038/s41575-021-00449-x the authors give a overview of MDR in H.pylori, its link to gastric cancer and the benefits of NGS in clinical ( Antimicrobial Susceptibility Testing/ surveillance) and research settings to gain understanding of the mechanism.


An other study using Illumina WGS data of 140 H.pylori strains (https://doi.org/10.3390/jcm8010053) showed that there is a link between SNP's in two 23SrRNA genes (gyrA,rpoB) and MDR in H.pylori as well as combinations of specific mutations that lead to clarithromycin resistance. 
