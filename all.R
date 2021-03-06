###############################################################################################
# Statistics in simple regression line
#
#                                                                       Written by Nam, Hosung, 
#                                                                       revised by Kim, Wiback, 
#                                                                             v1.1. 2016.09.07.
#                                                                             v1.2. 2016.09.12. 
###############################################################################################





## Pre-Settings ###############################################################################
setwd('/Users/KimWiback/Google_Drive/Git/Statistics_All_R/')
library("lme4")
library("lmerTest")
library("lsmeans")
library("psych")
library("GPArotation")
library("tidyr")
library("dplyr")





## No Repeated data 1 #########################################################################
data = read.csv('2way1.csv')
hist(data$Score)
boxplot(data$Score)



########################
# Descriptive statistics
########################
describeBy(data, list(data$Gender, data$Grade))
describeBy(data, data$Gender)



############################
# One Way ANOVA (IV: Gender)
############################

### With Linear Model (Gender)
result = lm(Score ~ Gender, data)
anova(result)
boxplot(Score ~ Gender, data)
# Detail group differences (many t-tests) -> No need with 2 levels.
# lsmeans(result, pairwise ~ Gender, adjust = "tukey")

### With Original t-test (Gender)
t.test(Score ~ Gender, data)

### With Original ANOVA (Gender)
summary(aov(Score ~ Gender, data))



###########################
# One Way ANOVA (IV: Grade)
###########################

### With Linear Model (Grade)
result = lm(Score ~ Grade, data)
anova(result)
boxplot(Score ~ Grade, data)
# Detail group differences (many t-tests)
lsmeans(result, pairwise ~ Grade, adjust = "tukey")

### With Original t-test (Grade) -> Do not work with more than 3 levels.
# t.test(Score ~ Grade, data)

### With Original ANOVA (Grade)
summary(aov(Score ~ Grade, data))



######################################
# Two Way ANOVA (IV: Gender and Grade)
######################################

### With Linear Model (Gender and Grade)
result = lm(Score ~ Gender*Grade, data)
anova(result)
boxplot(Score ~ Gender*Grade, data)
# Detail group differences (many t-tests)
lsmeans(result, pairwise ~ Gender|Grade, adjust = "tukey")
lsmeans(result, pairwise ~ Grade|Gender, adjust = "tukey")

### With Original t-test (Gender and Grade) -> Do not work with more than 2 factors.
# t.test(Score ~ Gender*Grade, data)

### With Original ANOVA (Gender and Grade)
summary(aov(Score ~ Gender*Grade, data))





## No Repeated data 2 #########################################################################
data = read.csv('2way2.csv')
hist(data$Score)
boxplot(data$Score)



########################
# Descriptive statistics
########################
describeBy(data, list(data$L1, data$Condition))



########################
# One Way ANOVA (IV: L1)
########################

### With Linear Model (L1)
result = lm(Score ~ L1, data)
anova(result)
boxplot(Score ~ L1, data)
# Detail group differences (many t-tests)
lsmeans(result, pairwise ~ L1, adjust = "tukey")

### With Original t-test (L1) -> Do not work with more than 3 levels.
# t.test(Score ~ L1, data)

### With Original ANOVA (L1)
summary(aov(Score ~ L1, data))



###############################
# One Way ANOVA (IV: Condition)
###############################

### With Linear Model (Condition)
result = lm(Score ~ Condition, data)
anova(result)
boxplot(Score ~ Condition, data)
# Detail group differences (many t-tests)
lsmeans(result, pairwise ~ Condition, adjust = "tukey")

### With Original t-test (Condition) -> Do not work with more than 3 levels.
# t.test(Score ~ Condition, data)

### With Original ANOVA (Condition)
summary(aov(Score ~ Condition, data))



######################################
# Two Way ANOVA (IV: L1 and Condition)
######################################

### With Linear Model (L1 and Condition)
result = lm(Score ~ L1*Condition, data)
anova(result)
boxplot(Score ~ L1*Condition, data)
# Detail group differences (many t-tests)
lsmeans(result, pairwise ~ L1|Condition, adjust = "tukey")
lsmeans(result, pairwise ~ Condition|L1, adjust = "tukey")

### With Original t-test (L1 and Condition) -> Do not work with more than 2 factors.
# t.test(Score ~ L1*Condition, data)

### With Original ANOVA (L1 and Condition)
summary(aov(Score ~ L1*Condition, data))





## Repeated data 1 ############################################################################
# Only lmer() & aov() account for random effects, the others are talking about fixed effects.
data = read.csv('rm.csv')
hist(data$Score)
boxplot(data$Score)



########################
# Descriptive statistics
########################
describeBy(data, list(data$Group, data$Testtime))



#############################################
# One Way Repeated Measures ANOVA (IV: Group)
#############################################

### With Linear Model (Group)
# How to make sure random effect is necessary? 
# Lowest ICC(aov(Score ~ Group, data))
result = lmer(Score ~ Group + (1|Subject), data) 
anova(result)
boxplot(Score ~ Group, data)
# Detail group differences (many t-tests) -> No need with 2 levels.
# lsmeans(result, pairwise ~ Group, adjust = "tukey")

### With Original t-test (Group)
t.test(Score ~ Group, paired = FALSE, data) # For computer, this is not a paired data.

### With Original ANOVA (Group)
# Using residuals to disperse random intercepts following N(0, sigma^2) ???
summary(aov(Score ~ Group + Error(Subject/Testtime), data))



################################################
# One Way Repeated Measures ANOVA (IV: Testtime)
################################################

### With Linear Model (Testtime)
# How to make sure random effect is necessary? 
# Lowest ICC(aov(Score ~ Testtime, data))
result = lmer(Score ~ Testtime + (1|Subject), data)
anova(result)
boxplot(Score ~ Testtime, data)
# Detail group differences (many t-tests) -> No need with 2 levels.
# lsmeans(result, pairwise ~ Testtime, adjust = "tukey")

### With Original t-test (Testtime)
t.test(Score ~ Testtime, paired = TRUE, data) # Remind that this is a paired data.

### With Original ANOVA (Testtime)
# Using residuals to disperse random intercepts following N(0, sigma^2) ???
summary(aov(Score ~ Testtime + Error(Subject/Testtime), data))



##########################################################
# Two Way Repeated Measures ANOVA (IV: Group and Testtime)
##########################################################

### With Linear Model (Group and Testtime)
result = lmer(Score ~ Group*Testtime + (1|Subject), data)
anova(result)
boxplot(Score ~ Group*Testtime, data)
# Detail group differences (many t-tests)
lsmeans(result, pairwise ~ Group|Testtime, adjust = "tukey") 
lsmeans(result, pairwise ~ Testtime|Group, adjust = "tukey") 

### With Original t-test (Group and Testtime) -> Do not work with more than 2 factors.
# t.test(Score ~ Group*Testtime, data)

### With Original ANOVA (Group and Testtime)
# Using residuals to disperse random intercepts following N(0, sigma^2) ???
summary(aov(Score ~ Group*Testtime + Error(Subject/Testtime), data))





## Data Management ############################################################################
data = read.csv('rm.csv')



#############
# Factorizing
#############

### all subjects must be factors.
data$Subject = factor(data$Subject)



############
# Formatting
############

### long to wide (data, key-value pair to be spread)
data_wide = spread(data, Testtime, Score)

### wide to long (data, key-value pair to be filled, ...)
# data, the data object
# key, name of new key column that contains colum names (A, B) of the data
# value, name of new value column that contains values (a, b) of the same colums
# ..., the colum names (A, B) holding the values (a, b)
data_long = gather(data_wide, Testtime, Score, pre, post)

### subsetting
subset(data_long, Score>80 & Testtime=="pre", c(Subject, Testtime, Score))

### column reordering
data_wide = data_wide[ , c(1,3,4,2)]