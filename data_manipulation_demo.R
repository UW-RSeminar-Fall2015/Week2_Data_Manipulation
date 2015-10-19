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
birds$species
as.factor(birds$species) -> f
levels(f)
unique(birds$species)


## Extract vectors/values from data frames using indices
birds$species
birds[,"species"]
birds[,2] # Second column; this format useful for automation
birds[1,] # First row
birds[1,"duration"] # 2nd row
birds[c(1,3),"duration"] # duration from 1st & 3rd rows
4 -> birds[1,"duration"]

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

## vapply equivalent (specifies the data structure of function return)
vapply(a,function(x){length(x$species)},FUN.VALUE=1) -> b

## lapply equivalent (returns list of same length as a)
lapply(a,function(x){length(x$species)}) -> b
str(b)
b[["AMCR"]]
unlist(b)

## apply - applies function across margins of matrix or array
matrix(1:81,9) -> m
m
apply(m,1,sum) #rows
apply(m,2,sum) #columns
rowSums(m) #Built-in equivalent (sums and means only)
colSums(m)
apply(m,2,function(x){      #each x is a matrix column
  sapply(x,function(y){       #apply functions can be nested
    if (y %% 2 == 0) {y} else {y*2}  #each y is element of column x
  }) # end of sapply
}) # end of apply

matrix(rep_len(c(2,1),81) * 1:81 ,9)  #(but this is better)

## mapply - vectorizes across multiple arguments
mapply(rep, 1:4, 4:1)
mapply(rep,time=1:4,x=4:1)



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
####################### PLYR Package
#install.packages(plyr)
library(plyr)
## plyr package
##     written by Hadley Wickham (), along with ggplot2, dplyr
## Takes a given data structure, 
##       splits it into groups, applies some summary or function to each group of data, 
##       combines back to a data structure
## transform vs summarize
##        transform adds the computation or function back to the original data
##        summarize creates a new data structure containing the summarized (group) results

## Most Basic ddply: using a database, split, apply, combine and output a dataframe
## general syntax: ddply(data.frame, variable(s), function, optional arguments)

## Going back to the for loop example:  Number of species per stop in Everett data
head(everett)
str(everett)
numeric(0) -> p # Numeric vector of length zero (empty)
for (i in 1:50){
	subset(everett,everett$point==i) -> a
	append(p,length(unique(a$species))) -> p
}
num.spp.loop <- cbind(1:50, p)
dimnames(num.spp.loop)[[2]] <- c('point','num_spp')
head(num.spp.loop)
## using ddply
num.spp.plyr <- ddply(everett, .(point), summarize,
		num_spp = length(species))
head(num.spp.plyr)

## sapply example: Total of each species
## another sapply example
split(everett,everett$species) -> a
a[[1]]
sapply(a,function(x){sum(x$count)}) -> b

str(b)
head(b)
## using plyr
totl.spp.plyr <- ddply(everett, .(species), summarize,
		totl_spp_count = sum(count))
head(totl.spp.plyr)
## the more complex example
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
## using plyr
##    note can string as many functions together as needed
summary.spp.plyr <- ddply(everett, .(species), summarize,
		total = sum(count), #total number of each species, can omit any NAs with sum(count, na.rm=TRUE)
		npoints = length(point), # number of points where species was encountered
		meancars = mean(cars) # mean number of cars, can omit any NAs with mean(cars, na.rm=TRUE)
)
head(summary.spp.plyr)

####################################################
## try some other structures and more complex data
#options(width = 180)
names(birds)
head(birds)
## number of birds by species
length(unique(birds$species)) # number of different species
length(unique(birds$id)) # number of individual birds
table(birds$species, useNA='ifany')
table(birds$species, birds$sex, useNA='ifany')

ddply (birds, .(species, sex), summarize,
		num_birds = length(id),
		mean_fat = mean(fat),
		var_fat = var(fat)
		)
		
bird.summry.dat <- ddply (birds, .(species), summarize,
    	num_birds_all = length(id),
		mean_fat_all = round(mean(fat),2),
		var_fat_all = round(var(fat),4),
		
		num_birds_F = length(id[which(sex == 'F')]),
	    mean_fat_F = round(mean(fat[which(sex == 'F')]),2),
		var_fat_F = round(var(fat[which(sex == 'F')]),4)
		)
		
bird.summry.dat$pct_Female <- bird.summry.dat$num_birds_F / bird.summry.dat$num_birds_all
bird.summry.dat

## transform example
##    add a new variable to existing data frame: pct_fat = fat/mass
dim(birds)
head(birds)
birds <- ddply (birds, .(species, sex), transform,
		pct_fat = round(fat/mass,2)
)
dim(birds)
head(birds)
## get the original data file back
read.csv("birds.csv",header=T,stringsAsFactors=F,na.strings="") -> birds
head(birds)
names(birds)
## or create a new data frame ~ note it has the same number of records as original 
birds.plus <- ddply (birds, .(species, sex), transform,
		pct_fat = round(fat/mass,2)
)
dim(birds.plus)
head(birds.plus)
tail(birds.plus)
birds.plus[c(1:3,16:18,31:33,46:49,64:66),]

##  add both a new variable (pct_mass) and summary variables number of birds of each gender and mean fat of birds of each gender
head(birds)
ddply (birds, .(species, sex), summarize,
		num_birds = length(id),
		mean_fat = mean(fat),
		var_fat = var(fat)
) ## the group summaries for reference

birds.plus <- ddply (birds, .(species, sex), transform,
		pct_fat = round(fat/mass,2),
		num_birds_spp_sex = length(id),
		mean_fat_spp_sex = round(mean(fat),2)
)
dim(birds.plus)
birds.plus[c(1:3,16:18,31:33,46:49,64:66),]
head(birds.plus)
tail(birds.plus)

## Lastly using other data structures
##    input a dataframe, for each species determine the number of birds, number of each species, the mean and var of fat, output as a list
bird.list <- dlply(birds, .(species), summarize,
		num_birds = length(id),
		num_F = length(id[which(species=='F')]),
        num_M = length(id[which(species=='M')]),
		mean_fat = mean(fat),
		var_fat = var(fat)
		)
str(bird.list)
bird.list

