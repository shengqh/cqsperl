
.libPaths(c("/data/cqs/references/scrna/azimuth", .libPaths()))
library(Azimuth)
library(SeuratData)
refs=AvailableData()
for (cur_ref in refs$Dataset) { 
  cat("InstallData(", cur_ref, ")\n")
  InstallData(cur_ref) 
}
