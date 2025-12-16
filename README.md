# Make lm(), glm() and other model summaries shorter

Consider the standard printed summary of an `lm()` fit in R:

```
> lmod = lm(dist ~ speed, cars)
> summary(lmod)

Call:
lm(formula = dist ~ speed, data = cars)

Residuals:
   Min     1Q Median     3Q    Max 
-29.07  -9.53  -2.27   9.21  43.20 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  -17.579      6.758   -2.60    0.012
speed          3.932      0.416    9.46  1.5e-12

Residual standard error: 15.4 on 48 degrees of freedom
Multiple R-squared:  0.651,	Adjusted R-squared:  0.644 
F-statistic: 89.6 on 1 and 48 DF,  p-value: 1.49e-12

```

It's much longer than necessary. This is a waste of paper if you print it out
and makes on screen output longer which is a nuisance if you want to compare
it to other output since it is less likely to fit on the
same screen. Also, perhaps you have a page limit.

- We don't need to see the call again. We can see the calling function already
as would be typical if using Rmarkdown or Jupyter notebooks etc. Seeing
the call function is only useful if you can only see the output.

- I'm usually not immediately interested in the residuals information. Some guy back
in the olden days of `S` thought it was a good idea and 
it's been stuck there ever since. If
I want it, I can do `fivenum(residuals(lmod))` or better, just plot the residuals.

- I can see it is the coefficients so I don't need to see `Coefficients:`

- There's an extra empty line at the beginning and end. If we want extra space,
we can rely on Rmarkdown, LaTeX, Jupyter etc. to provide this. We don't want
it built into the output.

Let's fix that with this R package:

```
> library(shortsummary)
> lmod = lm(dist ~ speed, cars)
> summary(lmod)
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  -17.579      6.758   -2.60    0.012
speed          3.932      0.416    9.46   <1e-04

Residual standard error: 15.4 on 48 degrees of freedom
Multiple R-squared:  0.651,	Adjusted R-squared:  0.644 
F-statistic: 89.6 on 1 and 48 DF,  p-value: <1e-04
```

We've saved 10 lines of output. Now think of how many bazillions
of linear model summaries have been produced using R - think
of the savings!

Now look at a GLM:

```
> gmod = glm(dist ~ speed, cars, family=gaussian)
> summary(gmod)

Call:
glm(formula = dist ~ speed, family = gaussian, data = cars)

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  -17.579      6.758   -2.60    0.012
speed          3.932      0.416    9.46  1.5e-12

(Dispersion parameter for gaussian family taken to be 236.53)

    Null deviance: 32539  on 49  degrees of freedom
Residual deviance: 11354  on 48  degrees of freedom
AIC: 419.2

Number of Fisher Scoring iterations: 2

```

- As above, we could do without the `Call` and the `Coefficients`

- The residuals stats are not displayed (although there is an option for this).

- I am going to keep the dispersion parameter and deviances. It
would be more useful to have the square root of the dispersion since
this would be the residual standard error. When you fit a binomial
or a Poisson, the dispersion parameter is fixed at one so you don't
need this line for these two instances. The deviances are not that
useful directly but you could construct a test statistic using them.
My preference would be to print something else but we are just shortening
the output here, not changing it.

- I don't need to see the AIC now. There's nothing I can do with this
number by itself. It's only useful for comparing to other models and
then I would use the `AIC()` function or the residual deviances we
already have.

- I don't care how many Fisher Scoring iterations were required. It's
a technical detail of the fitting algorithm. I'm glad someone cares about
it but I am happy to trust them on that. If
there's a convergence problem, we'll get a warning about that.

- Again, we have extra blank lines at the beginning and end that
we could do without. There are two interior blank lines but let's
keep them.

Here's the shorter summary:

```
> library(shortsummary)
> gmod = glm(dist ~ speed, cars, family=gaussian)
> summary(gmod)
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  -17.579      6.758   -2.60    0.012
speed          3.932      0.416    9.46  1.5e-12

(Dispersion parameter for gaussian family taken to be 236.53)

    Null deviance: 32539  on 49  degrees of freedom
Residual deviance: 11354  on 48  degrees of freedom
```

That's 9 lines shorter.

# Warning

This package replaces the `print.summary.lm()` and `print.summary.glm()` functions
in the `stats` package which is loaded every time you start `R`. Usually
this is a *very bad thing* to do because changing the expected functionality
of base `R` could have many unpredictable side effects. But in this case, I am
only changing what is printed in the output. The components of the model
fit computed by `lm()` or `glm()` and the associated `summary()` functions
are not changed at all. When you do `lmodsum <- summary(lmod)`, various model
components are computed and found in `lmodsum`. If you don't save the output, it
is printed using `print.summary.lm()` - this is the function I have modified.

Also, it would appear that one only has the opportunity replace these functions
at the beginning of the session. Once you have already used the built-in
version of the function, you can no longer change it and loading my package
will have no effect. For example, if you execute the code above in the order
it appears, it won't produce the expected shorter summaries.

# Alternatives

You can just write your own version of `print.summary.lm()`. I did this in
my [faraway](https://github.com/julianfaraway/faraway) R package which 
I used in the second editions of my two red R books. Using a wrapper function
like this is the officially recommended way to deal with this issue.
This produces:

```
> library(faraway)
> sumary(lmod)
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  -17.579      6.758   -2.60    0.012
speed          3.932      0.416    9.46  1.5e-12

n = 50, p = 2, Residual SE = 15.380, R-Squared = 0.65
```

Now I am down to 5 lines. One usually does not need the F-statistic
and the Adjusted R-squared is surplus to requirements. Seeing
`n` and `p` is helpful. You can see something similar
in the `display()` function of the [arm](https://CRAN.R-project.org/package=arm) package.

The drawback in this approach arises in teaching R/Statistics
to new users. Installing a package and remembering to load it
is challenging to many new users. Explaining why there
are two versions of the linear model output will be another issue.
You can expect to get lots of questions about this. One can
avoid this additional complexity by just using the base stats
function without additional packages. I like packages
but they cause problems for beginners.

The purpose of this package is to produce documentation with
shorter linear model summaries while apparently only using base `R` commands.
One can quietly load the package without explaining or add a footnote
for the curious.

# Installation

Assuming you have already installed the  `devtools` R package, 
install this package with:

```
devtools::install_github("julianfaraway/shortsummary")
```

This package will never be on CRAN because it does a *very bad thing*
as explained in the Warning section above.

# History

(Warning: I may not recall this correctly)

In earlier versions of 1980s S, you didn't get a fancy summary.
You got some of the parts and had to do your own assembly. You
had to use the `lsfit()` function, which still exists.
Moving into the 1990s, there
were some big developments in statistics modelling described
in [Statistical Models in S](https://doi.org/10.1201/9780203738535). A lot of
modelling functionality and syntax we use today was introduced.
The `summary()`  output was similar but no p-values or F-statistics. You got
the correlation of coefficients by default.

When `R` supplanted `S+`, the summary model output changed somewhat. It was at this time, someone
had the bad idea of adding significance stars to the default summary
but at least there's an option to turn them off. The display of the correlation of coefficients
was made optional. In the `glm()` summary, the residual display is turned off
by default but unfortunately, they were kept for the `lm()` summary. This
was likely the last chance to make any substantive change to the `summary()`
output as there's (understandably) a very strong bias 
against making changes to commonly-used output.

# LME4

Consider the output from an `lme4` fit:

```
> library(lme4)
> fm1 <- lmer(Reaction ~ Days + (Days | Subject), sleepstudy)
> summary(fm1)
Linear mixed model fit by REML ['lmerMod']
Formula: Reaction ~ Days + (Days | Subject)
   Data: sleepstudy

REML criterion at convergence: 1743.6

Scaled residuals: 
   Min     1Q Median     3Q    Max 
-3.954 -0.463  0.023  0.463  5.179 

Random effects:
 Groups   Name        Variance Std.Dev. Corr
 Subject  (Intercept) 612.1    24.74        
          Days         35.1     5.92    0.07
 Residual             654.9    25.59        
Number of obs: 180, groups:  Subject, 18

Fixed effects:
            Estimate Std. Error t value
(Intercept)   251.41       6.82   36.84
Days           10.47       1.55    6.77

Correlation of Fixed Effects:
     (Intr)
Days -0.138
```

That's rather long. We don't need most of this:

- We already know it's a linear mixed model fit and REML is the default
- We can see the formula in the command
- We know which dataset
- We can get the REML criterion from the 2*log-likelihood if we really wanted it
- We'll plot the residuals later - we don't want to look at them now
- We've probably checked on the size of the dataset and the number of groups earlier
- We don't usually care too much about the correlation of the fixed effects

Now restart R and do it 

```
> library(shortsummary)
> library(lme4)
> fm1 <- lmer(Reaction ~ Days + (Days | Subject), sleepstudy)
> summary(fm1)
Random effects:
 Groups   Name        Variance Std.Dev. Corr
 Subject  (Intercept) 612.1    24.74        
          Days         35.1     5.92    0.07
 Residual             654.9    25.59        

Fixed effects:
            Estimate Std. Error t value
(Intercept)   251.41       6.82   36.84
Days           10.47       1.55    6.77
```

That's all we really wanted using 15 fewer lines.

