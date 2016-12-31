#Author: Faisal Rezwan
#E-mail: F.Rezwan@soton.ac.uk
#Date: May 27, 2013 (latest)

import sys

class pindel_variants:
    def __init__(self,chr,pos,ref,alt,filter,end,homlen,homseq,svlen,svtype,ntlen,genotype,allele_depth):
        self.chr = chr
        self.pos = pos
        self.ref = ref
        self.alt = alt
        self.filter = filter
        self.end = end
        self.homlen = homlen
        self.homseq = homseq
        self.svlen = svlen
        self.svtype = svtype
        self.ntlen = ntlen
        self.genotype = genotype
        self.allele_depth = allele_depth
        


vcf_file = sys.argv[1]
fr = open(vcf_file,'r')

lines = fr.readlines()
variant_list = []
info_lines = []
for line in lines:
   
    end = ''
    homlen = ''
    homseq = ''
    svlen = ''
    svtype = ''
    ntlen = ''

    l = line.strip('\n')
    l_split = l.split('\t')
    l_split_len = len(l_split)

    if(l_split_len == 1):
        info_lines.append(l)
    else:
        if(l_split[0] != '#CHROM'):
            chr = l_split[0]
            pos = l_split[1]
            ref = l_split[3]
            alt = l_split[4]
            filter = l_split[6]
            info = l_split[7]
            info_split = info.split(';')
            info_len = len(info_split)
            for i in range(0,info_len):
                qinfo = info_split[i]
                qinfo_split = qinfo.split('=')
                if(qinfo_split[0]=='END'):
                    end = qinfo_split[1]
                elif(qinfo_split[0]=='HOMLEN'):
                    homlen = qinfo_split[1]
                elif(qinfo_split[0]=='HOMSEQ'):
                    homseq = qinfo_split[1]
                elif(qinfo_split[0]=='SVLEN'):
                    svlen = qinfo_split[1].strip('-')
                elif(qinfo_split[0]=='SVTYPE'):
                    svtype = qinfo_split[1]
                elif(qinfo_split[0]=='NTLEN'):
                    ntlen = qinfo_split[1]

            gt_ad = l_split[9]
            gt_ad_split = gt_ad.split(':')
            genotype = gt_ad_split[0]
            allele_depth = gt_ad_split[1]

            variant = pindel_variants(chr,pos,ref,alt,filter,end,homlen,homseq,svlen,svtype,ntlen,genotype,allele_depth)
            variant_list.append(variant)


infile = open(sys.argv[2],'w')
for info_line in info_lines:
    infile.write(info_line+"\n")
infile.write('\n')
infile.write('CHROM\tSTART\tEND\tREF\tALT\tFILTER\tHOMLEN\tHOMSEQ\tSVLEN\tSVTYPE\tNTLEN\tGT\tAD\n')    
for var in variant_list:
    infile.write(var.chr+'\t'+var.pos+'\t'+var.end+'\t'+var.ref+'\t'+var.alt+'\t'+var.filter+'\t'+var.homlen+'\t'+var.homseq+'\t'+var.svlen+'\t'+var.svtype+'\t'+var.ntlen+'\t'+var.genotype+'\t'+var.allele_depth+'\n')

infile.close()
