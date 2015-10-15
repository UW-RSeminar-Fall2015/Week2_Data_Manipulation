## Directory info
getwd() # To change, use setwd()
list.files()
list.files(all.files=T)

## Import birds
read.csv("birds.csv",header=T,stringsAsFactors=F,na.strings="") -> birds
head(birds)
names(birds)

## Import everett
read.csv("everett.csv",header=T,stringsAsFactors=F) -> everett
head(everett)
names(everett)

## Data frame queries
nrow(birds)
dim(birds)

## Data classes & coersion
str(birds)
class(birds$id)
as.character(birds$id) -> birds$id
class(birds$id)
as.numeric(birds$id) -> birds$id
class(birds$id)

## Extract vectors/values from data frames using indices
birds$species
birds[,"species"]
birds[,2] # Second column; this format useful for automation
birds[1,] # First row
birds[1,"duration"] # 2nd row
birds[c(1,3),"duration"] # duration from 1st & 3rd rows
4 -> birds[1,"duration"]

## Subsetting
subset(birds,birds$species=="NOWA") -> a
str(a)
which(birds$species=="NOWA") # Vector of indices when condition true
birds[which(birds$species=="NOWA"),] -> a
str(a)

## Lists & list indexing
list(1:5,letters[1:5],month.name[1:5],
     matrix(data=1:4,2,2,byrow=T),list(1:3,2:4,3:5)) -> a
a
str(a)
a[[1]]
a[[2]][1]
a[[4]][1,2]
a[[5]][[2]][2]

## For loop example:  Number of species per stop in Everett data
head(everett)
numeric(0) -> p # Numeric vector of length zero (empty)
for (i in 1:50){
  subset(everett,everett$point==i) -> a
  append(p,length(unique(a$species))) -> p
}

## sapply example
split(everett,everett$point) -> a
head(a,2)
a[[40]]
sapply(a,function(x){length(x$species)}) -> b
unname(b)

## another sapply example
split(everett,everett$species) -> a
a[[1]]
sapply(a,function(x){sum(x$count)}) -> b
#write.csv(b,"species_totals.csv")

## More complex sapply example
split(everett,everett$species) -> a
a[[1]]
sapply(a,function(x){
  sum(x$count) -> total
  length(x$point) -> npoints
  mean(x$cars) -> meancars
  return(c("total"=total,"npoints"=npoints,"meancars"=meancars))
}) -> b
str(b)
head(b)
as.data.frame(t(b)) -> b
str(b)
head(b)

## Apply functions
