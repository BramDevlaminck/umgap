#!/bin/bash

usage(){ echo "Syntax: $(basename $0) [-k k(Integer)] [-t tt1-tt2-...] [-o organismName] outputLocation  name  inputLocation title" 1>&2; exit 1;}

translationTables="1 2 3 4 5 6 9 10 11"
while getopts ":t:k:l:" opt; do
        case $opt in
                t) translationTables=$(echo "$OPTARG" | tr '-' ' ')     ;;
		k) k=$OPTARG ;;
		l) organism=$OPTARG ;;
                :) usage ;;
                \?) usage
  esac
done
shift $((OPTIND - 1))

if [ $# -ne 4 ]
then
	usage
fi

name="$2"
title="$4"

if [ ! -d "$1" -o ! -r "$1" ]
then
	echo "directory $1 not found" 1>&2
	exit 2
else
	outputLocation=$(cd $1 ;pwd)
	if [ ! -d "$outputLocation/$name" ]
	then
		mkdir "$outputLocation/$name"
	fi
fi

if [ ! -d "$3" -o ! -r "$3" ]
then 
	echo "directory $3 not found" 1>&2
        exit 2
else
	inputLocation=$(cd $3 ;pwd)
fi

for i in "$translationTables"
do
	sixframe=$name.$i.sixframe
	lca=found_lcas_$name.$i.txt
	cp $inputLocation/$sixframe $outputLocation/$name
	cp $inputLocation/$lca $outputLocation/$name
	#### TODO: take layout of lca-output for k-mers into account
	if [ "$organism" ]
	then
		lineage=$name.$i.lineage
		cut -d "," -f 3 $inputLocation/$lca | sed '1d' | while read line
		do 
			efetch -db taxonomy -id "$line" -format xml | xtract -pattern Taxon -element Lineage
		done > $outputLocation/$name/$lineage
		organism_lineage="$(esearch -db taxonomy -query "$organism" | efetch -format xml | xtract -pattern Taxon -element Lineage); $organism"
	fi	
done

cd ~/Documents/Unief/Thesis/Thesis/ScoreReads
rm -r classes
mkdir classes
javac -d classes -cp classes:../opencsv-3.8.jar:taxonomy_score.txt $(find src -name *.java)

for i in "$translationTables"
do
	sixframe=$outputLocation/$name/$name.$i.sixframe
	lca=$outputLocation/$name/found_lcas_$name.$i.txt
	if [ "$organism" ]
	then
		java -cp .:classes:../opencsv-3.8.jar:taxonomy_score.txt scorereads.ScoreReads ${k:-0} "$title" $sixframe $lca $outputLocation/$name/$lineage "${organism_lineage}" > $outputLocation/$name/$name.$i.known.tex
	else
		java -cp .:classes:../opencsv-3.8.jar:taxonomy_score.txt scorereads.ScoreReads ${k:-0} "$title" $sixframe $lca > $outputLocation/$name/$name.$i.unknown.tex 
	fi
done

exit 0
