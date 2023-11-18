#Q01
present = read.table("present.txt", header = TRUE)
present
present$year
dim(present)
names(present)

#Q02
with(present, plot(boys/girls, type = 'l', xlab = 'Year', ylab = 'Boys/Girls Ratio'))
with(present, plot(boys/(boys+girls), type = 'l', xlab = 'Year', ylab = 'Proportion of Boys'))
with(present, plot(girls/(boys+girls), type = 'l', xlab = 'Year', ylab = 'Proportion of Girls'))
#In U.S, Boys being born is in greater proportion than the Girls

#Q03
index = with(present, which.max(boys+girls))
present$year[index]