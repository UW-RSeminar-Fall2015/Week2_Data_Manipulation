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
ncol(birds)
dim(birds)

## Data classes & coersion
str(birds)
class(birds)
class(birds$id)
as.character(birds$id) -> birds$id
class(birds$id)
as.numeric(birds$id) -> birds$id
class(birds$id)
birds$species
as.factor(birds$species) -> f
f
levels(f)
unique(birds$species)


## Access vectors/values from data frames using indices
birds$species
birds[,"species"]
birds[,2] # Second column; this format useful for automation
birds[1,] # First row
birds[1,"duration"] # 1st row, duration value
birds[c(1,3),"duration"] # duration from 1st & 3rd rows
4 -> birds[c(1,3),"duration"]
birds[c(1,3),"duration"]

## Other vector functions worth mentioning
"NOWA" %in% birds$species
birds$species %in% "NOWA" #"NOWA" is a character vector length 1
union(1:10,5:15)

## Subsetting
subset(birds,birds$species=="NOWA") -> a
str(a)
which(birds$species=="NOWA") # Vector of indices when condition true
which(birds$species!="NOWA") # Vector of indices when condition false
which(!birds$species=="NOWA") # Negate any logical vector with "!"
!TRUE
birds[which(birds$species=="NOWA"),] -> a  ## Alternative to subset()
str(a)

## Lists & list indexing
list(1:5,letters[1:5],month.name[1:5],
     matrix(data=1:4,2,2,byrow=T),list(1:3,2:4,3:5)) -> a
str(a)
a
a[[2]]
a[[2]][1]
a[[4]]
a[[4]][1,2]
a[[5]]
a[[5]][[2]]
a[[5]][[2]][2]

## For loop example:  Number of species per point in Everett data
head(everett)
numeric(0) -> p # Numeric vector of length zero (empty)
p
for (i in 1:50){
  subset(everett,everett$point==i) -> a
  append(p,length(unique(a$species))) -> p
}
p

## sapply example
split(everett,everett$point) -> a
class(a)
head(a,2)
a[[40]]
sapply(a,function(x){length(x$species)}) -> b
b
str(b)
unname(b)

## vapply equivalent (specifies the data structure of function return)
vapply(a,function(x){length(x$species)},FUN.VALUE=1) -> b
unname(b)

## lapply equivalent (returns list of same length as a)
lapply(a,function(x){length(x$species)}) -> b
str(b)
b
unname(unlist(b))

## apply - applies function across margins of matrix or array
matrix(1:81,9) -> m
m
apply(m,1,sum) #rows
apply(m,2,sum) #columns
rowSums(m) #Built-in equivalent (sums and means only)
colMeans(m)
## Apply functions can be nested
apply(m,2,function(x){      #each x is a matrix column
  sapply(x,function(y){       #each y is element of column x
    if (y %% 2 == 0) {y} else {y*2}  #Multiply by 2 if odd
  }) # end of sapply
}) # end of apply

matrix(rep_len(c(2,1),81) * 1:81 ,9)  #simpler equivalent

## mapply - vectorizes across multiple arguments
mapply(rep, 1:4, 4:1) #specifying arguments by default order
mapply(rep,times=1:4,x=4:1) #specifying arguments directly

## Sapply example: Total count for each species
split(everett,everett$species) -> a
a[[1]]
sapply(a,function(x){sum(x$count)}) -> b
b
#write.csv(b,"species_totals.csv")

## More complex sapply example: Return 3 calculations per species.
split(everett,everett$species) -> a
a[[1]]
sapply(a,function(x){
  sum(x$count) -> total   # Total number of individuals counted
  length(x$point) -> npoints # Number of points where encountered
  mean(x$cars) -> meancars # Mean no. of cars on points where encountered
  return(c("total"=total,"npoints"=npoints,"meancars"=meancars))
}) -> b
str(b)  # It's a matrix
head(b) # It has species as columns, 3 quantities as rows
as.data.frame(t(b)) -> b  # Convert to data frame after transpose
str(b)
head(b)