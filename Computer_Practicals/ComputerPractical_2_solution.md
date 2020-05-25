---
title: 'Computer practical 2: Topics in Statistics III/IV, Term 1'
author: "Georgios Karagiannis"
output:
  html_notebook: default
  pdf_document: default
  word_document: default
  html_document: default
---

> Aim
> 
> * To perform Fisher exact test  
> * To Mantel-Haenszel test  
>
> * To analyse contigency tables with Log-linear models
>    + Fit the model
>    + Perform inference
>    + Specify the Identifiability constraint (Contrasts)
>    + Perform model comparison (Nested, or Non-nested models)

---------

***Load the libraries***


```r
library(MASS) # for contigency tables and log-linear models
library(vcd) # to visualise categorical data
```

```
## Loading required package: grid
```


---------

# Fisher's Exact test

***Description***

To perform FIsher's exact test we can use the command `fisher.test {stats}`, as,

* `fisher.test(x)` 

where `x` is either a two-dimensional contingency table in matrix form, or a factor object. 

For the output of the command, please chck help `?fisher.test` 

***Dataset***

[Cancer dataset] The table below shows the results  of a retrospective  study comparing radiation therapy with surgery in treating cancer of the larynx. The response indicates  whether  the  cancer  was  controlled  for  at  least  two  years following treatment.


```r
# load the data
## I will do this for you

Cancer.frame<-data.frame(count=c(21,2,15,3),
                      expand.grid( 
                      Cancer=factor(c("Controled","Not-controled"),
                                    levels=c("Controled","Not-controled")),
                      Therapy=factor(c("Surgery","Radiation"),
                                     levels=c("Surgery","Radiation"))
                      )
  ) 

## print the obs.frame
Cancer.frame
```

```
##   count        Cancer   Therapy
## 1    21     Controled   Surgery
## 2     2 Not-controled   Surgery
## 3    15     Controled Radiation
## 4     3 Not-controled Radiation
```

***Question***

Create a matrix `Cancer.xtabs` from `Cancer.frame` by using `xtabs()`.  Print the result on the screen.

***Answer***


```r
Cancer.xtabs <- xtabs(Cancer.frame)
Cancer.xtabs
```

```
##                Therapy
## Cancer          Surgery Radiation
##   Controled          21        15
##   Not-controled       2         3
```

***Question***

Perform Fisher's Exact test   

* Recall the type of the command's argument, and tranform it suitably by using `xtabs()`

***Answer***


```r
fisher.test(Cancer.xtabs)
```

```
## 
## 	Fisher's Exact Test for Count Data
## 
## data:  Cancer.xtabs
## p-value = 0.6384
## alternative hypothesis: true odds ratio is not equal to 1
## 95 percent confidence interval:
##   0.2089115 27.5538747
## sample estimates:
## odds ratio 
##   2.061731
```

***Question***

Report and interpret the P-value for Fisher’s exact test whose alternative hypothesis is that the odds ratio is larger than $1$.  

$$
H_0: \theta=1 \\
H_0: \theta>1
$$ 

***Answer***

We cannot reject the hypothesis that the control of cancer is independent of treat, against the alternative that control of canceris more likely to happen if Surgery is used as a treatement, at sig. level $5\%$.



***Question***

Explain  how the P-values are calculated for this particular test. (you can check your notes: Handout: Contigency tables)

***Answer***

Well, based on the theory in the Handouts: The P-value is hypergeometric probability $P(n_{11}=21 \  or \   22 \   or \   23) = 0.3808$



---------

# Chi-squared Test


***Description***

To perform Chi-squared Test on a contigency tables, we can use the command `chisq.test()` from the package `stats`, as,

* `chisq.test(x,...)` 

where `x` a numeric vector or matrix holding the data

For the output of the command, see in the help page `?chisq.test` 


***Dataset***

Use the [Cancer dataset]


***Question***

* Perform the Chi-squared Test in order to test if Cancer control and Therapy are independent. 

* What is the conclusion?

***Answer***


```r
Cancer.test <- chisq.test(Cancer.xtabs)
```

```
## Warning in chisq.test(Cancer.xtabs): Chi-squared approximation may be
## incorrect
```

```r
Cancer.test
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  Cancer.xtabs
## X-squared = 0.085967, df = 1, p-value = 0.7694
```

I cannot reject the null hypothesis that Cancer control and Therapy are independent at sig. level $5\%$.




---------

# Mantel–Haenszel test

***Description***

We wish to perform Mantel-Haenszel chi-squared test of the null that two nominal variables are conditionally independent in each stratum, assuming that there is no three-way interaction.  

We can use the command  `mantelhaen.test(x,...)`, as,  

*  mantelhaen.test(x,alternative="two.sided")

where `x` is a 3-dimensional contingency table in array form where each dimension is at least 2 and the last dimension corresponds to the strata.

For more options check help `?mantelhaen.test`


***Dataset***

[Marijuana data-set] Consider the following table where refers to a 1992 survey by the Wright State University School of Medicine and the United Health Services in Dayton, Ohio. The survey asked 2276 students in their final year of high school in a nonurban area near Dayton, Ohio whether they had ever used alcohol, cigarettes, or marijuana. Denote the variables in this $2 \times 2 \times 2$ table by A for alcohol use, C for cigarette use, and M for marijuana use.



```r
# I will do this for you

## load the data

marijuana.frame<-data.frame(count=c(911,538,44,456,3,43,2,279),
                      expand.grid( 
  marijuana=factor(c("Yes","No"),levels=c("No","Yes")),
  cigarette=factor(c("Yes","No"),levels=c("No","Yes")),  
  alcohol=factor(c("Yes","No"),levels=c("No","Yes")))
  ) 

## print the obs.frame

marijuana.frame
```

```
##   count marijuana cigarette alcohol
## 1   911       Yes       Yes     Yes
## 2   538        No       Yes     Yes
## 3    44       Yes        No     Yes
## 4   456        No        No     Yes
## 5     3       Yes       Yes      No
## 6    43        No       Yes      No
## 7     2       Yes        No      No
## 8   279        No        No      No
```


***Question***

Test the hypothesis that the use of Marijuana and the use of cigarete are independent accross the levels of the use of alcohol, by using Mantel–Haenszel test.  

Report the result of your inference.

If you wish, you can play with the alternative hypothesis (see the help page)


***Answer***


```r
marijuana.xtabs<-xtabs(marijuana.frame)
marijuana.xtabs
```

```
## , , alcohol = No
## 
##          cigarette
## marijuana  No Yes
##       No  279  43
##       Yes   2   3
## 
## , , alcohol = Yes
## 
##          cigarette
## marijuana  No Yes
##       No  456 538
##       Yes  44 911
```


```r
marijuana.mantelhaen.obj<- mantelhaen.test(marijuana.xtabs)
marijuana.mantelhaen.obj
```

```
## 
## 	Mantel-Haenszel chi-squared test with continuity correction
## 
## data:  marijuana.xtabs
## Mantel-Haenszel X-squared = 439.66, df = 1, p-value < 2.2e-16
## alternative hypothesis: true common odds ratio is not equal to 1
## 95 percent confidence interval:
##  12.58828 24.00445
## sample estimates:
## common odds ratio 
##          17.38317
```


I reject the hypothesis that the use of Marijuana and the use of cigarete are independent accross the levels of the use of alcohol, as sig. level $5\%$. 



---------


# Log-linear models

## Data

Consider the [Marijuana data-set] used previously


```r
marijuana.frame
```

```
##   count marijuana cigarette alcohol
## 1   911       Yes       Yes     Yes
## 2   538        No       Yes     Yes
## 3    44       Yes        No     Yes
## 4   456        No        No     Yes
## 5     3       Yes       Yes      No
## 6    43        No       Yes      No
## 7     2       Yes        No      No
## 8   279        No        No      No
```



## Fit the Log-linear model

Fitting  a  loglinear  model  can  be  done  using  Iterative  Proportional  Fitting  (`loglm` of the package `MASS`)  or  Newton  Raphson (`glm` with poisson family, of the package `stats`).   The former uses  `loglm` from `MASS`.   `loglm`     accepts as  input    table output, crosstabs output (`xtabs` in R), or a formula using variables from a data frame.

### Specify  a model
 
Below is an example for fiting the Log-linear model [ACM]. Notice that [ACM] it can be writen in different ways. I set the arguments  `fit` and `param` to `T`  so that I can get fitted values and parameter estimates, as we see later. 


```r
fitAC.AM.CM_ <- loglm(count~1+alcohol+cigarette+marijuana
                      +alcohol:cigarette
                      +cigarette:marijuana
                      +alcohol:marijuana
                      ,data=marijuana.frame,
                      param=T,fit=T) # ACM 

fitAC.AM.CM <- loglm(count ~ alcohol*cigarette
                +alcohol*marijuana
                +cigarette*marijuana,
                data=marijuana.frame,
                param=T,fit=T) # ACM 

fitAC.AM.CM_
```

```
## Call:
## loglm(formula = count ~ 1 + alcohol + cigarette + marijuana + 
##     alcohol:cigarette + cigarette:marijuana + alcohol:marijuana, 
##     data = marijuana.frame, param = T, fit = T)
## 
## Statistics:
##                        X^2 df  P(> X^2)
## Likelihood Ratio 0.3739859  1 0.5408396
## Pearson          0.4011039  1 0.5265197
```

```r
fitAC.AM.CM
```

```
## Call:
## loglm(formula = count ~ alcohol * cigarette + alcohol * marijuana + 
##     cigarette * marijuana, data = marijuana.frame, param = T, 
##     fit = T)
## 
## Statistics:
##                        X^2 df  P(> X^2)
## Likelihood Ratio 0.3739859  1 0.5408396
## Pearson          0.4010998  1 0.5265218
```

***Question***

Notice the details in the two equivalent executions.  

Regarding the `formula` above, what is the relation between terms (1, alcohol, cigarette, alcohol:cigarette) and (alcohol*cigarette) ?

***Answer***

Obviously: 

* `alcohol*cigarette` is equivalent to `alcohol+cigarette+alcohol:cigarette`
* `alcohol` is the main effect of alcohol, and `alcohol:cigarette` is the interaction between `alcohol` and `cigarette` .


### Extend  a model

Based on a given model, we can build, new ones. E.g., the [ACM] and the [AC,M],


```r
fitACM<-update(fitAC.AM.CM,
                .~. + alcohol:cigarette:marijuana) # ACM 

fitAC.M<-update(fitAC.AM.CM, 
                .~. - alcohol:marijuana - cigarette:marijuana) # AC, M
```


***Question***

Fit models [AM, CM], and [ A, C, M ] and print the output.


***Answer***


```r
fitAM.CM<-update(fitAC.AM.CM, .~. - alcohol:cigarette)     #    AM,    CM 
fitA.C.M<-update(fitAC.M, .~. - alcohol:cigarette) # A, C, M
```



***Question***

Get  the estimates  of  the  model  parameters  (the  lambdas) by applying `...$param` to the output object of the `loglm` or `update`.  

Get the fitted values by applying `...$fitted` the command `fitted()` to the output object of the `loglm` or `update`.

***Answer***


```r
fitAC.AM.CM$fitted
```

```
## , , marijuana = No
## 
##        cigarette
## alcohol       No       Yes
##     No  279.6144  42.38388
##     Yes 455.3856 538.61612
## 
## , , marijuana = Yes
## 
##        cigarette
## alcohol       No        Yes
##     No   1.38316   3.616919
##     Yes 44.61684 910.383081
```

```r
fitAC.AM.CM.array<-fitted(fitAC.AM.CM)
fitAC.AM.CM.array
```

```
## , , marijuana = No
## 
##        cigarette
## alcohol       No       Yes
##     No  279.6144  42.38388
##     Yes 455.3856 538.61612
## 
## , , marijuana = Yes
## 
##        cigarette
## alcohol       No        Yes
##     No   1.38316   3.616919
##     Yes 44.61684 910.383081
```



## Inference

## Inference

Likelihood ratio chi-squared test statistics are output using the `summary()` function for `loglm`. The functin provides:

* The formula of the model as `Formula:`
* The design matrix X in the vectorized form of the log-linear model $\log(\mu)=X\beta$ as `attr(,"factors")`
* The Pearson and Likelihood ratio Goodness-of-fit test



***Question***

Apply `summary()` function on the output object of the function `loglm` for the homogeneous association model  object. 

Does the data-set support the homogeneous association model at sig. level $5\%$ ?


***Answer***


```r
summary(fitAC.AM.CM) # homogeneous association model
```

```
## Formula:
## count ~ alcohol * cigarette + alcohol * marijuana + cigarette * 
##     marijuana
## attr(,"variables")
## list(count, alcohol, cigarette, marijuana)
## attr(,"factors")
##           alcohol cigarette marijuana alcohol:cigarette alcohol:marijuana
## count           0         0         0                 0                 0
## alcohol         1         0         0                 1                 1
## cigarette       0         1         0                 1                 0
## marijuana       0         0         1                 0                 1
##           cigarette:marijuana
## count                       0
## alcohol                     0
## cigarette                   1
## marijuana                   1
## attr(,"term.labels")
## [1] "alcohol"             "cigarette"           "marijuana"          
## [4] "alcohol:cigarette"   "alcohol:marijuana"   "cigarette:marijuana"
## attr(,"order")
## [1] 1 1 1 2 2 2
## attr(,"intercept")
## [1] 1
## attr(,"response")
## [1] 1
## attr(,".Environment")
## <environment: R_GlobalEnv>
## attr(,"predvars")
## list(count, alcohol, cigarette, marijuana)
## attr(,"dataClasses")
##     count   alcohol cigarette marijuana 
## "numeric"  "factor"  "factor"  "factor" 
## 
## Statistics:
##                        X^2 df  P(> X^2)
## Likelihood Ratio 0.3739859  1 0.5408396
## Pearson          0.4010998  1 0.5265218
```

Yes, we cannot reject the null hypothesis that the homogeneous association model is the best model against the Saturated model at sig. level $5\%$, as the p-value of the Likelihood test is $0.5408396$, and the p-values of the Pearson's chis square test is 0.5265218.


# Stepwise model selection

Two popular procedures can be used in order to perform Variable selection in linear models. By saying variable here, we mean the factors of the log-linear model, or (equivalently) the classifier variables of the associated contigency table. They are the follwoing:

* Forward selection.  
  + Forward  selection  adds  terms  sequentially  until  further  additions  do  not
improve the fit. E.g., [A,C,M]->[AC,M]->[AC,AM]->... At each stage it selects the term giving the greatest improvement  in  fit. The selection criterion can be the minimum P-value  for  testing  the  term  in  the  model. Then the procedure may stop when  adding more terms may result in insignifical p-values.

* Backward elimination. Backward   elimination   begins   with   a   complex   model   and   sequentially
removes  terms until we reach a simple model such as reducing it further can will not fit the data well.  At  each  stage,  it  selects  the  term  for  which  its  removal  has the  least  damaging  effect  on  the  model   e.g.,  largest P-value.  It stops at the model such that removal of any of its term lead to rejection of the Goodness-of-Fit test.

There is not a commonly accepted answer to the question which procedure is better.  Both are okay and in use... What is your personal opinion? Discuss it with your fellow students; alternatively ask the instructor. 




## Model comparison among a set of nested models

***Comment***

Comparison of nested models can be done using the anova  method. It gives  the  likelihood  ratio  tests  comparing  hierarchical   loglinear  models  given  in  the  list  of  arguments. For example,  


```r
anova(fitAC.M, fitAC.AM.CM)
```

```
## LR tests for hierarchical log-linear models
## 
## Model 1:
##  count ~ alcohol + cigarette + marijuana + alcohol:cigarette 
## Model 2:
##  count ~ alcohol * cigarette + alcohol * marijuana + cigarette * marijuana 
## 
##              Deviance df  Delta(Dev) Delta(df) P(> Delta(Dev)
## Model 1   843.8266437  3                                     
## Model 2     0.3739859  1 843.4526577         2        0.00000
## Saturated   0.0000000  0   0.3739859         1        0.54084
```

The column `Deviance` is the Devience...(i.e., the Likelihood ratio statistic of the model vs the saturated)

Regarding the likelihood ratio test of  

* [AC, M] vs. [AC,AM,CM] , the statistic is equal to $843.4526577$, the degrees of freedom are equal to $2$ and the p-value equal to $0.00000$

*  [AC,AM,CM] vs. [ACM], the statistic is equal to $0.3739859$, the degrees of freedom are equal to $1$ and the p-value equal to $0.54084$


***Question***

Compare models [ACM], [AC,AM,CM], [AM, CM], [AC, M], [A,C,M]. What is your conclusion?


***Answer***


```r
anova(fitAC.M, fitAC.AM.CM, fitAM.CM, fitA.C.M,fitACM)
```

```
## LR tests for hierarchical log-linear models
## 
## Model 1:
##  count ~ alcohol + cigarette + marijuana 
## Model 2:
##  count ~ alcohol + cigarette + marijuana + alcohol:cigarette 
## Model 3:
##  count ~ alcohol + cigarette + marijuana + alcohol:marijuana + cigarette:marijuana 
## Model 4:
##  count ~ alcohol * cigarette + alcohol * marijuana + cigarette * marijuana 
## Model 5:
##  count ~ alcohol + cigarette + marijuana + alcohol:cigarette + alcohol:marijuana + cigarette:marijuana + alcohol:cigarette:marijuana 
## 
##               Deviance df  Delta(Dev) Delta(df) P(> Delta(Dev)
## Model 1   1286.0199544  4                                     
## Model 2    843.8266437  3 442.1933108         1        0.00000
## Model 3    187.7543029  2 656.0723408         1        0.00000
## Model 4      0.3739859  1 187.3803170         1        0.00000
## Model 5      0.0000000  0   0.3739859         1        0.54084
## Saturated    0.0000000  0   0.0000000         0        1.00000
```

It seems that the model [AM, CM] is the 'Best' model according to this procedure. This is because 


## Model comparison among a set of non-nested models

Select a subset of predictor (classifier) variables from a larger set (e.g., stepwise selection) is a controversial topic. 

You can perform stepwise selection (forward, backward) using the `stepAIC( )` function from the `MASS` package. `stepAIC( )` performs stepwise model selection by exact AIC.

***Comment ***

Model selection based on either Forward selection, or Backword elimination procedures can be perforemed by using AIC as a criterion. 

The command to perofrm this procedure automatically is `stepAIC()`.

* Forward selection, starting from fitA.C.M: `stepAIC(fitA.C.M, direction = "forward")$anova`  

* Backward elimination, starting from fitACM: `stepAIC(fitACM, direction ="backward")$anova`

The `...$anova` is because we are interested in the `...$anova` return value only.

***Question ***

Apply Forward selection, and Backward elimination by using AIC.  

* What is your conclusion about the preferable model by using each method? 

* Do the two procedures produce the same result?

***Answer ***


```r
stepAIC(fitA.C.M,direction = "forward")$anova
```

```
## Start:  AIC=1294.02
## count ~ alcohol + cigarette + marijuana
```

```
## Stepwise Model Path 
## Analysis of Deviance Table
## 
## Initial Model:
## count ~ alcohol + cigarette + marijuana
## 
## Final Model:
## count ~ alcohol + cigarette + marijuana
## 
## 
##   Step Df Deviance Resid. Df Resid. Dev     AIC
## 1                          4    1286.02 1294.02
```



```r
stepAIC(fitACM,direction = "backward")$anova
```

```
## Start:  AIC=16
## count ~ alcohol + cigarette + marijuana + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:cigarette:marijuana
## 
##                               Df    AIC
## - alcohol:cigarette:marijuana  1 14.374
## <none>                           16.000
## 
## Step:  AIC=14.37
## count ~ alcohol + cigarette + marijuana + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana
## 
##                       Df    AIC
## <none>                    14.37
## - alcohol:marijuana    1 104.02
## - alcohol:cigarette    1 199.75
## - cigarette:marijuana  1 509.37
```

```
## Stepwise Model Path 
## Analysis of Deviance Table
## 
## Initial Model:
## count ~ alcohol + cigarette + marijuana + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:cigarette:marijuana
## 
## Final Model:
## count ~ alcohol + cigarette + marijuana + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana
## 
## 
##                            Step Df  Deviance Resid. Df Resid. Dev      AIC
## 1                                                    0  0.0000000 16.00000
## 2 - alcohol:cigarette:marijuana  1 0.3739859         1  0.3739859 14.37399
```


The two methods give different results. It seems that the Backward elimination selects [AC,AM,CM], while the Forward elimination selects [A,C,M]. 




# Practice at home

## Data
 
Use the Marijuana data, and consider additional classifier variables Gender (G), and race (R). 

The dataset is given below.


```r
marijuana_new.frame<-data.frame(count=c(405,13,1,1,268,218,17,117,453,28,1,1,228,201,17,
                                        133,23,2,0, 0,23, 19,1,12,30,1,1,0,19,18,8,17),
                                expand.grid(cigarette=c("Yes","No"), 
                                            alcohol=c("Yes","No"),marijuana=c("Yes","No"),
                                            sex=c("female","male"),  
                                      race=c("white","other"))
                                ) 
marijuana_new.frame
```

```
##    count cigarette alcohol marijuana    sex  race
## 1    405       Yes     Yes       Yes female white
## 2     13        No     Yes       Yes female white
## 3      1       Yes      No       Yes female white
## 4      1        No      No       Yes female white
## 5    268       Yes     Yes        No female white
## 6    218        No     Yes        No female white
## 7     17       Yes      No        No female white
## 8    117        No      No        No female white
## 9    453       Yes     Yes       Yes   male white
## 10    28        No     Yes       Yes   male white
## 11     1       Yes      No       Yes   male white
## 12     1        No      No       Yes   male white
## 13   228       Yes     Yes        No   male white
## 14   201        No     Yes        No   male white
## 15    17       Yes      No        No   male white
## 16   133        No      No        No   male white
## 17    23       Yes     Yes       Yes female other
## 18     2        No     Yes       Yes female other
## 19     0       Yes      No       Yes female other
## 20     0        No      No       Yes female other
## 21    23       Yes     Yes        No female other
## 22    19        No     Yes        No female other
## 23     1       Yes      No        No female other
## 24    12        No      No        No female other
## 25    30       Yes     Yes       Yes   male other
## 26     1        No     Yes       Yes   male other
## 27     1       Yes      No       Yes   male other
## 28     0        No      No       Yes   male other
## 29    19       Yes     Yes        No   male other
## 30    18        No     Yes        No   male other
## 31     8       Yes      No        No   male other
## 32    17        No      No        No   male other
```

***Question***

* Perform a model selection (by using the procedure of your preference) in order to find the best model that prepresents the dependences of the variables.  

* For the selected model, compute the fitted values, and the estimations of the parameters.

* Discuss the conclusions of your inference. 


*** Answer ***



```r
fitACMSR <- loglm(count ~ alcohol*cigarette*marijuana*sex*race,
                data=marijuana_new.frame,
                param=T,fit=T) # ACM 
fitACMSR
```

```
## Call:
## loglm(formula = count ~ alcohol * cigarette * marijuana * sex * 
##     race, data = marijuana_new.frame, param = T, fit = T)
## 
## Statistics:
##                  X^2 df P(> X^2)
## Likelihood Ratio   0  0        1
## Pearson          NaN  0        1
```


```r
stepAIC(fitACMSR,direction = "backward")$anova
```

```
## Start:  AIC=64
## count ~ alcohol * cigarette * marijuana * sex * race
## 
##                                        Df AIC
## - alcohol:cigarette:marijuana:sex:race  1  62
## <none>                                     64
## 
## Step:  AIC=62
## count ~ alcohol + cigarette + marijuana + sex + race + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:sex + cigarette:sex + 
##     marijuana:sex + alcohol:race + cigarette:race + marijuana:race + 
##     sex:race + alcohol:cigarette:marijuana + alcohol:cigarette:sex + 
##     alcohol:marijuana:sex + cigarette:marijuana:sex + alcohol:cigarette:race + 
##     alcohol:marijuana:race + cigarette:marijuana:race + alcohol:sex:race + 
##     cigarette:sex:race + marijuana:sex:race + alcohol:cigarette:marijuana:sex + 
##     alcohol:cigarette:marijuana:race + alcohol:cigarette:sex:race + 
##     alcohol:marijuana:sex:race + cigarette:marijuana:sex:race
## 
##                                    Df    AIC
## - alcohol:cigarette:marijuana:sex   1 60.115
## - alcohol:marijuana:sex:race        1 60.174
## - alcohol:cigarette:marijuana:race  1 60.218
## - cigarette:marijuana:sex:race      1 61.549
## <none>                                62.000
## - alcohol:cigarette:sex:race        1 62.742
## 
## Step:  AIC=60.12
## count ~ alcohol + cigarette + marijuana + sex + race + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:sex + cigarette:sex + 
##     marijuana:sex + alcohol:race + cigarette:race + marijuana:race + 
##     sex:race + alcohol:cigarette:marijuana + alcohol:cigarette:sex + 
##     alcohol:marijuana:sex + cigarette:marijuana:sex + alcohol:cigarette:race + 
##     alcohol:marijuana:race + cigarette:marijuana:race + alcohol:sex:race + 
##     cigarette:sex:race + marijuana:sex:race + alcohol:cigarette:marijuana:race + 
##     alcohol:cigarette:sex:race + alcohol:marijuana:sex:race + 
##     cigarette:marijuana:sex:race
## 
##                                    Df    AIC
## - alcohol:marijuana:sex:race        1 58.359
## - alcohol:cigarette:marijuana:race  1 58.419
## - cigarette:marijuana:sex:race      1 59.628
## <none>                                60.115
## - alcohol:cigarette:sex:race        1 60.794
## 
## Step:  AIC=58.36
## count ~ alcohol + cigarette + marijuana + sex + race + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:sex + cigarette:sex + 
##     marijuana:sex + alcohol:race + cigarette:race + marijuana:race + 
##     sex:race + alcohol:cigarette:marijuana + alcohol:cigarette:sex + 
##     alcohol:marijuana:sex + cigarette:marijuana:sex + alcohol:cigarette:race + 
##     alcohol:marijuana:race + cigarette:marijuana:race + alcohol:sex:race + 
##     cigarette:sex:race + marijuana:sex:race + alcohol:cigarette:marijuana:race + 
##     alcohol:cigarette:sex:race + cigarette:marijuana:sex:race
## 
##                                    Df    AIC
## - alcohol:marijuana:sex             1 56.613
## - alcohol:cigarette:marijuana:race  1 57.036
## - cigarette:marijuana:sex:race      1 57.896
## <none>                                58.359
## - alcohol:cigarette:sex:race        1 59.564
## 
## Step:  AIC=56.61
## count ~ alcohol + cigarette + marijuana + sex + race + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:sex + cigarette:sex + 
##     marijuana:sex + alcohol:race + cigarette:race + marijuana:race + 
##     sex:race + alcohol:cigarette:marijuana + alcohol:cigarette:sex + 
##     cigarette:marijuana:sex + alcohol:cigarette:race + alcohol:marijuana:race + 
##     cigarette:marijuana:race + alcohol:sex:race + cigarette:sex:race + 
##     marijuana:sex:race + alcohol:cigarette:marijuana:race + alcohol:cigarette:sex:race + 
##     cigarette:marijuana:sex:race
## 
##                                    Df    AIC
## - alcohol:cigarette:marijuana:race  1 55.156
## - cigarette:marijuana:sex:race      1 56.099
## <none>                                56.613
## - alcohol:cigarette:sex:race        1 57.738
## 
## Step:  AIC=55.16
## count ~ alcohol + cigarette + marijuana + sex + race + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:sex + cigarette:sex + 
##     marijuana:sex + alcohol:race + cigarette:race + marijuana:race + 
##     sex:race + alcohol:cigarette:marijuana + alcohol:cigarette:sex + 
##     cigarette:marijuana:sex + alcohol:cigarette:race + alcohol:marijuana:race + 
##     cigarette:marijuana:race + alcohol:sex:race + cigarette:sex:race + 
##     marijuana:sex:race + alcohol:cigarette:sex:race + cigarette:marijuana:sex:race
## 
##                                Df    AIC
## - alcohol:marijuana:race        1 53.255
## - alcohol:cigarette:marijuana   1 53.562
## - cigarette:marijuana:sex:race  1 54.742
## <none>                            55.156
## - alcohol:cigarette:sex:race    1 56.327
## 
## Step:  AIC=53.26
## count ~ alcohol + cigarette + marijuana + sex + race + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:sex + cigarette:sex + 
##     marijuana:sex + alcohol:race + cigarette:race + marijuana:race + 
##     sex:race + alcohol:cigarette:marijuana + alcohol:cigarette:sex + 
##     cigarette:marijuana:sex + alcohol:cigarette:race + cigarette:marijuana:race + 
##     alcohol:sex:race + cigarette:sex:race + marijuana:sex:race + 
##     alcohol:cigarette:sex:race + cigarette:marijuana:sex:race
## 
##                                Df    AIC
## - alcohol:cigarette:marijuana   1 51.608
## - cigarette:marijuana:sex:race  1 52.847
## <none>                            53.255
## - alcohol:cigarette:sex:race    1 54.488
## 
## Step:  AIC=51.61
## count ~ alcohol + cigarette + marijuana + sex + race + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:sex + cigarette:sex + 
##     marijuana:sex + alcohol:race + cigarette:race + marijuana:race + 
##     sex:race + alcohol:cigarette:sex + cigarette:marijuana:sex + 
##     alcohol:cigarette:race + cigarette:marijuana:race + alcohol:sex:race + 
##     cigarette:sex:race + marijuana:sex:race + alcohol:cigarette:sex:race + 
##     cigarette:marijuana:sex:race
## 
##                                Df     AIC
## - cigarette:marijuana:sex:race  1  51.178
## <none>                             51.608
## - alcohol:cigarette:sex:race    1  52.839
## - alcohol:marijuana             1 140.673
## 
## Step:  AIC=51.18
## count ~ alcohol + cigarette + marijuana + sex + race + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:sex + cigarette:sex + 
##     marijuana:sex + alcohol:race + cigarette:race + marijuana:race + 
##     sex:race + alcohol:cigarette:sex + cigarette:marijuana:sex + 
##     alcohol:cigarette:race + cigarette:marijuana:race + alcohol:sex:race + 
##     cigarette:sex:race + marijuana:sex:race + alcohol:cigarette:sex:race
## 
##                              Df     AIC
## - cigarette:marijuana:race    1  49.186
## - marijuana:sex:race          1  49.191
## - cigarette:marijuana:sex     1  50.673
## <none>                           51.178
## - alcohol:cigarette:sex:race  1  51.855
## - alcohol:marijuana           1 139.913
## 
## Step:  AIC=49.19
## count ~ alcohol + cigarette + marijuana + sex + race + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:sex + cigarette:sex + 
##     marijuana:sex + alcohol:race + cigarette:race + marijuana:race + 
##     sex:race + alcohol:cigarette:sex + cigarette:marijuana:sex + 
##     alcohol:cigarette:race + alcohol:sex:race + cigarette:sex:race + 
##     marijuana:sex:race + alcohol:cigarette:sex:race
## 
##                              Df     AIC
## - marijuana:sex:race          1  47.201
## - cigarette:marijuana:sex     1  48.681
## <none>                           49.186
## - alcohol:cigarette:sex:race  1  49.878
## - alcohol:marijuana           1 137.940
## 
## Step:  AIC=47.2
## count ~ alcohol + cigarette + marijuana + sex + race + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:sex + cigarette:sex + 
##     marijuana:sex + alcohol:race + cigarette:race + marijuana:race + 
##     sex:race + alcohol:cigarette:sex + cigarette:marijuana:sex + 
##     alcohol:cigarette:race + alcohol:sex:race + cigarette:sex:race + 
##     alcohol:cigarette:sex:race
## 
##                              Df     AIC
## - cigarette:marijuana:sex     1  46.694
## <none>                           47.201
## - marijuana:race              1  47.369
## - alcohol:cigarette:sex:race  1  47.902
## - alcohol:marijuana           1 136.265
## 
## Step:  AIC=46.69
## count ~ alcohol + cigarette + marijuana + sex + race + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:sex + cigarette:sex + 
##     marijuana:sex + alcohol:race + cigarette:race + marijuana:race + 
##     sex:race + alcohol:cigarette:sex + alcohol:cigarette:race + 
##     alcohol:sex:race + cigarette:sex:race + alcohol:cigarette:sex:race
## 
##                              Df    AIC
## <none>                           46.69
## - marijuana:race              1  46.89
## - alcohol:cigarette:sex:race  1  47.36
## - marijuana:sex               1  55.06
## - alcohol:marijuana           1 135.48
## - cigarette:marijuana         1 542.23
```

```
## Stepwise Model Path 
## Analysis of Deviance Table
## 
## Initial Model:
## count ~ alcohol * cigarette * marijuana * sex * race
## 
## Final Model:
## count ~ alcohol + cigarette + marijuana + sex + race + alcohol:cigarette + 
##     alcohol:marijuana + cigarette:marijuana + alcohol:sex + cigarette:sex + 
##     marijuana:sex + alcohol:race + cigarette:race + marijuana:race + 
##     sex:race + alcohol:cigarette:sex + alcohol:cigarette:race + 
##     alcohol:sex:race + cigarette:sex:race + alcohol:cigarette:sex:race
## 
## 
##                                      Step Df     Deviance Resid. Df
## 1                                                                 0
## 2  - alcohol:cigarette:marijuana:sex:race  1 9.017855e-07         1
## 3       - alcohol:cigarette:marijuana:sex  1 1.152848e-01         2
## 4            - alcohol:marijuana:sex:race  1 2.436820e-01         3
## 5                 - alcohol:marijuana:sex  1 2.542688e-01         4
## 6      - alcohol:cigarette:marijuana:race  1 5.430674e-01         5
## 7                - alcohol:marijuana:race  1 9.903510e-02         6
## 8           - alcohol:cigarette:marijuana  1 3.526634e-01         7
## 9          - cigarette:marijuana:sex:race  1 1.569647e+00         8
## 10             - cigarette:marijuana:race  1 8.104061e-03         9
## 11                   - marijuana:sex:race  1 1.520804e-02        10
## 12              - cigarette:marijuana:sex  1 1.492917e+00        11
##      Resid. Dev      AIC
## 1  0.000000e+00 64.00000
## 2  9.017855e-07 62.00000
## 3  1.152857e-01 60.11529
## 4  3.589677e-01 58.35897
## 5  6.132365e-01 56.61324
## 6  1.156304e+00 55.15630
## 7  1.255339e+00 53.25534
## 8  1.608002e+00 51.60800
## 9  3.177649e+00 51.17765
## 10 3.185753e+00 49.18575
## 11 3.200961e+00 47.20096
## 12 4.693878e+00 46.69388
```


Therefore the proposed model is the [A,C,M,S,R,AC,AM,CM,AS,CS,MS,AR,CR,MR,SR,ACS,ACR,ASR,CSR,ACSR].



# Save me  

Generate the document as a Notebook, PDF, Word, or HTML by choosing the relevant option (from the pop-up menu next to the Preview button). Then save your Markdown code by choosing the relevant option (from the task bar menu).

Save the *.Rmd script, so that you can edit it later.
