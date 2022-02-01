setlocal

cd C:\Tools\GSEA_4.2.1\
jdk-11\bin\javaw --module-path=modules -Xmx4g -Djava.awt.headless=true @gsea.args --patch-module=jide.common=lib\jide-components-3.7.4.jar;lib\jide-dock-3.7.4.jar;lib\jide-grids-3.7.4.jar --module=org.gsea_msigdb.gsea/xapps.gsea.CLI  %*
