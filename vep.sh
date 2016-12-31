#!/bin/bash

filename=$(echo "$1" | cut -d. -f1)

#add IDs to VCF column
perl IDVCF.pl "$1"

#annotate VCF
perl /home/msl/ensembl-tools-release-75/scripts/variant_effect_predictor/variant_effect_predictor.pl \
-i "$filename"_ID.vcf \
--fasta /home/msl/.vep/homo_sapien/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa \
--output "$filename"_vep.txt \
--refseq \
--offline \
--force_overwrite \
--no_stats \
--sift b \
--polyphen b \
--numbers \
--hgvs \
--symbol \
--gmaf \
--maf_1kg \
--maf_esp \
--fields Uploaded_variation,Location,Allele,AFR_MAF,AMR_MAF,ASN_MAF,EUR_MAF,AA_MAF,EA_MAF,Consequence,SYMBOL,Feature,HGVSc,HGVSp,PolyPhen,SIFT,EXON,INTRON
