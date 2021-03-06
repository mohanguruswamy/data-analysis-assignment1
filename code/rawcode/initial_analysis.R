# Assignment 1




##############################################################
#loading data from the rda file, this loads the object loansData
library(ggplot2)

setwd(dir="/home/chitra/workspace-R/data-analysis-assignment1")
load("data/rawdata/loansData.rda")

#initial look into data
objects()
dim(loansData)
names(loansData)
head(loansData)

#any missing values
table(is.na(loansData))
# there are 7 records having NA
NA_records <- loansData[is.na(loansData),]
NA_records
#There is complete missing of data and can be safely removed from the original dataset
cleanData <- na.omit(loansData)
#confimring missing values
table(is.na(cleanData))

summary(cleanData)
#there is a negative amunt funded
cleanData[cleanData$Amount.Funded.By.Investors <= 0, ]

#seems some curruption in data or these loans are not processed, we can revome these values
cleanData <- cleanData[cleanData$Amount.Funded.By.Investors > 0, ]
#have look again to summary
summary(cleanData)

sapply(cleanData[1, ], class)
#converting the interest rate to numeric
cleanData$Interest.Rate <- gsub("%","",cleanData$Interest.Rate)
cleanData$Interest.Rate <- as.numeric(cleanData$Interest.Rate)

#converting the 'Debt to income ratio' to numeric
cleanData$Debt.To.Income.Ratio <- gsub("%","",cleanData$Debt.To.Income.Ratio)
cleanData$Debt.To.Income.Ratio <- as.numeric(cleanData$Debt.To.Income.Ratio)

str(cleanData)

# now it seems cleaned
#assigning to more sesnible name to the cleaned data
loanDataCleaned <- cleanData
remove(cleanData)
##Exploratory Analysis
#univariate plots

hist(loanDataCleaned$Amount.Requested,breaks=100)
#Analysis : It's right skewed 
#and spikes at the round figures like 5000, 10000, 15000, 20000, 25000, 30000, 35000

#try with density plot
ggplot(loanDataCleaned,aes(x = Amount.Requested))+geom_density()
#it seems to be gamma distribution

#amount requested vs amoutnt funded
plot(loanDataCleaned$Amount.Requested,loanDataCleaned$Amount.Funded.By.Investors)
#some of the funded amount is less then the requesed ones, this plot needs to be revisited for further investigation

hist(loanDataCleaned$Interest.Rate,breaks=30)
#pretty gaussian look, except a spike at sub 10%

table(loanDataCleaned$Loan.Length)
#36 months loan is roughly 3.5 times 60 months loan

plot(table(loanDataCleaned$Loan.Purpose),las=2,)
#debt_consolidation is very high

hist(loanDataCleaned$Debt.To.Income.Ratio)
boxplot(loanDataCleaned$Debt.To.Income.Ratio)
#looks ok, however range varies from 0 to 36 which is quite high for D/I ratio

table(loanDataCleaned$State)
plot(table(loanDataCleaned$State),las = 2)
#CA is very high, followed by NY

hist(log(loanDataCleaned$Monthly.Income),breaks=50)
#looks fine

table(loanDataCleaned$Home.Ownership)
#almost all the applicants either on RENT or on MORTGAGE

plot(table(loanDataCleaned$FICO.Range),las = 2)
# this is right skewed

hist(loanDataCleaned$Open.CREDIT.Lines)
hist(loanDataCleaned$Revolving.CREDIT.Balance)
hist(log(loanDataCleaned$Open.CREDIT.Lines))

hist(loanDataCleaned$Inquiries.in.the.Last.6.Months)
plot(table(loanDataCleaned$Employment.Length),las = 2)
#experiance more than 10+years is high, ihis might because all the applicants having
# more than 10 years of experiance gouped under this

## ANalyse the bivariants specially with respect to interest rate
#starting with intestest rate and FICO score
boxplot(loanDataCleaned$Interest.Rate ~ loanDataCleaned$FICO.Range,las=2,col="blue")
# median of interest rate decreases as FICO scre increases

boxplot(loanDataCleaned$Interest.Rate ~ loanDataCleaned$Loan.Length,las=2,col="blue")
# median of interest rate increases as duration of loan increases from 36 to 60 months


boxplot(loanDataCleaned$Interest.Rate ~ loanDataCleaned$Loan.Purpose,las=2,col="blue")
#looks ok, with some outliers for debt_consolidation and credit card
#NOTE: number of requests for debt_consolidation is high

boxplot(loanDataCleaned$Interest.Rate ~ loanDataCleaned$State,las=2,col="blue")
#no remarkable variation

boxplot(loanDataCleaned$Interest.Rate ~ loanDataCleaned$Home.Ownership,las=2,col="blue")
#no remarkable variation

boxplot(loanDataCleaned$Interest.Rate ~ loanDataCleaned$Employment.Length,las=2,col="blue")
#no remarkable variation

#dotplots with color attributes 
plot(loanDataCleaned$Interest.Rate,y = loanDataCleaned$FICO.Range,pch=20)
smoothScatter(loanDataCleaned$Interest.Rate,y = loanDataCleaned$FICO.Range,pch=20)

plot(x=loanDataCleaned$Interest.Rate,y = loanDataCleaned$FICO.Range,pch=20,col=cut(loanDataCleaned$Amount.Requested,breaks=4))
table(cut(loanDataCleaned$Amount.Requested,breaks=4))
#for same FICO score, the interest rate higher for higher loan requested

plot(x=loanDataCleaned$Interest.Rate,y = loanDataCleaned$FICO.Range,pch=20,col=loanDataCleaned$Loan.Length)
#for same FICO score, the inteste rate is higher for higher duration of loan period

plot(x=loanDataCleaned$Interest.Rate,y = loanDataCleaned$FICO.Range,pch=20,col=loanDataCleaned$Loan.Purpose)
#no significant variation observed

plot(x=loanDataCleaned$Interest.Rate,y = loanDataCleaned$FICO.Range,pch=20,col=loanDataCleaned$State)
#no significant variation observed

plot(x=loanDataCleaned$Interest.Rate,y = loanDataCleaned$FICO.Range,pch=20,col=loanDataCleaned$Home.Ownership)
smoothScatter(x=loanDataCleaned$Interest.Rate,y = loanDataCleaned$FICO.Range,pch=20,col=loanDataCleaned$Home.Ownership)
#no significant variation observed

plot(x=loanDataCleaned$Interest.Rate,y = loanDataCleaned$FICO.Range,pch=20,col=loanDataCleaned$Inquiries.in.the.Last.6.Months)
#no significant variation observed

loanDataCleaned$Amount.Gap <- loanDataCleaned$Amount.Requested - loanDataCleaned$Amount.Funded.By.Investors
hist(log(loanDataCleaned$Amount.Gap),breaks=100)
qplot(x=loanDataCleaned$Interest.Rate,y = loanDataCleaned$FICO.Range,col=cut(loanDataCleaned$Amount.Gap,breaks=4))
#no significant variation observed

qplot(x=loanDataCleaned$Interest.Rate,y = loanDataCleaned$FICO.Range,color=cut(loanDataCleaned$Debt.To.Income.Ratio,breaks=4))


qplot(data = loanDataCleaned, x=Interest.Rate,y = FICO.Range,size = Debt.To.Income.Ratio)
#no significant variation observed

qplot(data = loanDataCleaned, x=Interest.Rate,y = FICO.Range,size = Monthly.Income)
qplot(data = loanDataCleaned, x=Interest.Rate,y = FICO.Range,size = log(Monthly.Income))
#no significant variation observed

qplot(data = loanDataCleaned, x=Interest.Rate,y = FICO.Range,size = Open.CREDIT.Lines)
qplot(data = loanDataCleaned, x=Interest.Rate,y = FICO.Range,size = Open.CREDIT.Lines,color=Loan.Purpose)
#no significant variation observed

qplot(data = loanDataCleaned, x=Interest.Rate,y = FICO.Range,size = Revolving.CREDIT.Balance)
qplot(data = loanDataCleaned, x=Interest.Rate,y = FICO.Range,size = log(Revolving.CREDIT.Balance))
#no significant variation observed

qplot(data = loanDataCleaned, x=Interest.Rate,y = FICO.Range,color = Employment.Length)

#combiing the effected variables
qplot(data = loanDataCleaned, x=Interest.Rate,y = FICO.Range,color = Loan.Length,size = Amount.Requested)

qplot(data = loanDataCleaned, x=Interest.Rate,y = FICO.Range,color = Loan.Length,size = Amount.Requested,main="FICO VS Interest Rate with Loan Length and Amount Requested",xlab="Interest Rate",ylab="FICO")

### Modeling
#Fitting a basic curve
lm1 <- lm(Interest.Rate ~ .,data=loanDataCleaned)
summary(lm1)
#validating for the variables marked with significant by lm function
qplot(data = loanDataCleaned, x=Interest.Rate,y = Inquiries.in.the.Last.6.Months)
qplot(data = loanDataCleaned, x=Interest.Rate,y = Open.CREDIT.Lines)
cor(loanDataCleaned$Interest.Rate,loanDataCleaned$Open.CREDIT.Lines)
qplot(data = loanDataCleaned, x=Interest.Rate,y = log(Monthly.Income))

lm2 <- lm(Interest.Rate ~ FICO.Range + Loan.Length + Amount.Requested,data=loanDataCleaned)
plot(lm2)
summary(lm2)
qplot(data = loanDataCleaned, x=Interest.Rate,y = FICO.Range,color = Loan.Length,size = Amount.Funded.By.Investors)