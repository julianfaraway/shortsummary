# Make lm() and glm() summaries shorter

Consider the standard printed summary of an lm() fit in R:

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
same screen. Perhaps you are student with a page limit on your assignment.

- We don't need to see the call again. We can see the calling function already
as would be typical if using Rmarkdown or Jupyter notebooks etc. Seeing
the call function is only useful if you can only see the output.

- I'm usually not interested in the residuals information. Some guy back
in the 1980s thought it was a good idea and it's been stuck there ever since. If
I want it, I can do `fivenum(residuals(lmod))` or probably just plot the residuals.

- I can see it is the coefficients so I don't need to see `Coefficients:`

- An extra empty line at the beginning and end

Let's fix that:

```
> library(farawayutils)
> lmod = lm(dist ~ speed, cars)
> summary(lmod)
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  -17.579      6.758   -2.60    0.012
speed          3.932      0.416    9.46   <1e-04

Residual standard error: 15.4 on 48 degrees of freedom
Multiple R-squared:  0.651,	Adjusted R-squared:  0.644 
F-statistic: 89.6 on 1 and 48 DF,  p-value: <1e-04
```

This is a mere 7 lines of output compared to the original 17.

# WARNING

This package replaces the `print.summary.lm()` and `print.summary.glm()` functions
in the `stats` package which is loaded every time you start `R`. Usually
this is a *very bad thing* to do because changing the expected functionality
of base `R` could have many unpredictable side effects. But in this case, I am
only changing what is printed in the output. The components of the model
fit computed by `lm()` or `glm()` and the associated `summary()` functions
are not changed at all. When you do `lmodsum <- summary(lmod)`, various model
components are computed and found in `lmodsum`. If you don't save the output, it
is printed using `print.summary.lm()` - this is the function I have modified.

# ALTERNATIVES

One can just write your own version of `print.summary.lm()`. I did this in
my `faraway` R package which I used in the second edition of my two
red R books. This produces:

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
in the `display()` function of the `arm` package.

The drawback in this approach arises in teaching R/Statistics
to new users. Installing a package and remembering to load it
will be challenging to new users. Explaining why there
are two versions of the linear model output will be another issue.
You can expect to get lots of emails about this. One can
avoid this additional complexity by just using the base stats
function without additional packages.

# INSTALLATION

Assuming you have already installed the  `devtools` R package, 
install this package with:

```
devtools::install_github("julianfaraway/farawayutils")
```
