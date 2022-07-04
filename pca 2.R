# Usage: Rscript -i infile.covar -c component1-component2 -a annotation.file -o outfile.eps

library(optparse)
library(ggplot2)
library(ggforce)
library(concaveman)
library(tidyverse)

option_list <- list(make_option(c('-i','--in_file'), action='store', type='character', default=NULL, help='Input file (output from ngsCovar)'),
                    make_option(c('-c','--comp'), action='store', type='character', default=1-2, help='Components to plot'),
                    make_option(c('-a','--annot_file'), action='store', type='character', default=NULL, help='Annotation file with individual classification (2 column TSV with ID and ANNOTATION)'),
                    make_option(c('-o','--out_file'), action='store', type='character', default=NULL, help='Output file')
)
opt <- parse_args(OptionParser(option_list = option_list))

# Annotation file is in plink cluster format

#################################################################################

# Read input file
covar <- read.table("spk_bamlist_pca.covMat", stringsAsFact=FALSE);

# Read annot file
annot <- read.csv("spk_bamlist_pca.csv", header = TRUE); # note that plink cluster files are usually tab-separated instead
#annot <- annot[-c(1),]
colnames(annot)[1] = "FID"
colnames(annot)[2] = "IID"
colnames(annot)[3] = "CLUSTER"
annot1 <- separate(annot,col=FID,into=c("Plate","Barcode"),sep="_")
annot1$Plate <- gsub("SOMM","DNA",annot1$Plate)

# Parse components to analyze
comp <- as.numeric(strsplit(opt$comp, "-", fixed=TRUE)[[1]])
# Eigenvalues
eig <- eigen(covar, symm=TRUE);
eig$val <- eig$val/sum(eig$val);
cat(signif(eig$val, digits=3)*100,"\n");

# Plot
PC <- as.data.frame(eig$vectors)
colnames(PC) <- gsub("V", "PC", colnames(PC))
PC$Pop <- factor(annot$CLUSTER)
PC$Tra <- factor(annot$IID)
PC$Lab <- factor(annot$FID)
PC$Plate <- factor(annot1$Plate)
#PC$Tra <- gsub("_Speckled_Dace", "", PC$Tra)
#PC$Tra <- gsub("_", " ", PC$Tra)
#PC$Tra
PC$Group <- factor(annot$GROUP)
#PC$Group <- gsub("_", " ", PC$Group)
title <- paste("PC",comp[2]," (",signif(eig$val[comp[2]], digits=3)*100,"%)"," / PC",comp[2]+1," (",signif(eig$val[comp[2]+1], digits=3)*100,"%)",sep="",collapse="")
PC$Pop <- factor(PC$Pop, levels = c("Amargosa", "Owens","Long Valley", "Lahontan",  "Butte","Central California", "Klamath","Sacramento", "Warner","Bonneville" , "Columbia","Santa Ana", "Colorado", "Washington"))

x_axis = paste("PC",comp[2],sep="")
y_axis = paste("PC",comp[2]+1,sep="")
pca1 <- PC %>% ggplot(aes_string(x=x_axis, y=y_axis,color="Pop")) +   
  geom_mark_ellipse(aes(fill = Group, group = Group, label = Group),expand = unit(8, "mm"),
                    con.type = "straight", 
                    con.border = "none", 
                    con.size = 1,
                    label.lineheight = 0,
                    label.fontsize = 12) + 
  geom_point(size = 2,alpha=0.9,position=position_jitter(0.005)) +
  scale_fill_manual(values=c("#6bc5d2","#e688a1","#e3c878"))+
  scale_color_manual(values = c("#463730", "#94524A","#666309", "#ba931e",
                                "#08039e", "#3694f7", "#1E441E",  "#0e31b0",  "#4CE0D2", 
                                "#733dd1","#cc7dfa", "#690648",  "#EC7357","#f71e21" ))+
  ggtitle(title) + theme_void() +
  theme(legend.position = "none", 
        legend.box = "horizontal", 
        legend.title = element_text(face = "bold", size = 14), 
        legend.text = element_text(size = 13, face = "bold"),
        plot.title = element_text(size = 18, face = "bold") ) +
  theme(axis.text = element_text(size = 10, face = "bold"), 
        axis.title = element_text(size = 13, face = "bold"), 
        axis.line = element_line(size = 1.2),
        axis.title.y = element_text(angle = 90))+
 #guide_legend(title.position = "top")+
  labs(color = "Location") + 
  guides(size = FALSE, 
         fill = FALSE) + 
  guides(color = guide_legend(order=1, 
                              title.position = "top")) 
pca_plate <- PC %>% ggplot(aes_string(x=x_axis, y=y_axis,color="Plate")) +   
  geom_mark_ellipse(aes(fill = Group, group = Group, label = Group),expand = unit(8, "mm"),
                    con.type = "straight", 
                    con.border = "none", 
                    con.size = 1,
                    label.lineheight = 0,
                    label.fontsize = 12) + 
  geom_point(size = 2,alpha=0.9,position=position_jitter(0.005)) +
  scale_fill_manual(values=c("#6bc5d2","#e688a1","#e3c878"))+
  scale_color_manual(values = c("#463730", "#94524A","#666309", "#ba931e",
                                "#08039e", "#3694f7", "#1E441E",  "#0e31b0",  "#4CE0D2", 
                                "#733dd1","#cc7dfa", "#690648",  "#EC7357","#f71e21" ))+
  ggtitle(title) + theme_void() +
  theme(legend.box = "horizontal", 
        legend.title = element_text(face = "bold", size = 14), 
        legend.text = element_text(size = 13, face = "bold"),
        plot.title = element_text(size = 18, face = "bold") ) +
  theme(axis.text = element_text(size = 10, face = "bold"), 
        axis.title = element_text(size = 13, face = "bold"), 
        axis.line = element_line(size = 1.2),
        axis.title.y = element_text(angle = 90))+
  #guide_legend(title.position = "top")+
  labs(color = "Plate") + 
  guides(size = FALSE, 
         fill = FALSE) + 
  guides(color = guide_legend(order=1, 
                              title.position = "top")) 
pca_plate
plot_grid(pca1, legend1, ncol=1, rel_heights = c(1,0.2))
pca1
write.table(PC, file = "PC_scores.txt", quote = FALSE)
value <- data.frame(eig$val[1:30])
value$num <- seq(1,30,1) 
colnames(value)[1] = "val"
value %>% ggplot(aes(x=num, y = val)) + geom_bar(stat = "identity") +
  theme_void()+
  labs(title="Genetic Variation Explained by PC1-PC30 in All Samples", y ="", x = "PC") +
  theme(axis.text = element_text(size = 10, face = "bold"),
        axis.title = element_text(size = 12, face = "bold"), 
        axis.line = element_blank(),
        axis.title.y = element_text(angle = 90),
        plot.title = element_text(size = 14, face = "bold"))