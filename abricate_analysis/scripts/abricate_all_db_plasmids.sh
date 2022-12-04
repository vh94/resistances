#! usr/bin/bash

echo "Quering databases:"

for db in `abricate --list | awk 'FNR>=2 {print $1}'`
do
	echo "currently querying" $db "database-" 
	abricate --quiet --nopath --db $db abricate_analysis/fna_data/Plasmids/*.fna > abricate_analysis/results/results_$db.tsv
	echo -e $db "-query finished.\nwrote file: abricate_analysis/results/results_$db.tab\ncreating summary-"
	abricate --summary --nopath abricate_analysis/results/results_$db.tsv > abricate_analysis/results/summary_$db.tsv
	echo "-summary for $db finished\n wrote file: abricate_analysis/results/summary_$db.tab"
done
