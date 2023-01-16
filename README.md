# 1 CQSPerl Package 

cqsperl is a library including predefined pipelines for CQS users in ACCRE. It is based on [ngsperl](https://github.com/shengqh/ngsperl) framework.

In order to use ngsperl and cqsperl library, and neccessory tools in ACCRE, you need to add following line into your .bashrc file:
```
source /scratch/cqs_share/softwares/cqsperl/scripts/path.txt
```

# 2 Step-by-step Introduction

Running with ngsperl based pipeline involves those steps:

```text
2.1  Write configuration file
2.2  Generate jobs scripts
2.3  Submit jobs
2.4  Check result
2.5  Re-submit jobs if there are tasks failed, and check result again
2.6  Check report
```

We will illustrate each step using RNAseq as example. The details of each configuration file will be explained at corresponding section. Here, we will demostrate the steps to run the example.

## 2.1 Write configuration file

First of all, we copy the template to our local folder.

```bash
mkdir ~/pipeline
cd ~/pipeline
cp /scratch/cqs_share/softwares/cqsperl/examples/20200619_RNAseq_gencode_hg19.pl RNAseq_example.pl

```

Then, we need to change the email and the target_dir. For real project, you will also change the configuration filename, the task_name, the file definition, the group definition, the comparison definition, and so on.

## 2.2 Generate job scripts

```bash
perl RNAseq_example.pl
```

*Due to the hardware difference, and the fact that I installed most of perl modules in cqs1 gateway, generating job scripts at cqs3 or default ACCRE gateway will failed. So, remember to run the code at cqs1.*

You should observe following lines which indicates that the task job scripts have been generated.

```text
[shengq2@cqs1 pipeline]$ perl RNAseq_example.pl
is_pairend=1
cutadapt_thread=2
RNAseq_example.pl => /scratch/cqs/test/rnaseq_example/RNAseq_example.pl
Saved user definition file to /scratch/cqs/test/rnaseq_example/rnaseq_hg19.def
Saved configuration file to /scratch/cqs/test/rnaseq_example/rnaseq_hg19.config
Preforming deseq2_proteincoding_genetable_WebGestalt by Annotation::WebGestaltR
/scratch/cqs/test/rnaseq_example/deseq2_proteincoding_genetable_WebGestalt/pbs/rnaseq_hg19_wr.pbs created.
Preforming fastqc_count_vis by CQS::UniqueR

......

Preforming deseq2_proteincoding_genetable by Comparison::DESeq2
/scratch/cqs/test/rnaseq_example/deseq2_proteincoding_genetable/pbs/rnaseq_hg19_de2.pbs created.
Preforming sequencetask by CQS::SequenceTaskSlurmSlim
/scratch/cqs/test/rnaseq_example/sequencetask/pbs/rnaseq_hg19_report_st.pbs created.
/scratch/cqs/test/rnaseq_example/sequencetask/pbs/rnaseq_hg19_pipeline_st.pbs created.
```

## 2.3 Submit jobs to SLURM cluster task manager

```shell
cd /scratch/cqs/test/rnaseq_example/sequencetask/pbs/
sh rnaseq_hg19_pipeline_st.pbs.submit
```

Now you can check the job status. 

```shell
sq
```

`sq` is an alias which defined in path.txt. If you don't source path.txt, you can add following line to your .bashrc 

```
alias sq='squeue -u $USER -o "%.20i %.9P %.50j %.10u %.2t %.10M %.6D %R"'
```

You should observe result similar to following lines:

```text
               JOBID PARTITION                                               NAME       USER ST       TIME  NODES NODELIST(REASON)
            20866897 productio                                         H2O_sf.pbs    shengq2 PD       0:00      1 (Dependency)
            20866898 productio                             VPM150_5mM_cell_sf.pbs    shengq2 PD       0:00      1 (Dependency)
            20866899 productio                           VPM150_metaC_cell_sf.pbs    shengq2 PD       0:00      1 (Dependency)
            20866900 productio                             VPM153_5mM_cell_sf.pbs    shengq2 PD       0:00      1 (Dependency)
            20866901 productio                           VPM153_metaC_cell_sf.pbs    shengq2 PD       0:00      1 (Dependency)
            20866878 productio                          VPM150_metaC_cell_cut.pbs    shengq2  R       6:52      1 cn1204
            20866879 productio                            VPM153_5mM_cell_cut.pbs    shengq2  R       6:52      1 cn1206
```

Some of tasks are pending with Dependency, a few tasks are running. When a lot of jobs would be submitted, you may also notice the tasks waiting for resource allocation, or even group limitation. Check the jobs a few hours later or one day.

## 2.4 Check result

Once you find all jobs are done in SLURM system. You can check the analysis result.

```shell
cd /scratch/cqs/test/rnaseq_example/sequencetask/result
grep FAIL rnaseq_hg19_st_expect_result.tsv.check.csv
```

If you find any task failed, you will need to check the reason. But I will recommend you to re-submit jobs again.

## 2.5 Re-submit jobs if there are tasks failed

Just return the 2.3 to submit jobs again. All finished jobs will not be submitted again. So, only failed jobs will be submitted.

Another choice is, run the failed jobs directly rather than submit them to ACCRE again.

```bash
cd /scratch/cqs/test/rnaseq_example/sequencetask/pbs
sh rnaseq_hg19_pipeline_st.pbs
```

## 2.6 Check report

If there is any failed jobs and you fix it already, you will need to re-generate report. The '1' in command line forces the report to be generated again. 

```bash
cd /scratch/cqs/test/rnaseq_example/report/pbs
sh rnaseq_hg19_br.pbs 1
```

Now you can transfer the html report to local computer to have a look.

# 3 RNASeq 

We provide four functions for predefined databases:

* performRNASeq_gencode_hg19
* performRNASeq_gencode_hg38
* performRNASeq_gencode_mm10
* performRNASeq_ensembl_Mmul10

We have an example for [20200619_RNAseq_gencode_hg19.pl](examples/20200619_RNAseq_gencode_hg19.pl).

## 3.1 Template 

```perl
#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::PerformRNAseq;

my $def = {

  #define task name, this name will be used as prefix of a few result, such as read count table file name.
  task_name => "rnaseq_hg19",

  #email which will be used for notification if you run through cluster
  email => "quanhu.sheng.1\@vumc.org",

  #target dir which will be automatically created and used to save code and result, you need to change it for each project.
  target_dir         => "/scratch/cqs/test/rnaseq_example",

  #DEseq2 fold change, you can use either 1.5 or 2 or other option you want.
  DE_fold_change     => 1.5,

  #Since we have most of figure, we don't need multiqc anymore. But if you want, you can set it to 1.
  perform_multiqc    => 0,

  #We use webgestalt to do gene enrichment analysis using differential expressed genes.
  perform_webgestalt => 1,

  #We use GSEA for gene set enrichment analysis. It works for human genome only.
  perform_gsea       => 1,

  #If we need to trim the adapter from reads. Set to 0 if you don't find adapter in raw data.
  perform_cutadapt => 1,

  #If you find adapter through FastQC report, you need to specify adapter here.
  cutadapt_option  => "-O 1 -q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT -a CTGTCTCTTATACACATCT -A CTGTCTCTTATACACATCT",

  #discard reads with length less than 30 after adapter trimming
  min_read_length  => 30,

  #Is the data pairend data or single end data
  pairend => 1,

  #Call variant using GATK pipeline
  perform_call_variants => 0,
  
  #source files, it's a hashmap with key (sample name) points to array of files. For single end data, the array should contains one file only.
  files => {
    "VPM150_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AAGAGG_S1_R2_001.fastq.gz" ],
    "VPM150_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GGAGAA_S2_R2_001.fastq.gz" ],
    "VPM153_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-AGCATG_S3_R2_001.fastq.gz" ],
    "VPM153_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-GAGTCA_S4_R2_001.fastq.gz" ],
    "VPM154_5mM_cell"   => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CGTAGA_S5_R2_001.fastq.gz" ],
    "VPM154_metaC_cell" => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-TCAGAG_S6_R2_001.fastq.gz" ],
    "H2O"               => [ "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R1_001.fastq.gz", "/scratch/cqs/pipeline_example/rnaseq_data/948-WZ-1-CACAGT_S7_R2_001.fastq.gz" ],
  },

  #group definition, group name points to array of sample name defined in files.
  groups => {
    "5mM"   => [ "VPM150_5mM_cell",   "VPM153_5mM_cell",   "VPM154_5mM_cell" ],
    "metaC" => [ "VPM150_metaC_cell", "VPM153_metaC_cell", "VPM154_metaC_cell" ],
    "H2O"   => ["H2O"],
  },

  #comparison definition, comparison name points to array of group name defined in groups.
  #for each comparison, only two group names allowed while the first group will be used as control.
  pairs => {
    "metaC_vs_5mM" => [ "5mM", "metaC" ]
  },
};

my $config = performRNASeq_gencode_hg19($def, 1);

1;

```

If we want to introduce covariate in comparison, we can define the pairs as following lines. "patient" is the covariate name and the first three names correspond to three samples in group "5mM" and the last three names correspond to the three samples in group "metaC". You can add multiple covariate in the definition, such as batch_name, date, gender, and so on.

```perl
  pairs => {
    "metaC_vs_5mM" => {
      groups => [ "5mM", "metaC" ],
      patient => ["VPM150",   "VPM153",   "VPM154", "VPM150l",   "VPM153",   "VPM154" ]
    }
  },
```

