#!/usr/bin/perl
use strict;
use warnings;

use Pipeline::PIPseq;
use CQS::ClassFactory;

my $def = {
    #General options
    task_name  => "pipseq_9270",
    email      => "quanhu.sheng.1\@vumc.org",
    emailType => 'FAIL',

    target_dir => "/workspace/shengq2/charles_flynn/20230105_pipseq_9270_dog",

    check_file_exists => 0,

    #file path should contain the prefix which can identify the specific sample in the folder
    files => {
        'duodenum' => [ '/workspace/shengq2/charles_flynn/20230105_pipseq_9270_dog/data/9270-CF-1' ],
        'colon' => [ '/workspace/shengq2/charles_flynn/20230105_pipseq_9270_dog/data/9270-CF-2' ],
    },

    pipseeker_sif => "/data/cqs/softwares/singularity/fluent-pipseeker_1.0.0.sif",

    #change to your star index
    pipseeker_star_index => "/workspace/shengq2/charles_flynn/20230105_pipseq_9270_dog/references/STAR_index_2.7.8a_v108_sjdb100",

    #if you want to use /workspace at cqs4 
    singularity_option => "-B /workspace",

    #if you want to use slurm system, remove /workspace binding
    #singularity_option => "",
};

performPIPseq($def);

1;

