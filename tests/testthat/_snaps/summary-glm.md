# gaussian glm summary has expected short output

    Code
      output
    Output
      [1] "            Estimate Std. Error t value Pr(>|t|)    \n(Intercept) -17.5791     6.7584  -2.601   0.0123 *  \nspeed         3.9324     0.4155   9.464 1.49e-12 ***\n\n(Dispersion parameter for gaussian family taken to be 236.5317 )\n\n    Null deviance: 32539  on 49  degrees of freedom\nResidual deviance: 11354  on 48  degrees of freedom"

# binomial glm summary has expected short output

    Code
      output
    Output
      [1] "            Estimate Std. Error z value Pr(>|z|)   \n(Intercept) 18.86630    7.44356   2.535  0.01126 * \nwt          -8.08348    3.06868  -2.634  0.00843 **\nhp           0.03626    0.01773   2.044  0.04091 * \n\n    Null deviance: 43.230  on 31  degrees of freedom\nResidual deviance: 10.059  on 29  degrees of freedom"

# Poisson glm summary has expected short output

    Code
      output
    Output
      [1] "             Estimate Std. Error z value Pr(>|z|)    \n(Intercept)  2.215060   0.586567   3.776 0.000159 ***\nmpg         -0.031374   0.019768  -1.587 0.112489    \nhp           0.001388   0.001548   0.897 0.369897    \n\n    Null deviance: 16.574  on 31  degrees of freedom\nResidual deviance:  3.499  on 29  degrees of freedom"

