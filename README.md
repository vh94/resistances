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


querys them against every installed database, 
it then creates a summary for each of the databases


## SNP resitances

to find mutations leading to AR's use CARD rgi tool

i install to a new env since rgi downgrades abricate and BLAST.
```
conda create -n card_rgi
mamba install --channel conda-forge --channel bioconda --channel defaults rgi
conda activate card_rgi
cd CARD_rgi_analysis
mkdir localDB
cd localDB
wget https://card.mcmaster.ca/latest/data
tar -xvf data ./card.json

```
To run rgi analysis:

```
rgi main --input_sequence ../fna_data/Plasmids/Plasmids.fna --output_file ./plasimids_rgi_results --local --clean --include_loose
```


To create heatmap

```

```


#### 3. Analyse the findings

## Main plasmid vs plasimid (horizontal gene transfer)

small cryptic plasmids (SCPs) role in anitbiotic resistance

Plasiumid identifier list from escobar et al 2020 : "pyroliPlasmidNCBI_ids_Escobaretal_Peru.txt"


## Geographical region


## RM Systems
massive R-M system repertoire (Krebes et al., 2014) that continues to be revealed by technological advances. Our results suggest that ∼10% of the genome encodes R-M systems. Notably, the type I and II R-M systems were located exclusively in the accessory genome, supporting the hypothesis that restriction enzymes may be part of a bacterial defensive network that contribute to lineage homogenization
#### 4. compare with literature:

- doi.org/10.1038/s41575-021-00449-x 
- doi.org/10.3390/jcm8010053

more,see: `Hpyroli_resistance.bib`
