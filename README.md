# Make lm and glm summaries shorter

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
same screen.

- We don't need to see the call again. We can see the calling function already
as would be typical if using Rmarkdown or Jupyter notebooks etc. 

- I'm usually not that interested in the residuals stats information. Some guy
in the 1980s thought it was a good idea and it's been stuck there ever since. If
I want it, I can do `fivenum(residuals(lmod))` or probably just plot the residuals.

- I can see its the coefficients so I don't need to see `Coefficients:`

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



Assuming you have already installed the  `devtools` R package, install this package with:

```
devtools::install_github("julianfaraway/farawayutils")
```
