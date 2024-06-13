# library(xfun)
# library(rmarkdown)

# date_str="d://temp//"
# xfun::Rscript_call(
#   rmarkdown::render,
#   list(input="D:/source/ngsperl/lib/Report/StringDb.Rmd",
#        output_file=paste0(date_str, "_example.html"))
# )
# rmarkdown::render(input="D:/source/ngsperl/lib/Report/StringDb.Rmd",
#                   #output_file=paste0(date_str, "_example.html"))
#                   output_file="example.html")
                  


copy_or_download<-function(source){
  target = paste0("./", basename(source))
  if(file.exists(source)){
    file.copy(source, target, overwrite=TRUE)
  }else{
    if(file.exists(target)){      
      file.remove(target)
    }
    download.file(source, target, "auto")
  }
}

copy_module_files=function(lib_folder="https://raw.githubusercontent.com/shengqh/ngsperl/master/lib") {
  #lib_folder="/nobackup/h_cqs/shengq2/program/ngsperl/lib"
  
  copy_or_download(paste0(lib_folder, "/Report/pathway.Rmd"))
  copy_or_download(paste0(lib_folder, "/Report/gene_exp.Rmd"))
  copy_or_download(paste0(lib_folder, "/Report/TissueExpression.PipelineSub.Rmd"))
  #copy_or_download(paste0(lib_folder, "/Report/tissue_specificity.Rmd"))
  copy_or_download(paste0(lib_folder, "/Report/StringDb.Rmd"))
  copy_or_download(paste0(lib_folder, "/CQS/countTableVisFunctions.R"))
}

copy_report_files=function(lib_folder="https://raw.githubusercontent.com/shengqh/cqsperl/master/") {
  #lib_folder="/nobackup/h_cqs/shengq2/program/cqsperl/examples/tissue_enrichment"
  
  copy_or_download(paste0(lib_folder, "/examples/tissue_enrichment/reportByModules.Rmd"))
  copy_or_download(paste0(lib_folder, "/examples/tissue_enrichment/reportFunctions.R"))

}


prepare_analysis_parameters=function(
    target_genes,
    background_genes=NULL,
    prefix=format(Sys.time(), "%Y%m%d"),
    
    perform_pathway = T,
    perform_tissue_specificity = T,
    perform_gene_exp_heatmap = T,
    perform_stringdb = T,
    perform_singscore = T,
    
    organism="hsa", #"mmu"
    
    referenceFolder="/nobackup/h_cqs/references/", #"X:/h_cqs/references/"
    
    pathway_parameter_list=list(
      pathway_analysis_sets = c("KEGG", "Reactome", "WikiPathways"),
      fromType = "SYMBOL", #target and background genes
      pathway_toType = "ENTREZID" #pathway analysis db ids
    ),
    tissue_specificity_parameter_list=list(
      proteinAtlasDatabaseFile = file.path(referenceFolder,"tissue_specific","proteinatlas.tsv"),
      database_gene = "ENSEMBL", #What gene annotation is in the gene_exp file
      colNameGenes = "EntrezGeneSymbol",
      horizontalHeatmap=FALSE
    ),
    gene_exp_parameter_list=list(
      gene_exp_file = file.path(referenceFolder,"tissue_specific","20230627_tabula_logNorm_averageExpression_matrix_by_tissueOnly.txt.gz"),
      fromType = "SYMBOL", #target and background genes
      gene_exp_toType = "ENSEMBL", #pathway analysis db ids
      perform_gene_exp_5perc=TRUE,
      draw_gene_exp_heatmap_5perc_global=TRUE
    )
) {
  stringdb_parameter_list=list(
    confidence = 700,
    hubGeneMin=5,
    STRINGdb_directory="d:\\temp\\",
    #STRINGdb_directory=""
    exportToCytoscape=TRUE
  )
  
  
  pathway_parameter_list[["organism"]]=organism
  gene_exp_parameter_list[["organism"]]=organism
  if (organism=="hsa") {
    OrgDb="org.Hs.eg.db"
    speciesId=9606
  } else if (organism=="mmu") {
    OrgDb="org.Mm.eg.db"
    speciesId=10090
  } else {
    stop("organism not supported")
  }
  pathway_parameter_list[["OrgDb"]]=OrgDb
  gene_exp_parameter_list[["OrgDb"]]=OrgDb
  stringdb_parameter_list[["species"]]=speciesId
  
  return(list(
    target_genes=target_genes,
    prefix=prefix,
    background_genes=background_genes,
    
    perform_pathway = perform_pathway,
    perform_tissue_specificity = perform_tissue_specificity,
    perform_gene_exp_heatmap = perform_gene_exp_heatmap,
    perform_stringdb = perform_stringdb,
    perform_singscore = perform_singscore,
    
    pathway_parameter_list = pathway_parameter_list,
    tissue_specificity_parameter_list = tissue_specificity_parameter_list,
    gene_exp_parameter_list = gene_exp_parameter_list,
    stringdb_parameter_list=stringdb_parameter_list
  ))
}



