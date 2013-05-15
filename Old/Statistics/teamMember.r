library(rjson)
library(ggplot2)

awardScores <- data.frame(
  rbind(
    c("grand prize",48),
    c("1st runner up",32),
    c("2nd runner up",19),
    c("advance to championship",27),
    c("finalist",52),
    c("grand prize winner, (?=America|Asia|Europe)",41), # regional round
    # this matches hopefully all additional prizes
    c("best (?!wiki|poster|presentation)",31),
    c("best (?!wiki|poster|presentation) (?=America|Asia|Europe)",13),
    c("best wiki",21),
    c("best poster",19),
    c("best presentation",21),
    c("gold",22),
    c("silver",15),
    c("bronze",8)
  )
)
names(awardScores)<-c("pattern","weight")

# this approach is not efficient, since their is unneccesary multiple matching
#medalScores <- data.frame(
#  pattern=c("gold",
#    "silver",
#    "bronze"
#    ),
#  score=c(22,15,8)
#)

scoringFunc <- function(tomatchList, scoresDataFrame) {
  sum(
    apply(scoresDataFrame, MARGIN=1, function(item){
      resVec <- grep(item[1], tomatchList, ignore.case=TRUE, perl=TRUE)
      as.integer(item[2])*length(resVec)
    })
  )
}

#scoringFunc <- function(tomatchList, scoresDataFrame) {
#  res <-
#    apply(scoresDataFrame, MARGIN=1, function(item){
#      resVec <- grep(item[1], tomatchList, ignore.case=TRUE)
#      # could do check whether there are no matched valus...
#      notMatched <-tomatchList[resVec==0]
#      if(length(notMatched==0)){
#        message("not matched:", notMatched)
#      }
#      as.integer(item[2])*length(resVec)
#    })
#  sum(res)
#}



json <- fromJSON(file ="whole_dataset_with_members.json")
teams <- lapply(json, function(team) {
  t <- data.frame(Year=team$year,
                  Name=team$name,
                  Score=scoringFunc(c(team$award,team$medal),awardScores),
                  Medal=team$medal,
                  Instructors=length(team$teamMembers$Instructors),
                  Advisors=length(team$teamMembers$Advisors),
                  Student_Members=length(team$teamMembers$Student_Members),
                  Others=length(team$teamMembers$Others)
                  )
  t
})
teams <- do.call(rbind, teams)
#Score Normalization by Year
for(y in c(2008:2011)) {
  m <- max(teams$Score[teams$Year==y])
  teams$ScoreN[teams$Year==y] <- teams$Score[teams$Year==y]/m
}

# Qualification -Fraction
#teams$qfrac <- (teams$Instructors + teams$Advisors)/(teams$Student_Members+teams$Others)
teams$qfrac <- (teams$Instructors + teams$Advisors)/(teams$Student_Members)
# teamCount
teams$tc <- teams$Instructors+teams$Advisors+teams$Student_Members+teams$Others

#qplot(qfrac, data = teams, geom = "density", colour=as.factor(Year))
#qplot(qfrac, data = teams, geom = "histogram", colour=Medal, binwidth=0.1)
#qplot(qfrac, data = teams, geom = "density", colour=as.factor(Awards))
#qplot(tc, data = teams, geom = "density", colour=as.factor(Year))
# qplot(Student_Members+Others,ScoreN, data = teams, geom = "point", colour=as.factor(Year))
#ggplot(data=teams,aes(x=qfrac,y=ScoreN,colour=as.factor(Year)))+geom_point()

#best teams?
teams[teams$ScoreN>=0.75,]
#teams[teams$qfrac>=1.8,1:4,9]


# scoringFunc(c(json[[5]]$award,json[[5]]$medal),awardScores)
