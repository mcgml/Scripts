java -Xmx2g -jar mutect-1.1.7.jar \
-T MuTect \
--input_file:tumor 19-HorizonMultiplexControl_Trimmed_BothStrands_Sorted_realigned.bam \
-L C:\Users\msl\Documents\Work\RTI\RTIAnalysisDownsampling\BAM\bed.bed \
-R C:\Users\msl\Documents\Work\human_g1k_v37\human_g1k_v37.fasta \
-dt NONE \
-vcf C:\Users\msl\Desktop\horizonTest.vcf