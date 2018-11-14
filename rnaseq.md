* RNASeq pipeline

|Task|Software|
|-|-|
|QC|[FastqQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)|
|Adapter trimming|[Cutadapt](https://cutadapt.readthedocs.io/en/stable/) (Optional)|
|Mapping|[STAR](https://github.com/alexdobin/STAR)|
|Counting|[featureCounts](http://bioinf.wehi.edu.au/featureCounts/)|
|Differential analysis|[DESeq2](https://bioconductor.org/packages/release/bioc/html/DESeq2.html)|
|Gene Ontology and Pathway analysis|[WebGestaltR](https://cran.r-project.org/web/packages/WebGestaltR/index.html)|
|Gene Enrichment Set Analysis|[GSEA](http://software.broadinstitute.org/gsea/index.jsp)|
|Report||

<hr>

* NGSPERL Framework
  * Implemented using object perl 
  * Module based
    * Three key functions in each module:
      * perform
      * result
      * pbs
    * Easy to plug in/out of pipeline
  * Slurm cluster system supported
    * Generation of dependent slurm scripts automatically
    * Submitting all tasks to cluster or run the tasks sequentially using one shell script
  
<hr>

* RNAseq example data
  * /scratch/cqs/pipeline_example/rnaseq_data
  * Human patient samples
  * 9 pair-end samples
  * Sample 1,2,3 from group1 group
  * Sample 4,5,6 from group2 group
  * Sample 5,6,7 from group3 group
  * Group1 and group2 were paired sample

<hr>

* [Configuration file](https://raw.githubusercontent.com/shengqh/cqsperl/master/examples/RNAseq_human_gatk_b37.pl)

```
#!/usr/bin/perl
use strict;
use warnings;

use CQS::PerformRNAseq;
use CQS::ClassFactory;

#cqstools file_def -i /scratch/cqs/pipeline_example/rnaseq_data -n \(sample.\)
my $def = {

  #General options
  task_name  => "rnaseq_example",
  email      => "quanhu.sheng.1\@vumc.org",
  target_dir => "/scratch/cqs/shengq2/pipelinetest/rnaseq",
  max_thread => 8,

  is_paired => 1,

  perform_cutadapt => 1,
  cutadapt_option  => "-q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT",
  min_read_length  => 30,

  files => {
    "sample1" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample1_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample1_R2.fastq.gz"],
    "sample2" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample2_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample2_R2.fastq.gz"],
    "sample3" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample3_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample3_R2.fastq.gz"],
    "sample4" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample4_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample4_R2.fastq.gz"],
    "sample5" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample5_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample5_R2.fastq.gz"],
    "sample6" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample6_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample6_R2.fastq.gz"],
    "sample7" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample7_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample7_R2.fastq.gz"],
    "sample8" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample8_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample8_R2.fastq.gz"],
    "sample9" => ["/scratch/cqs/pipeline_example/rnaseq_data/sample9_R1.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/sample9_R2.fastq.gz"],
  },
  groups => {
    "Group1" => [ "sample1", "sample2", "sample3" ],
    "Group2" => [ "sample4", "sample5", "sample6" ],
    "Group3" => [ "sample7", "sample8", "sample9" ],
  },
  pairs => {
    "Group2_vs_Group1" => {
      groups => [ "Group1", "Group2" ],
      paired => [ "Patient1", "Patient2", "Patient3", "Patient1", "Patient2", "Patient3" ],
    },
    "Group3_vs_Group1" => [ "Group1", "Group3" ],
  },
  perform_proteincoding_gene => 1,
  outputPdf                  => 1,
  outputPng                  => 1,
  show_label_PCA             => 0,
};

my $config = performRNASeq_gatk_b37( $def, 1 );

#my $config = performRNASeq_gatk_b37( $def, 0 );
#performTask( $config, "deseq2_proteincoding_genetable" );

1;
```

<hr>

* Practice in ACCRE

Add following line to your .bashrc
```
alias sq='squeue -u USERNAME -o "%.20i %.9P %.50j %.10u %.2t %.10M %.6D %R"'
source /home/shengq2/local/bin/path.txt
```

Run the command to refresh the change
```
source .bashrc
```

Now let's generate the slurm scripts:
```
cd /scratch/cqs/YOURNAME
mkdir pipelinetest
cd pipelinetest
wget https://raw.githubusercontent.com/shengqh/cqsperl/master/examples/RNAseq_human_gatk_b37.pl
vi RNAseq_human_gatk_b37.pl
	#replace email 
	#replace target_dir with /scratch/cqs/YOURNAME/pipelinetest/rnaseq
perl RNAseq_human_gatk_b37.pl
cd rnaseq
ls -la
```

The expect result should be similar to:
```
drwxr-xr-x  5 shengq2 h_vangard_1  4096 Nov 13 13:49 cutadapt
drwxr-xr-x  5 shengq2 h_vangard_1  4096 Nov 13 13:49 deseq2_proteincoding_genetable
drwxr-xr-x  5 shengq2 h_vangard_1  4096 Nov 13 13:49 deseq2_proteincoding_genetable_GSEA
drwxr-xr-x  5 shengq2 h_vangard_1  4096 Nov 13 13:49 deseq2_proteincoding_genetable_WebGestalt
drwxr-xr-x  5 shengq2 h_vangard_1  4096 Nov 13 13:49 fastqc_post_trim
drwxr-xr-x  5 shengq2 h_vangard_1  4096 Nov 13 13:49 fastqc_raw
drwxr-xr-x  5 shengq2 h_vangard_1  4096 Nov 13 13:49 fastq_len
drwxr-xr-x  5 shengq2 h_vangard_1  4096 Nov 13 13:49 genetable
drwxr-xr-x  5 shengq2 h_vangard_1  4096 Nov 13 13:49 multiqc
drwxr-xr-x  5 shengq2 h_vangard_1  4096 Nov 13 13:49 report
-rw-r--r--  1 shengq2 h_vangard_1 41404 Nov 13 13:49 rnaseq_example.config
-rw-r--r--  1 shengq2 h_vangard_1  8014 Nov 13 13:49 rnaseq_example.def
drwxr-xr-x  5 shengq2 h_vangard_1  4096 Nov 13 13:49 sequencetask
drwxr-xr-x  5 shengq2 h_vangard_1  4096 Nov 13 13:49 star_featurecount
```

Now let's look at the overall tasks
```
cd sequencetask/pbs
ls -la
```
The result should be similar to:
```
-rwxr-xr-x 1 shengq2 h_vangard_1  5659 Nov 13 13:49 rnaseq_example_pipeline_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1  8095 Nov 13 13:49 rnaseq_example_pipeline_st.pbs.submit
-rwxr-xr-x 1 shengq2 h_vangard_1   742 Nov 13 13:49 rnaseq_example_report_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1 11280 Nov 13 13:49 rnaseq_example_step2_st_clear.sh
-rwxr-xr-x 1 shengq2 h_vangard_1  1643 Nov 13 13:49 rnaseq_example_step2_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1  2140 Nov 13 13:49 rnaseq_example_step2_st.pbs.submit
-rwxr-xr-x 1 shengq2 h_vangard_1   633 Nov 13 13:49 rnaseq_example_summary_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1  1091 Nov 13 13:49 sample1_step1_st_clear.sh
-rwxr-xr-x 1 shengq2 h_vangard_1   913 Nov 13 13:49 sample1_step1_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1   629 Nov 13 13:49 sample1_step1_st.pbs.submit
-rwxr-xr-x 1 shengq2 h_vangard_1  1091 Nov 13 13:49 sample2_step1_st_clear.sh
-rwxr-xr-x 1 shengq2 h_vangard_1   913 Nov 13 13:49 sample2_step1_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1   629 Nov 13 13:49 sample2_step1_st.pbs.submit
-rwxr-xr-x 1 shengq2 h_vangard_1  1091 Nov 13 13:49 sample3_step1_st_clear.sh
-rwxr-xr-x 1 shengq2 h_vangard_1   913 Nov 13 13:49 sample3_step1_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1   629 Nov 13 13:49 sample3_step1_st.pbs.submit
-rwxr-xr-x 1 shengq2 h_vangard_1  1091 Nov 13 13:49 sample4_step1_st_clear.sh
-rwxr-xr-x 1 shengq2 h_vangard_1   913 Nov 13 13:49 sample4_step1_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1   629 Nov 13 13:49 sample4_step1_st.pbs.submit
-rwxr-xr-x 1 shengq2 h_vangard_1  1091 Nov 13 13:49 sample5_step1_st_clear.sh
-rwxr-xr-x 1 shengq2 h_vangard_1   913 Nov 13 13:49 sample5_step1_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1   629 Nov 13 13:49 sample5_step1_st.pbs.submit
-rwxr-xr-x 1 shengq2 h_vangard_1  1091 Nov 13 13:49 sample6_step1_st_clear.sh
-rwxr-xr-x 1 shengq2 h_vangard_1   913 Nov 13 13:49 sample6_step1_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1   629 Nov 13 13:49 sample6_step1_st.pbs.submit
-rwxr-xr-x 1 shengq2 h_vangard_1  1091 Nov 13 13:49 sample7_step1_st_clear.sh
-rwxr-xr-x 1 shengq2 h_vangard_1   913 Nov 13 13:49 sample7_step1_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1   629 Nov 13 13:49 sample7_step1_st.pbs.submit
-rwxr-xr-x 1 shengq2 h_vangard_1  1091 Nov 13 13:49 sample8_step1_st_clear.sh
-rwxr-xr-x 1 shengq2 h_vangard_1   913 Nov 13 13:49 sample8_step1_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1   629 Nov 13 13:49 sample8_step1_st.pbs.submit
-rwxr-xr-x 1 shengq2 h_vangard_1  1091 Nov 13 13:49 sample9_step1_st_clear.sh
-rwxr-xr-x 1 shengq2 h_vangard_1   913 Nov 13 13:49 sample9_step1_st.pbs
-rwxr-xr-x 1 shengq2 h_vangard_1   629 Nov 13 13:49 sample9_step1_st.pbs.submit
-rwxr-xr-x 1 shengq2 h_vangard_1   331 Nov 13 13:49 step1_st.submit
-rwxr-xr-x 1 shengq2 h_vangard_1    50 Nov 13 13:49 step2_st.submit
```

Then we can submit job to cluster:
```
sh rnaseq_example_pipeline_st.pbs.submit
```
or run the job directly
```
sh rnaseq_example_pipeline_st.pbs
```

If we submit the tasks to cluster, we can use command sq to check the status:
```
sq
```
The result should be like:
```
      JOBID PARTITION                                    NAME       USER ST       TIME  NODES NODELIST(REASON)
    3497884 productio                          sample1_fq.pbs    shengq2 PD       0:00      1 (Dependency)
    3497885 productio                          sample2_fq.pbs    shengq2 PD       0:00      1 (Dependency)
    3497886 productio                          sample3_fq.pbs    shengq2 PD       0:00      1 (Dependency)
    3497887 productio                          sample4_fq.pbs    shengq2 PD       0:00      1 (Dependency)
    3497888 productio                          sample5_fq.pbs    shengq2 PD       0:00      1 (Dependency)
    3497889 productio                          sample6_fq.pbs    shengq2 PD       0:00      1 (Dependency)
    3497890 productio                          sample7_fq.pbs    shengq2 PD       0:00      1 (Dependency)
    3497891 productio                          sample8_fq.pbs    shengq2 PD       0:00      1 (Dependency)
    3497892 productio                          sample9_fq.pbs    shengq2 PD       0:00      1 (Dependency)
    3497893 productio                        sample1_flen.pbs    shengq2 PD       0:00      1 (Dependency)
    3497894 productio                        sample2_flen.pbs    shengq2 PD       0:00      1 (Dependency)
    3497895 productio                        sample3_flen.pbs    shengq2 PD       0:00      1 (Dependency)
    3497896 productio                        sample4_flen.pbs    shengq2 PD       0:00      1 (Dependency)
    3497897 productio                        sample5_flen.pbs    shengq2 PD       0:00      1 (Dependency)
    3497898 productio                        sample6_flen.pbs    shengq2 PD       0:00      1 (Dependency)
    3497899 productio                        sample7_flen.pbs    shengq2 PD       0:00      1 (Dependency)
    3497900 productio                        sample8_flen.pbs    shengq2 PD       0:00      1 (Dependency)
    3497901 productio                        sample9_flen.pbs    shengq2 PD       0:00      1 (Dependency)
    3497902 productio                          sample1_sf.pbs    shengq2 PD       0:00      1 (Dependency)
    3497903 productio                          sample2_sf.pbs    shengq2 PD       0:00      1 (Dependency)
    3497904 productio                          sample3_sf.pbs    shengq2 PD       0:00      1 (Dependency)
    3497905 productio                          sample4_sf.pbs    shengq2 PD       0:00      1 (Dependency)
    3497906 productio                          sample5_sf.pbs    shengq2 PD       0:00      1 (Dependency)
    3497907 productio                          sample6_sf.pbs    shengq2 PD       0:00      1 (Dependency)
    3497908 productio                          sample7_sf.pbs    shengq2 PD       0:00      1 (Dependency)
    3497909 productio                          sample8_sf.pbs    shengq2 PD       0:00      1 (Dependency)
    3497910 productio                          sample9_sf.pbs    shengq2 PD       0:00      1 (Dependency)
    3497912 productio                  rnaseq_example_fqs.pbs    shengq2 PD       0:00      1 (Dependency)
    3497913 productio              rnaseq_example_uniqueR.pbs    shengq2 PD       0:00      1 (Dependency)
    3497914 productio              rnaseq_example_uniqueR.pbs    shengq2 PD       0:00      1 (Dependency)
    3497915 productio                   rnaseq_example_ss.pbs    shengq2 PD       0:00      1 (Dependency)
    3497916 productio                   rnaseq_example_tb.pbs    shengq2 PD       0:00      1 (Dependency)
    3497917 productio          rnaseq_example_cor_uniqueR.pbs    shengq2 PD       0:00      1 (Dependency)
    3497918 productio                  rnaseq_example_de2.pbs    shengq2 PD       0:00      1 (Dependency)
    3497919 productio                   rnaseq_example_wr.pbs    shengq2 PD       0:00      1 (Dependency)
    3497920 productio              rnaseq_example_uniqueR.pbs    shengq2 PD       0:00      1 (Dependency)
    3497921 productio                  rnaseq_example_mqc.pbs    shengq2 PD       0:00      1 (Dependency)
    3497922 productio                   rnaseq_example_br.pbs    shengq2 PD       0:00      1 (Dependency)
    3497923 productio            rnaseq_example_report_st.pbs    shengq2 PD       0:00      1 (Dependency)
    3497875 productio                         sample1_cut.pbs    shengq2  R      31:03      1 cn1374
    3497876 productio                         sample2_cut.pbs    shengq2  R      31:03      1 cn1374
    3497877 productio                         sample3_cut.pbs    shengq2  R      31:03      1 cn1229
    3497878 productio                         sample4_cut.pbs    shengq2  R      31:03      1 cn1229
    3497879 productio                         sample5_cut.pbs    shengq2  R      31:03      1 cn1228
    3497880 productio                         sample6_cut.pbs    shengq2  R      31:03      1 cn1228
    3497881 productio                         sample7_cut.pbs    shengq2  R      31:03      1 cn1228
    3497882 productio                         sample8_cut.pbs    shengq2  R      31:03      1 cn1206
    3497883 productio                         sample9_cut.pbs    shengq2  R      31:03      1 cn1206
```

Now we can wait until all jobs done automatically.

