cases_by_age <- aggregate(esoph$ncases, by=list(agegp = esoph$agegp), FUN = sum)
controls_by_age <- aggregate(esoph$ncontrols, by=list(agegp = esoph$agegp), FUN = sum)
total_cases <- sum(esoph$ncases)

#library(dplyr)
#esoph %>%
#    group_by(agegp) %>%
#    summarise(ncases = sum(ncases))

percentage_of_total <- cases_by_age$x * 100 / controls_by_age$x

vect_col <- c("hotpink", "green", "blue", "red", "yellow", "cyan")

barplot ( height = percentage_of_total,
          names.arg = cases_by_age$agegp,
          xlab = "Categorie de varsta",
          ylab = "Procentaj de cazuri",
          col = vect_col,
          cex.main = 0.7)
 #------------------------------------------------------------------------------------
tob1 <- subset(esoph, subset = tobgp == "0-9g/day")
cases_by_age_tobacco1 <- aggregate(cbind(tob1$ncases, tob1$ncontrols), by=list(agegp = tob1$agegp), FUN=sum)
cases_by_age_tobacco1
proc_tob1 <- cases_by_age_tobacco1$ncases*100/cases_by_age_tobacco1$ncontrols
proc_tob1

tob2 <- subset(esoph, subset = tobgp == "10-19")
cases_by_age_tobacco2 <- aggregate(cbind(tob2$ncases, tob2$ncontrols), by=list(agegp = tob2$agegp), FUN=sum)
cases_by_age_tobacco2
proctb2 <- cases_by_age_tobacco2$V1*100/cases_by_age_tobacco2$V2
proctb2

tob3 <- subset(esoph, subset = tobgp == "20-29")
cases_by_age_tobacco3 <- aggregate(cbind(tob3$ncases, tob3$ncontrols), by=list(agegp = tob3$agegp), FUN=sum)
cases_by_age_tobacco3
proctb3 <- cases_by_age_tobacco3$V1*100/cases_by_age_tobacco3$V2
proctb3
tob4 <- subset(esoph, subset = tobgp == "30+")
cases_by_age_tobacco4 <- aggregate(cbind(tob4$ncases, tob4$ncontrols), by=list(agegp = tob4$agegp), FUN=sum)
cases_by_age_tobacco4
proctb4 <- cases_by_age_tobacco4$V1*100/cases_by_age_tobacco4$V2
proctb4

#-------------------------------------------------------------------------------------
tob_t <- cbind("0-9"=proctb1, "10-19"=proctb2, "20-29"=proctb3, "30+"=proctb4)
vect_col4 <- c("blue", "red", "yellow", "green")
barplot(proc_tob1,
        names.arg = cases_by_age$agegp,
        xlab = "Categorie varsta",
        ylab = "Procentaj cazuri",
        col = vect_col4,
        beside=TRUE,
        #legend("topleft", legend=cases_by_age$agegp, fill=vect_col4)
        )

#------------------------------------------------------------------------------------
alc1 <- subset(esoph, subset = alcgp == "0-39g/day")
cases_by_age_alcohol1 <- aggregate(cbind(alc1$ncases, alc1$ncontrols), by=list(agegp = alc1$agegp), FUN=sum)
cases_by_age_alcohol1
procalc1 <- cases_by_age_alcohol1$V1*100/cases_by_age_alcohol1$V2
procalc1

alc2 <- subset(esoph, subset = alcgp == "40-79")
cases_by_age_alcohol2 <- aggregate(cbind(alc2$ncases, alc2$ncontrols), by=list(agegp = alc2$agegp), FUN=sum)
cases_by_age_alcohol2
procalc2 <- cases_by_age_alcohol2$V1*100/cases_by_age_alcohol2$V2
procalc2

alc3 <- subset(esoph, subset = alcgp == "80-119")
cases_by_age_alcohol3 <- aggregate(cbind(alc3$ncases, alc3$ncontrols), by=list(agegp = alc3$agegp), FUN=sum)
cases_by_age_alcohol3
procalc3 <- cases_by_age_alcohol3$V1*100/cases_by_age_alcohol3$V2
procalc3

alc4 <- subset(esoph, subset = alcgp == "120+")
cases_by_age_alcohol4 <- aggregate(cbind(alc4$ncases, alc4$ncontrols), by=list(agegp = alc4$agegp), FUN=sum)
cases_by_age_alcohol4
procalc4 <- cases_by_age_alcohol4$V1*100/cases_by_age_alcohol4$V2
procalc4

#-------------------------------------------------------------------------------------
alc_t <- cbind("0-39"=procalc1, "40-79"=procalc2, "80-119"=procalc3, "120+"=procalc4)
vect_col5 <- c("blue", "red", "yellow", "green")
barplot(t(alc_t),
        names.arg = cases_by_age$agegp,
        xlab = "Categorie varsta",
        ylab = "Procentaj cazuri",
        col = vect_col5,
        beside=TRUE,
        #legend("topleft", legend=cases_by_age$agegp, fill=vect_col4)
)
#-------------------------------------------------------------------------------------
probabilitate <- function (age, alc, tob)
{
  if(age<25)
  {
    stop("Varsta minima este 25")
  }
  if(age>=25&&age<=34)
  {
    vage <- subset(esoph, subset = agegp == "25-34")
  }
  if(age>=35&&age<=44)
  {
    vage <- subset(esoph, subset = agegp == "35-44")
  }
  if(age>=45&&age<=54)
  {
    vage <- subset(esoph, subset = agegp == "45-54")
  }
  if(age>=55&&age<=64)
  {
    vage <- subset(esoph, subset = agegp == "55-64")
  }
  if(age>=65&&age<=74)
  {
    vage <- subset(esoph, subset = agegp == "65-74")
  }
  if(age>=75)
  {
    vage <- subset(esoph, subset = agegp == "75+")
  }
  
  
  if(alc<0)
  {
    stop("Cantatitea de alcool nu poate fi negativa")
  }
  if(alc>=0&&alc<=39)
  {
    valc <- subset(vage, subset = alcgp == "0-39g/day")
  }
  if(alc>=40&&alc<=79)
  {
    valc <- subset(vage, subset = alcgp == "40-79")
  }
  if(alc>=80&&alc<=119)
  {
    valc <- subset(vage, subset = alcgp == "80-119")
  }
  if(alc>=120)
  {
    valc <- subset(vage, subset = alcgp == "120+")
  }
  
  if(tob<0)
  {
    stop("Cantatitea de tutun nu poate fi negativa")
  }
  if(tob>=0&&tob<=9)
  {
    vtob <- subset(valc, subset = tobgp == "0-9g/day")
  }
  if(tob>=10&&tob<=19)
  {
    vtob <- subset(valc, subset = tobgp == "10-19")
  }
  if(tob>=20&&tob<=29)
  {
    vtob <- subset(valc, subset = tobgp == "20-29")
  }
  if(tob>=30)
  {
    vtob <- subset(valc, subset = tobgp == "30+")
  }
  if(length(vtob$ncases)>0)
  {
    controlsage <- sum(vage$ncontrols)
    result <- vtob$ncases*100/controlsage
    return(result)
  }
  else
  {
    warning("Nu exista memorata combinatia de valori")
  }
} 
