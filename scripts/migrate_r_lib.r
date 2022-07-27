if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

old.lib.loc<-"C:/Tools/R-4.2.1.old/library"
new.lib.loc<-"C:/Tools/R-4.2.1/library"

get_pkgs<-function(lib.loc){
  result = rownames(installed.packages(lib.loc=lib.loc))
  return(result)
}

oldpkgs=get_pkgs(old.lib.loc)
newpkgs=get_pkgs(new.lib.loc)

misspkgs=setdiff(oldpkgs, newpkgs)

for(oldpkg in misspkgs){
  newpkgs=get_pkgs(new.lib.loc)
  if(!(oldpkg %in% newpkgs)){
    BiocManager::install(oldpkg, lib=new.lib.loc)
  }
}
