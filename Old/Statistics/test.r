 source("teamMember.r")
 
 test<- read.table("uniq_list_awards_without_numbers.txt",sep="#",stringsAsFactors=FALSE)
 
 (test[2:20,1])
(scoringFunc(test[2:22,1],awardScores))
(scoringFunc(c(test[2:22,1],"best presentation"),awardScores))

data.frame(teststr=test,
calc_score=
apply(test, 1, scoringFunc, awardScores)
)
