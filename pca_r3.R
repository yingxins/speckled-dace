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
covar <- read.table("spk_bamlist_r3_pca.covMat", stringsAsFact=FALSE);

# Read annot file
annot <- read.csv("spk_r3.csv", header = FALSE); # note that plink cluster files are usually tab-separated instead
#annot <- annot[-c(1),]
colnames(annot)[1] = "FID"
colnames(annot)[2] = "IID"
colnames(annot)[3] = "CLUSTER"
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
#PC$Tra <- gsub("_Speckled_Dace", "", PC$Tra)
#PC$Tra <- gsub("_", " ", PC$Tra)
#PC$Tra

PC$Pop <- factor(PC$Pop, levels = c("Santa Ana","Colorado", "Washington","Columbia", "Bonneville"))

x_axis = paste("PC",comp[2],sep="")
y_axis = paste("PC",comp[2]+1,sep="")
pca1 <- PC %>% ggplot(aes_string(x=x_axis, y=y_axis,color="Pop")) +  #geom_mark_ellipse(aes(fill = Group, group = Group),expand = unit(5, "mm"), con.border = "none") + 
  geom_point(size = 3, alpha = 0.8) +
  scale_shape_manual(values=c(11, 20)) + 
  scale_color_manual(values = c( "#690648","#EC7357","#f71e21","#cc7dfa", "#733dd1" ))+
  ggtitle(title) + theme_void() +  theme(legend.position = "bottom", 
                                         legend.box = "vertical", 
                                         legend.title = element_text(face = "bold", size = 16), 
                                         legend.text = element_text(size = 14, face = "bold"), 
                                         plot.title = element_text(size = 18, face = "bold") ) +
  theme(axis.text = element_text(size = 10, face = "bold"), 
        axis.title = element_text(size = 13, face = "bold"), 
        axis.line = element_line(size = 1.2),
        axis.title.y = element_text(angle = 90))+
  labs(color = "Location") + 
  guides(size = FALSE) + guides(color = guide_legend(order=1), shape = guide_legend(order = 2), group = guide_legend(order =3)) 


pca1
pca4 <- PC %>% ggplot(aes_string(x=x_axis, y=y_axis,color="Pop")) +  #geom_mark_ellipse(aes(fill = Group, group = Group),expand = unit(5, "mm"), con.border = "none") + 
  geom_point(size = 3, alpha = 0.8) +
  scale_shape_manual(values=c(11, 20)) + 
  scale_color_manual(values = c( "#690648","#EC7357","#f71e21","#cc7dfa", "#733dd1" ))+
  ggtitle(title) + theme_void() +  theme(legend.position = "bottom", 
                                         legend.box = "vertical", 
                                         legend.text = element_text(size = 14, face = "bold"), 
                                         plot.title = element_text(size = 18, face = "bold"),
                                         legend.title = element_blank()) +
  theme(axis.text = element_text(size = 10, face = "bold"), 
        axis.title = element_text(size = 13, face = "bold"), 
        axis.line = element_line(size = 1.2),
        axis.title.y = element_text(angle = 90))+
  guides(size = FALSE) + guides(color = guide_legend(order=1), shape = guide_legend(order = 2), group = guide_legend(order =3)) 
write.table(PC, file = "PC_scores.txt", quote = FALSE)
pca4
legend4 <- get_legend(pca4)
plot_grid(legend,legend2,legend4,nrow=3)
value <- data.frame(eig$val[1:30])
value$num <- seq(1,30,1) 
colnames(value)[1] = "val"
value %>% ggplot(aes(x=num, y = val)) + geom_bar(stat = "identity") +
  theme_void()+
  labs(title="Genetic Variation Explained by PC1-PC30 in Group 3", y ="", x = "PC") +
  theme(axis.text = element_text(size = 10, face = "bold"),
        axis.title = element_text(size = 12, face = "bold"), 
        axis.line = element_blank(),
        axis.title.y = element_text(angle = 90),
        plot.title = element_text(size = 14, face = "bold"))
