##starting with a loop 
#making a list that contains all the files from "dat"

library(sangerseqR)

list.names<-list.files(path = path.expand("./Data"),pattern=".ab1$")
#the list "list.names" contain all the names of the file that end with "ab1"

list.sequence<-list()
#making a list that will contain all my files
setwd("./Data") #setting the working directory to the file "Data" so that the loop can understand the command
for(i in 1:length(list.names)){
  list.sequence[[i]]<-read.abif(list.names[i])
}
#for all the files in "dat", it is read into R
#list.sequence now is a list that contains all the files 

names(list.sequence)<-list.names
#adding names to the sequences (the original file names)

##Extracting sanger sequence
Y<-list() #list that will hold the extracted sanger sequences
for(i in 1:length(list.sequence)){
  Y[i]<-sangerseq(list.sequence[[i]])
}
#for every sequence file, the sanger sequence will be extracted and placed into a new list "Y"
#I ignored the warnings because I don't know how to fix them


##Primary and second basecalls
Primary<-list() #list that the basecalls will be contained
for (r in 1:length(Y)) {
  Primary[r]<-makeBaseCalls(Y[[r]])
}
#for all the sanger sequence, the basecalls will be extracted and placed into the new list "Primary"

#subsetting only the primary sequence
sequence<-list()
for(i in 1:length(Primary)){
  sequence[i]<-as.character(Primary[[i]]@primarySeq)
}
#Now all the primary sequences are in the list "sequence" but it is saved as a character vector because we want the final file as a vector of strings

##writing a FASTA file 

library(seqinr) #seqinr package to use the function write.fasta()
write.fasta(sequences=sequence,names=list.names,file.out="data.fasta")
#sequences = what vector we are using for the sequence, names == the names of sequences
#saved as "data.fasta"

###quality control 
control<-read.csv("BarcodePlateStats.csv") #reading out the file for quality control 

library(dplyr)
names<-control %>% filter(Ok=="TRUE") %>%
  select(Chromatogram) #getting only the names of the sequences that were "TRUE" in the quality check (column==Ok)

