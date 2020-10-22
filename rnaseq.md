# Table of Contents

- [Table of Contents](#table-of-contents)
  - [Workflow](#workflow)
  - [NGSPERL Framework](#ngsperl-framework)
  - [Examples](#examples)
    - [Simple comparison](#simple-comparison)
    - [Comparison with covariance](#comparison-with-covariance)
    - [Comparison with covariance file](#comparison-with-covariance-file)
    - [Define group and covariance using regex pattern](#define-group-and-covariance-using-regex-pattern)
  - [Practice in ACCRE](#practice-in-accre)

<hr>

## Workflow

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

## NGSPERL Framework

Our RNASeq pipeline is NGSPERL-based which can be downloaded from https://github.com/shengqh/ngsperl.

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

## Examples

### Simple comparison

[rnaseq_example_01_simple](https://github.com/shengqh/cqsperl/raw/master/examples/rnaseq_example_01_simple.pl)

In this basic "treatment vs control" example, we defined files, groups and pairs. 

```perl
#!/usr/bin/perl
use strict;
use warnings;

use CQS::PerformRNAseq;
use CQS::ClassFactory;

#cqstools file_def -i /scratch/cqs/pipeline_example/rnaseq_data -n \(S.\) -f gz
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
    "S1" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R2_001.fastq.gz"],
    "S2" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R2_001.fastq.gz"],
    "S3" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R2_001.fastq.gz"],
    "S4" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R2_001.fastq.gz"],
    "S5" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R2_001.fastq.gz"],
    "S6" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R2_001.fastq.gz"],
    "S7" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R2_001.fastq.gz"],
  },
  groups => {
    "Control" => [ "S1", "S2", "S3" ],
    "Treatment" => [ "S4", "S5", "S6", "S7" ]
  },
  pairs => {
    "Treatment_vs_Control" => [ "Control", "Treatment" ], 
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

### Comparison with covariance

[rnaseq_example_02_covariance](https://github.com/shengqh/cqsperl/raw/master/examples/rnaseq_example_02_covariance.pl)

In this example, we introduce covariance "gender" in pairs, everything else is same as simple comparison. The "gender" values should be matched with groups. In this case, the first three "gender" values are from Control group and the next four "gender" values are from Treatment group. You can define multiple covariances in each comparison.

```perl
  pairs => {
    "Treatment_vs_Control" => {
      groups => [ "Control", "Treatment" ], 
      gender => ["M", "F", "M", "M", "F", "F", "F"]
    }
  },
```

<br>

### Comparison with covariance file

[rnaseq_example_03_covariance_file](https://github.com/shengqh/cqsperl/raw/master/examples/rnaseq_example_03_covariance_file.pl)

Some time, there are too many covariances values need to be input handly. Once we change the group definition, the covariance values have to be updated too. We introduce a covariance file in definition as below. The covariance file is tab-delimited file with first column indicates sample name and all the following columns are covariances.

```perl
  covariance_file => "/scratch/cqs/pipeline_example/rnaseq_data/covariance.txt",
  pairs => {
    "Treatment_vs_Control" => {
      groups => [ "Control", "Treatment" ], 
      covariances => ["gender"]
    }
  },
```

<br>

### Define group and covariance using regex pattern

[rnaseq_example_04_regex](https://github.com/shengqh/cqsperl/raw/master/examples/rnaseq_example_04_regex.pl)

In this example, we rename the sample with proper name which includes both group and gender information. Then we can use regex pattern to extract group and gender information. groups_pattern will be used to generate groups definition in fly and covariance_patterns will be used to generate covariance file. Please remember that groups_pattern and covariance_patterns can be used independently.

```perl

  files => {
    "Control_M_S1" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R2_001.fastq.gz"],
    "Control_F_S2" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R2_001.fastq.gz"],
    "Control_M_S3" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R2_001.fastq.gz"],
    "Treatment_M_S4" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R2_001.fastq.gz"],
    "Treatment_F_S5" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R2_001.fastq.gz"],
    "Treatment_F_S6" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R2_001.fastq.gz"],
    "Treatment_F_S7" => ["/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R2_001.fastq.gz"],
  },
  groups_pattern => "(.+?)_",
  covariance_patterns => {
    gender => {
      pattern => "_(.)_",
      prefix => "GENDER_"
    }
  },
  pairs => {
    "Treatment_vs_Control" => {
      groups => [ "Control", "Treatment" ], 
      covariances => ["gender"]
    }
  },
```

## Practice in ACCRE

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

