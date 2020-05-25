---
title: 'Computer practical 1: Topics in Statistics III/IV, Term 1'
author: "Georgios Karagiannis"
output:
  html_notebook: default
  pdf_document: default
  word_document: default
  html_document: default
---

> Aim
>
> * To be become familiar with R Notebook.
> 
> * To become familiar with Iterative Proportional Fitting (IPF) method
> * Apply IPF method to produce MLE for the Log Linear models
> 
> * To learn how to solve systems of noon-linear equations via Newton method 
> * Apply Newton method to produce MLE for the Log Linear models
>
> * Extensions of Newton method, and IPF method to to produce MLEs for 4-way and higher order tables


---------

# About R Markdown Notebook

***What it is***

[R Markdown Notebook](http://rmarkdown.rstudio.com/r_notebooks.html)  :

*  creates documents that contain explanatory text, mathematical equations, live code, and visualizations.  

*  produces fully interactive documents allowing the readers to change the parameters underlying the analysis, and see the results immediately.  

*  produces interactive statistical reports that include data analysis, code, and results.  

### An R Notebook demo:

In what follows, we provide a simple demo to help you familiarise yourselves with the R Markdown Notebook environment.

This is an [R Markdown Notebook](http://rmarkdown.rstudio.com/r_notebooks.html). When you execute code within the Notebook, the results appear beneath the code. 

Try executing this chunk by clicking the *Run* button within the chunk or by placing your cursor inside it and pressing *Ctrl+Shift+Enter*. 


```r
summary(cars)
##      speed           dist       
##  Min.   : 4.0   Min.   :  2.00  
##  1st Qu.:12.0   1st Qu.: 26.00  
##  Median :15.0   Median : 36.00  
##  Mean   :15.4   Mean   : 42.98  
##  3rd Qu.:19.0   3rd Qu.: 56.00  
##  Max.   :25.0   Max.   :120.00
plot(cars)
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)

***How it works (Skip it)***

Creating documents with R Markdown Notebook, requires the user to create a .Rmd (script) file that contains a combination of [Markdown](http://rmarkdown.rstudio.com) code (that produced the explanatory text) and [R](https://www.r-project.org/) code chunks (that produce plots, and data analysis outputs). Then the .Rmd file is processed automatically by the software in order to generate a document in a format such as: HTML (web page), PDF, MS Word document, slide show, handout, book, dashboard, package vignette, etc.

In this practical, we will not go into details about Markdown coding, although it is has a super simple syntax. We recommend the interested student to read the nice cheat-sheet available from [[here]](https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf). 

***How to tune presentation (Skip it)***

The user to specify how the chunk will be executed, or how its output will be presented, by setting the appropriate flags inside {r, ...}. If time permits, use the following flags in the previous chuck. What is their effect?

* eval: (TRUE; logical) whether to evaluate the code chunk; it can also be a numeric vector to select which R expression(s) to evaluate, e.g. eval=c(1, 3, 4) or eval=-(4:5)

* echo: (TRUE; logical or numeric) whether to include R source code in the output file. Besides TRUE/FALSE which completely turns on/off the source code, we can also use a numeric vector to select which R expression(s) to echo in a chunk, e.g. echo=2:3 means only echo the 2nd and 3rd expressions, and echo=-4 means to exclude the 4th expression.  
* results: ('markup'; character) takes these values  

    + hold: hold all the output pieces and push them to the end of a chunk  
    + hide: hide results; this option only applies to normal R output (not warnings, messages or errors)
    + markup: mark up the results using the output hook, e.g. put results in a special LaTeX environment
    
* collapse: (FALSE; logical; applies to Markdown output only) whether to, if possible, collapse all the source and output blocks from one code chunk into a single block (by default, they are written to separate blocks)

More options can be found at [https://yihui.name/knitr/options/](https://yihui.name/knitr/options/).

You can use inline R code inside a sentence. For example you can say that the average speed of the car is 15.4, with standard error 0.1057529. Now see the output document.


***Do the following:***

(...below the enumerated list)

1. Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Ctrl+Alt+I*.  
2. Write a simple R command inside this chunk, just to experiment; E.g. write down hist(cars$speed). 
3. Run this R chunk as described earlier.






***Produce the document:***

The document will be saved in the working directory.

* To produce and save the document as a Notebook: click the *Preview* button (or *Knit* button) or press *Ctrl+Shift+K* to preview the HTML file.  
    + When you save the notebook, an HTML file containing the code and output will be saved alongside it.  
    
* To produce and save the document in HTML, PDF or MS Word formats: select the option *Knit to HTML* (or PDF, or Word) available in the menu that appears when you click the little black arrow next to the *Preview* button (or *Knit* button).  
    + This will produce the document in more standard / less functional formats.

---------

# Contigency table: data manipulation

Below we load a table where refers to a 1992 survey by the Wright State University School of Medicine and the United Health Services in Dayton, Ohio. The survey asked 2276 students in their final year of high school in a nonurban area near Dayton, Ohio whether they had ever used alcohol, cigarettes, or marijuana. Denote the variables in this $2 \times 2 \times 2$ table by A for alcohol use, C for cigarette use, and M for marijuana use.

> Load the observed counts in a data frame ` obs.frame  ` and print the result. Use commands :
> 
> * `data.frame()` : as in SC2
> * `factor()` :  to encode a vector as a factor (aka category)
> * `expand.grid()` : to produce all combinations of the supplied vectors or factors.



```r
# I will do this for you

## load the data

obs.frame<-data.frame(count=c(911,538,44,456,3,43,2,279),
                      expand.grid( 
  marijuana=factor(c("Yes","No"),levels=c("No","Yes")),
  cigarette=factor(c("Yes","No"),levels=c("No","Yes")),  
  alcohol=factor(c("Yes","No"),levels=c("No","Yes")))
  ) 

## orint the obs.frame

obs.frame
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

> Create $3$ dimentional contingency table from `obs.frame`. Use command:
> 
> * `xtabs()`, to create a contingency table from cross-classifying factors in a dara.frame


```r
# this is me again
obs.xtabs <- xtabs(count ~ marijuana+cigarette+alcohol, data=obs.frame)
## print 
obs.xtabs
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

> Create a contigency table which contains the row, column, layer, etc...margins. 
> 
> *  Use command `addmargins()` with `obs.xtabs`
> 
> * Save it in `obs.addmargins`


```r
obs.addmargins <- addmargins(obs.xtabs)
obs.addmargins
```

```
## , , alcohol = No
## 
##          cigarette
## marijuana   No  Yes  Sum
##       No   279   43  322
##       Yes    2    3    5
##       Sum  281   46  327
## 
## , , alcohol = Yes
## 
##          cigarette
## marijuana   No  Yes  Sum
##       No   456  538  994
##       Yes   44  911  955
##       Sum  500 1449 1949
## 
## , , alcohol = Sum
## 
##          cigarette
## marijuana   No  Yes  Sum
##       No   735  581 1316
##       Yes   46  914  960
##       Sum  781 1495 2276
```

> Compute the marginal contigency table of marijuana and cigarette. 
> 
> *  Use command `margin.table( , margin = )` and `obs.xtabs`. 
> 
> *  Save it in `obs.mc.xtabs`.


```r
obs.mc.xtabs <- margin.table(obs.xtabs, margin=c(1,2))
obs.mc.xtabs
```

```
##          cigarette
## marijuana  No Yes
##       No  735 581
##       Yes  46 914
```

> Compute the (joint) sampling proportions. 
> 
> *  Use command  `prop.table()` with `obs.xtabs`. 
> 
> *  Save it in `obs.prop.table`.


```r
obs.prop.table <- prop.table(obs.xtabs)
obs.prop.table
```

```
## , , alcohol = No
## 
##          cigarette
## marijuana           No          Yes
##       No  0.1225834798 0.0188927944
##       Yes 0.0008787346 0.0013181019
## 
## , , alcohol = Yes
## 
##          cigarette
## marijuana           No          Yes
##       No  0.2003514938 0.2363796134
##       Yes 0.0193321617 0.4002636204
```

> Create a data.frame of proportions. 
> 
> *  Use the command `as.data.frame()` with `obs.prop.table` 
> 
> * Save it as `obs.prop.frame` 


```r
obs.prop.frame <- as.data.frame(obs.prop.table)
```

> As a homework, you can furhter experiment with commands   
> 
> * `margin.table` : computing  marginal tables  
> 
> * `prop.table`   : computing proportions  
> 
> * `addmargins`   : putting margins on tables;  
> 
>     + e.g., obs.prop.margin <- addmargins(prop.table(obs.xtabs))  



---------

# The Iterative Proportions Fitting method 

The iterative proportional fitting (IPF) algorithm is a simple method for calculating $\mu_{ijk}$ for log-linear models. 


The main idea of the procedure is the following:

*  Start with $\mu_{ijk...}^{(0)}$ satisfying a model no more complex
than the one being fitted. E.g., $\mu_{ijk...}^{(0)}=1.0$ should
be ok.

* For $t=1,...$, 

    + adjust $\mu_{ijk}^{(t)}$ to match by multiplying each marginal table
in the set of minimal sufficient statistics, by appropriate factors
    
    + escape the loop, when the maximum difference between the sufficient
statistics and their fitted values is sufficiently close to zero.



***Illustration:***

Consider $3$-way, $I\times J\times K$ tables, and with classifiers
$X$, $Y$,$Z$. 

Given the model $(XY,XZ,YZ)$ design a IPF recursion producing estimates for $\mu_{ijk}$'s 

Steps:

* Compute the minimal sufficient statistics are $\{n_{ij+}\}$, $\{n_{i+k}\}$, $\{n_{+jk}\}$.

* Assume that the approximated $\mu_{ijk}$'s from the $(t-1)$-th cycle is $\mu_{ijk}^{(t-1)}$. 

* Then the $t$-th cycle of the IPF algorithm has the following steps: 

    + Set $m_{ijk}^{(0)}=\mu_{ijk}^{(t-1)}$ 
    
    +  Compute 
\begin{align*}
m_{ijk}^{(1)} & =m_{ijk}^{(0)}\frac{n_{ij+}}{m_{ij+}^{(0)}};\;\forall i,j,k\\
m_{ijk}^{(2)} & =m_{ijk}^{(1)}\frac{n_{i+k}}{m_{i+k}^{(1)}};\;\forall i,j,k\\
m_{ijk}^{(3)} & =m_{ijk}^{(2)}\frac{n_{+jk}}{m_{+jk}^{(2)}};\;\forall i,j,k
\end{align*}

    + Set $\mu_{ijk}^{(t)}=m_{ijk}^{(3)}$, $\forall i,j,k$ 

...and produces $\mu_{ijk}^{(t)}$ as approximation.


### ***Example***

We use the Alcohol, Cigarette, and Marijuana   data-set


```r
# I will do this for you

## load the data

obs.frame<-data.frame(count=c(911,538,44,456,3,43,2,279),
                      expand.grid( 
  marijuana=factor(c("Yes","No"),levels=c("No","Yes")),
  cigarette=factor(c("Yes","No"),levels=c("No","Yes")),  
  alcohol=factor(c("Yes","No"),levels=c("No","Yes")))
  ) 

## orint the obs.frame

obs.frame
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

> * Consider the Log-linear model describing a homogeneous association between each pair of variables at each level of the third one; i.e. $[XY,XZ,YZ]$  
>   
> * Find the fitted values for $\mu_{i,j,k}$

***Solution***



```r
# Step 1 :  compute and save the minimal statistics

obs.xtab <- xtabs(obs.frame)
n_xy <- margin.table(obs.xtab,c(1,2))
n_xz <- margin.table(obs.xtab,c(1,3))
n_yz <- margin.table(obs.xtab,c(2,3))

# Step 2: Create a seed for the fitted mu's

# seed the mu_opt
mu_opt <- obs.xtab
for(i in 1:2)
  for(j in 1:2)
    for(k in 1:2)
      mu_opt[i,j,k] = 1.0

# Step 3: Perform the loop to approximate the mu's

for (t in 1: 100) {
  
  mu_xy <- margin.table(mu_opt,c(1,2))
  for (k in 1:2) mu_opt[,,k] <- mu_opt[,,k]*n_xy/mu_xy
  
  mu_xz <- margin.table(mu_opt,c(1,3))
  for (j in 1:2) mu_opt[,j,] <- mu_opt[,j,]*n_xz/mu_xz
  
  mu_yz <- margin.table(mu_opt,c(2,3))
  for (i in 1:2) mu_opt[i,,] <- mu_opt[i,,]*n_yz/mu_yz
}
```

> Present the fitted $\mu$'s as a data frame


```r
as.data.frame(mu_opt)
```

```
##   marijuana cigarette alcohol      Freq
## 1        No        No      No 279.61683
## 2       Yes        No      No   1.38317
## 3        No       Yes      No  42.38317
## 4       Yes       Yes      No   3.61683
## 5        No        No     Yes 455.38317
## 6       Yes        No     Yes  44.61683
## 7        No       Yes     Yes 538.61683
## 8       Yes       Yes     Yes 910.38317
```

> You can double check your result with the output of the R package


```r
obs.xtab <- xtabs(obs.frame)
library(MASS)
fitAC.AM.CM<-loglm( count~alcohol*cigarette+ alcohol*marijuana +cigarette*marijuana,
              data=obs.xtab,
              param=T,
              fit=T)
fit.array<- fitted(fitAC.AM.CM)
fit.array
```

```
## , , alcohol = No
## 
##          cigarette
## marijuana        No       Yes
##       No  279.61440 42.383882
##       Yes   1.38316  3.616919
## 
## , , alcohol = Yes
## 
##          cigarette
## marijuana        No      Yes
##       No  455.38560 538.6161
##       Yes  44.61684 910.3831
```

```r
as.data.frame(fit.array)
```

```
##         No.No    Yes.No    No.Yes  Yes.Yes
## No  279.61440 42.383882 455.38560 538.6161
## Yes   1.38316  3.616919  44.61684 910.3831
```


### ***Example***

> * Consider the Log-linear model describing mutual independence; i.e. $[X, Y,Z]$  
>   
> * Find the fitted values for $\mu_{i,j,k}$

***Solution***


```r
# Step 1 :  compute and save the minimal statistics

obs.xtab <- xtabs(obs.frame)
n_x <- margin.table(obs.xtab,c(1))
n_y <- margin.table(obs.xtab,c(2))
n_z <- margin.table(obs.xtab,c(3))

# Step 2: Create a seed for the fitted mu's

# seed the mu_opt
mu_opt <- obs.xtab
for(i in 1:2)
  for(j in 1:2)
    for(k in 1:2)
      mu_opt[i,j,k] = 1.0

# Step 3: Perform the loop to approximate the mu's

for (t in 1: 100) {
  
  mu_x <- margin.table(mu_opt,c(1))
  for (j in 1:2) 
    for (k in 1:2) 
      mu_opt[,j,k] <- mu_opt[,j,k]*n_x/mu_x
  
  mu_y <- margin.table(mu_opt,c(2))
  for (i in 1:2) 
    for (k in 1:2) 
      mu_opt[i,,k] <- mu_opt[i,,k]*n_y/mu_y
  
  mu_z <- margin.table(mu_opt,c(3))
  for (i in 1:2)
    for (j in 1:2)
      mu_opt[i,j,] <- mu_opt[i,j,]*n_z/mu_z
}


mu_opt
```

```
## , , alcohol = No
## 
##          cigarette
## marijuana        No       Yes
##       No   64.87990 124.19392
##       Yes  47.32880  90.59739
## 
## , , alcohol = Yes
## 
##          cigarette
## marijuana        No       Yes
##       No  386.70007 740.22612
##       Yes 282.09123 539.98258
```



***Example (Homework)***

The table below, summarises summarizes observations of 68,694 passengers in autos and light
trucks involved in accidents in the state of Maine in 1991. The table classifies
passengers by gender (G), location of accident (Z), seat-belt use (S), and
injury (I). The Table reports the sample proportion of passengers who were
injured. For each GL combination, the proportion of injuries was about
halved for passengers wearing seat belts.


```r
# load dataset
obs.frame.accident<-data.frame(
  count=c(7287,11587,3246,6134,10381,10969,6123, 6693,996, 759, 973, 757, 812, 380, 1084, 513) ,
  expand.grid(
    belt=c("No","Yes"), 
    location=c("Urban","Rural"), 
    gender=c("Female","Male"), 
    injury=c("No","Yes"))
)
#print dataset
obs.frame.accident
```

```
##    count belt location gender injury
## 1   7287   No    Urban Female     No
## 2  11587  Yes    Urban Female     No
## 3   3246   No    Rural Female     No
## 4   6134  Yes    Rural Female     No
## 5  10381   No    Urban   Male     No
## 6  10969  Yes    Urban   Male     No
## 7   6123   No    Rural   Male     No
## 8   6693  Yes    Rural   Male     No
## 9    996   No    Urban Female    Yes
## 10   759  Yes    Urban Female    Yes
## 11   973   No    Rural Female    Yes
## 12   757  Yes    Rural Female    Yes
## 13   812   No    Urban   Male    Yes
## 14   380  Yes    Urban   Male    Yes
## 15  1084   No    Rural   Male    Yes
## 16   513  Yes    Rural   Male    Yes
```

> Consider the Homogeneity association model $(GL,GS,GI,LS,LI,SI)$, and compute the fitted values for $\mu_{i,j,k,c}$


***Solution***


```r
# Step 1 :  compute and save the minimal statistics

obs.frame <- obs.frame.accident

obs.xtab <- xtabs(obs.frame)
n_ZGI <- margin.table(obs.xtab,c(2,3,4))
n_SGI <- margin.table(obs.xtab,c(1,3,4))
n_SZI <- margin.table(obs.xtab,c(1,2,4))
n_SZG <- margin.table(obs.xtab,c(1,2,3))


# Step 2: Create a seed for the fitted mu's

# seed the mu_opt
mu_opt <- obs.xtab
for(s in 1:2)
  for(z in 1:2)
    for(g in 1:2)
    	for(i in 1:2)
      	  mu_opt[s,z,g,i] = 1.0

# Step 3: Perform the loop to approximate the mu's

for (t in 1: 100) {
  
  mu_ZGI <- margin.table(mu_opt,c(2,3,4))
  for (s in 1:2) mu_opt[s,,,] <- mu_opt[i,,,]*n_ZGI/mu_ZGI

  mu_SGI <- margin.table(mu_opt,c(1,3,4))
  for (z in 1:2) mu_opt[,z,,] <- mu_opt[,z,,]*n_SGI/mu_SGI
  
  mu_SZI <- margin.table(mu_opt,c(1,2,4))
  for (g in 1:2) mu_opt[,,g,] <- mu_opt[,,g,]*n_SZI/mu_SZI
  
  mu_SZG <- margin.table(mu_opt,c(1,2,3))
  for (i in 1:2) mu_opt[,,,i] <- mu_opt[,,,i]*n_SZG/mu_SZG
}

mu_opt
```

```
## , , gender = Female, injury = No
## 
##      location
## belt       Urban      Rural
##   No   7281.8646  3274.7034
##   Yes 11596.7084  6123.8512
## 
## , , gender = Male, injury = No
## 
##      location
## belt       Urban      Rural
##   No  10376.7585  6109.6871
##   Yes 10959.3690  6703.0254
## 
## , , gender = Female, injury = Yes
## 
##      location
## belt       Urban      Rural
##   No   1001.1354   944.2966
##   Yes   749.2916   767.1488
## 
## , , gender = Male, injury = Yes
## 
##      location
## belt       Urban      Rural
##   No    816.2415  1097.3129
##   Yes   389.6310   502.9746
```


> Consider the independent model $(G, S, L, I)$, and compute the fitted values for $\mu_{i,j,k,c}$

***Solution***


```r
# Step 1 :  compute and save the minimal statistics

obs.frame <- obs.frame.accident

obs.xtab <- xtabs(obs.frame)
n_S <- margin.table(obs.xtab,c(1))
n_Z <- margin.table(obs.xtab,c(2))
n_G <- margin.table(obs.xtab,c(3))
n_I <- margin.table(obs.xtab,c(4))


# Step 2: Create a seed for the fitted mu's

# seed the mu_opt
mu_opt <- obs.xtab
for(s in 1:2)
  for(z in 1:2)
    for(g in 1:2)
    	for(i in 1:2)
      	  mu_opt[s,z,g,i] = 1.0

# Step 3: Perform the loop to approximate the mu's

for (t in 1: 100) {
  
  mu_S <- margin.table(mu_opt,c(1))
  for(z in 1:2)
    for(g in 1:2)
    	for(i in 1:2)
		mu_opt[,z,g,i] <- mu_opt[,z,g,i]*n_S/mu_S
  
  mu_Z <- margin.table(mu_opt,c(2))
  for(s in 1:2)
    for(g in 1:2)
    	for(i in 1:2)
		mu_opt[s,,g,i] <- mu_opt[s,,g,i]*n_Z/mu_Z
  
  mu_G <- margin.table(mu_opt,c(3))
  for(s in 1:2)
    for(z in 1:2)
    	for(i in 1:2)
		mu_opt[s,z,,i] <- mu_opt[s,z,,i]*n_G/mu_G
  
  mu_I <- margin.table(mu_opt,c(4))
  for(s in 1:2)
    for(z in 1:2)
    	for(g in 1:2)
		mu_opt[s,z,g,] <- mu_opt[s,z,g,]*n_I/mu_I

}


mu_opt
```

```
## , , gender = Female, injury = No
## 
##      location
## belt       Urban      Rural
##   No   8153.4100  4820.3536
##   Yes  9971.3181  5895.1137
## 
## , , gender = Male, injury = No
## 
##      location
## belt       Urban      Rural
##   No   9493.3447  5612.5324
##   Yes 11610.0085  6863.9190
## 
## , , gender = Female, injury = Yes
## 
##      location
## belt       Urban      Rural
##   No    819.5209   484.5065
##   Yes  1002.2437   592.5335
## 
## , , gender = Male, injury = Yes
## 
##      location
## belt       Urban      Rural
##   No    954.2013   564.1305
##   Yes  1166.9528   689.9107
```




---------

# Newton Method 

Newton's method is a general purpose procedure to compute numerically 
the solution of a system of non-linear equations given that a number 
of assumptions are satisfied. 

***In general.***

* Let function $f:\mathbb{R}^{n}\rightarrow\mathbb{R}^{n}$. 
* Assume you need to find the solution $x^{*}$ of the equation 

\begin{equation}
f(x^{*})=0\label{eq:asfdgadf}
\end{equation}

* Newtons's method for solving the system (\ref{eq:asfdgadf}) is the
recursion 

\begin{equation}
x^{(t+1)}=x^{(t)}-[\nabla_{x}f(x^{(t)})]^{-1}f(x^{(t)})\label{eq:dfghsdha}
\end{equation}

 for $t\in\mathbb{N}$ and for a pre-specified seed value $x^{(0)}\in\mathbb{R}^{n}$.

+ In theory, Newton's method converges to the solution quadratically;
i.e.
\[
\lim_{t\rightarrow\infty}\frac{|x^{(t+1)}-x^{*}|_{\infty}}{|x^{(t)}-x^{*}|_{\infty}^{2}}=0
\]
under regularity conditions discussed in (Numerical analysis / R.
L. Burden, J. D. Faires.)

* In practice, we run Newton's recursion several times starting from
a different seed each time. 


***An intuitive explanation why it works***

* From the Taylor expansion, and assuming that $\nabla_{x}^{2}f(x)$ is continuous, I get 
\[
f(x_{t+1})=f(x_{t})+\nabla_{x}f(x_{t})(x_{t+1}-x_{t})+O(|x_{t+1}-x_{t}|^{2})
\]
 and by ignoring the error term and rearranging the quantities I get
\[
x_{t+1}\sim x_{t}+\nabla_{x}f(x_{t})(f(x_{t+1})-f(x_{t}))
\]

* If $x_{t+1}$ is the solution, or close to that, then $f(x_{t+1})=0$,
and hence 
\[
x_{t+1}\sim x_{t}-\nabla_{x}f(x_{t})f(x_{t})
\]

* Now, we see that the gradient of $f$ times the values of $f$ at $x_{t}$ leads the sequence towards locations where $f$ is zero. 

* So, eventually, it may work ...


***Pseudo-algorithm of Newton's method:***


`Aim` Approximate the solution of $f(x)=0$

`Input` number of equations $n$; seed $x^{(0)}=(x_{1}^{(0)},...,x_{n}^{(0)})\in\mathbb{R}^{n}$;
tolerance $\tau$ ; maximum number of iterations $T$

`Output:` Approximate solution $x^{*}\in\mathbb{R}^{n}$; trace
of $x^{(t)}$; trace of relative error $\tau^{(t)}=|x^{(t)}-x^{(t-1)}|_{\infty}$;
number of iterations performed $t$ 

1. Set $x_{\text{opt}}=x^{(0)}$
2. Set $t=1$
3. While ($t\le T$) do:
    i) Compute $n\times1$ vector $F\in\mathbb{R}^{n}$ whose
$i$-th element is $F_{i}=f(x_{\text{opt},i})$
    ii) Compute $n\times n$ vector $J\in\mathbb{R}^{n\times n}$
whose $(i,j)$-th element is $J_{i,j}=\frac{\text{d}}{\text{d}x_{j}}f_{i}(x_{\text{opt}})$
for $(i,j)\in\{1,...,n\}^{2}$
    iii) Solve the $n\times n$ linear system $Jy=-F$ and
compute $y\in\mathbb{R}^{n}$
    iv) Update $x_{\text{opt}}=x_{\text{opt}}+y$ 
    v) Compute $\epsilon^{*}= |y|_{\infty}$
    vi) If $\epsilon^{*}<\tau$, then escape from the loop
    vii) Increase the time step $t=t+1$ 
4. Set $x^{*}=x_{\text{opt}}$
5. Return as output: Return as output: $x^{*}$, $t^{*}$, and $\epsilon^{*}$.

### ***Example***

Solve the system of non-linear equations
\[
\begin{cases}
\cos(x_{2}x_{3})+\frac{1}{2} & =3x_{1}\\
81(x_{2}+0.1)^{2} & =x_{1}^{2}+(x_{3}+0.1)^{2}+\sin(x_{3})+1.06\\
-\frac{10\pi-3}{3} & =\exp(-x_{1}x_{2})+20x_{3}
\end{cases}
\]


***Solution***

This is equivalent to solving the system $f(x_{1},x_{2},x_{3})=0$
where
\[
f(x)=\begin{bmatrix}3x_{1}-\cos(x_{2}x_{3})-\frac{1}{2}\\
x_{1}^{2}-81(x_{2}+0.1)^{2}+\sin(x_{3})+1.06\\
\exp(-x_{1}x_{2})+20x_{3}+\frac{10\pi-3}{3}
\end{bmatrix}
\]
 with Jacobian 
\[
\nabla_{x}f(x)=\begin{bmatrix}3 & x_{3}\sin(x_{2}x_{3}) & x_{2}\sin(x_{2}x_{3})\\
2x_{1} & -162(x_{2}+0.1) & \cos(x_{3})\\
-x_{2}\exp(-x_{1}x_{2}) & -x_{1}\exp(-x_{1}x_{2}) & 20
\end{bmatrix}
\]

I need to supply the Newton's algorithm with the quantities above, as well as consider a tolerance,
e.g. $1e-4$ (meaning $10^{-4}$), seed value e.g., $x^{(0)}=(0.1,0.1,-0.1)^{T}$, etc...


> Create a function for $f(x)$, and called `my.f()`



```r
my.f <- function(x) {
  f1 <- 3*x[1]-cos(x[2]*x[3])-0.5
  f2 <- x[1]*x[1] -81*(x[2]+0.1)*(x[2]+0.1) +sin(x[3]) +1.06
  f3 <- exp(-x[1]*x[2])+20*x[3]+(10*pi-3)/3
  fvec <- matrix(c(f1,f2,f3),nrow=3)
  return(fvec)
  }
```


> Create a function for $\nabla_x f(x)$, and call it `my.Df`


```r
my.Df <- function(x) {
  Df11 <- 3
  Df12 <- x[3]*sin(x[2]*x[3])
  Df13 <- x[2]*sin(x[2]*x[3])
  Df21 <- 2*x[1]
  Df22 <- -162*(x[2]+0.1)
  Df23 <- cos(x[3])
  Df31 <- -x[2]*exp(-x[1]*x[2])
  Df32 <- -x[1]*exp(-x[1]*x[2])
  Df33 <- 20
  fmat <- matrix( c(Df11, Df21, Df31, 
                    Df12, Df22, Df32, 
                    Df13, Df23, Df33 ), 
                  nrow=3, byrow=FALSE)
  return(fmat)
  }
```


> Create a function called `my.newton.method()` which:
> 
> * gets as arguments: 
> 
>     + the function $f(x)$,  
>     + the gradient $\nabla_x f(x)$,  
>     + number of equations $n$;  
>     + seed $x^{(0)}=(x_{1}^{(0)},...,x_{n}^{(0)})\in\mathbb{R}^{n}$;  
>     + tolerance $\tau$ ;   
>     + maximum number of iterations $T$, etc...  
> 
> * returns:  
> 
>     + approximate solution $x^{*}\in\mathbb{R}^{n}$; 
>     + the last relative error $\tau^{*}$;
>     + number of iterations performed $t^{*}$ , etc...
> 
> * use commands 
> 
>     + `solve()` : to solve the system $Ax=b$ 
>     
>     + `while () {...}`: to perform the loop 
>     
>     + `break`: to escape from the loop



```r
my.newton.method <- function(my.f, my.Df, x0, tol, Tmax) {
  
  xopt = x0
  
  t = 1
  
  while (t <= Tmax) {
    
    xnow = xopt
    
    F = my.f( xnow )
    
    J = my.Df( xnow )
    
    y = solve(J, -F )
    
    xnew = xnow + y
    
    xopt = xnew
    
    err = max(abs(y))
    
    if ( err <= tol) break
    
    t = t +1 
    
  } 
  
  return(list(xopt=xopt, Tmax=t, err=err))
}
```


> Solve the equation by using the function the you created


```r
#Try me ...

x0  = c(0.1,0.1,-0.1)
tol = 0.00001
Tmax = 200

obj <- my.newton.method(my.f, my.Df, x0, tol, Tmax)

obj$xopt
```

```
##               [,1]
## [1,]  5.000000e-01
## [2,]  4.005740e-18
## [3,] -5.235988e-01
```

```r
obj$Tmax
```

```
## [1] 5
```

```r
obj$err
```

```
## [1] 7.757857e-10
```




## Newton method for the Log linear model

* I wish to solve non-linear equation $X^{T}n=X^{T}\hat{\mu}(\beta)$
where matrix $X$ is the design matrix given the non-identifiability constrints, e.g., for the model $(XY,XZ,YZ)$. 

* Equivalently, I want to find $\hat{\beta}$ for $f(\hat{\beta})=0$
, where $f(\hat{\beta})=X^{T}(n-\mu(\hat{\beta}))$

* The Jacobian is 
\begin{align*}
\nabla_{\beta}f(\beta) & =\nabla_{\beta}X^{T}(n-\mu(\beta))\;=\nabla_{\beta}[X^{T}\mu(\beta)]\\
 & =X^{T}\text{diag}(\mu(\beta))X
\end{align*}
 Because the $(j,k)$th element of $\nabla_{\beta}[X^{T}\mu(\beta)]$
is 
\begin{align*}
\left[\nabla_{\beta}[X^{T}\mu(\beta)]\right]_{j,k} & =-\frac{\text{d}}{\text{d}\beta_{k}}\sum_{i}X_{i,j}\exp(\sum_{j}X_{i,j}\beta_{j})\\
 & =-\sum_{i}X_{i,j}\exp(\sum_{j}X_{i,j}\beta_{j})X_{i,k}
\end{align*}
since $\mu_{i}(\beta)=\exp(\sum_{j}X_{i,j}\beta_{j})$.

* Then the Newton's recursion (\ref{eq:dfghsdha}) becomes 
\[
\beta_{t+1}=\beta_{t}+[X^{T}\text{diag}(\mu(\beta_{t}))X]^{-1}X^{T}(n-\mu(\beta_{t}))
\]

* It is proven that $\beta_{t}\rightarrow\hat{\beta}$.



### ***Example (For Homework)***

Consider the data-set, Alcohol, Cigarette, and Marijuana


```r
## load the data

obs.frame<-data.frame(count=c(911,538,44,456,3,43,2,279),
                      expand.grid( 
  marijuana=factor(c("Yes","No"),levels=c("No","Yes")),
  cigarette=factor(c("Yes","No"),levels=c("No","Yes")),  
  alcohol=factor(c("Yes","No"),levels=c("No","Yes")))
  ) 

## orint the obs.frame

obs.frame
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

> Consider:
> 
> * a Log-linear model describing a homogeneous association between each pair of variables at each level of the third one; i.e. $[AC,AM,CM]$
> 
> * as identifiability constraints the corner points where the reference levels are the last levels; namely, $2$ (yes), $2$ (yes), and $2$ (yes) for marijuana, cigarette, and alcohol.
> 
> Use Newton method in order to compute $\lambda$'s
> 
> Estimate the log linear model coefficients


***Solution ***


```r
# This is a homework for further practice.
```







# Save me  

Generate the document as a Notebook, PDF, Word, or HTML by choosing the relevant option (from the pop-up menu next to the Preview button). Then save your Markdown code by choosing the relevant option (from the task bar menu).

Save the *.Rmd script, so that you can edit it later.