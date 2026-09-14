# gls summary has expected short output

    Code
      output
    Output
      [1] "                Value Std.Error   t-value p-value\n(Intercept) 16.761111 1.2255602 13.676286       0\nage          0.660185 0.1091816  6.046672       0\n\nResidual standard error: 2.537151 \nDegrees of freedom: 108 total; 106 residual"

# lme summary has expected short output

    Code
      output
    Output
      [1] "Random effects:\n Formula: ~age | Subject\n Structure: General positive-definite, Log-Cholesky parametrization\n            StdDev    Corr  \n(Intercept) 2.3270340 (Intr)\nage         0.2264278 -0.609\nResidual    1.3100397       \n\n\nFixed effects:\n                Value Std.Error DF   t-value p-value\n(Intercept) 16.761111 0.7752460 80 21.620377       0\nage          0.660185 0.0712533 80  9.265333       0"

# merMod summary has expected short output

    Code
      output
    Output
      [1] "Random effects:\n Groups   Name        Variance Std.Dev. Corr \n Subject  (Intercept) 612.10   24.741        \n          Days         35.07    5.922   0.07 \n Residual             654.94   25.592        \n\nFixed effects:\n            Estimate Std. Error t value\n(Intercept)  251.405      6.825  36.838\nDays          10.467      1.546   6.771"

# gam summary has expected short output

    Code
      output
    Output
      [1] "\nParametric coefficients:\n            Estimate Std. Error t value Pr(>|t|)    \n(Intercept)  31.0401     2.1488  14.445 4.24e-14 ***\nwt           -3.4034     0.6566  -5.184 1.95e-05 ***\n\nApproximate significance of smooth terms:\n       edf Ref.df    F  p-value    \ns(hp) 3.43  4.173 6.15 0.000949 ***\n\nR-sq.(adj) = 0.863  Deviance explained = 88.3 %\nScale est. = 4.9689    n = 32 "

# coxph summary has expected short output

    Code
      output
    Output
      [1] "        coef exp(coef) se(coef)      z Pr(>|z|)   \nage  0.14733   1.15873  0.04615  3.193  0.00141 **\nrx  -0.80397   0.44755  0.63205 -1.272  0.20337   \n---\nSignif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1\n\n    exp(coef) exp(-coef) lower .95 upper .95\nage    1.1587      0.863    1.0585     1.268\nrx     0.4475      2.234    0.1297     1.545\n\nConcordance= 0.798  (se = 0.076 )\nLikelihood ratio test= 15.89  on 2 df,   p=4e-04\nWald test            = 13.47  on 2 df,   p=0.001\nScore (logrank) test = 18.56  on 2 df,   p=9e-05"

# hurdle summary has expected short output

    Code
      output
    Output
      [1] "Count model coefficients (truncated poisson with log link):\n            Estimate Std. Error z value Pr(>|z|)    \n(Intercept)  0.67114    0.12246   5.481 4.24e-08 ***\nfemWomen    -0.22858    0.06522  -3.505 0.000457 ***\nmarMarried   0.09649    0.07283   1.325 0.185209    \nkid5        -0.14219    0.04845  -2.934 0.003341 ** \nphd         -0.01273    0.03130  -0.407 0.684343    \nment         0.01875    0.00228   8.222  < 2e-16 ***\nZero hurdle model coefficients (binomial with logit link):\n            Estimate Std. Error z value Pr(>|z|)    \n(Intercept)  0.23680    0.29552   0.801   0.4230    \nfemWomen    -0.25115    0.15911  -1.579   0.1144    \nmarMarried   0.32623    0.18082   1.804   0.0712 .  \nkid5        -0.28525    0.11113  -2.567   0.0103 *  \nphd          0.02222    0.07956   0.279   0.7800    \nment         0.08012    0.01302   6.155 7.52e-10 ***\n---\nSignif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 "

# zeroinfl summary has expected short output

    Code
      output
    Output
      [1] "Count model coefficients (poisson with log link):\n             Estimate Std. Error z value Pr(>|z|)    \n(Intercept)  0.564503   0.116121   4.861 1.17e-06 ***\nfemWomen    -0.226754   0.065348  -3.470 0.000521 ***\nmarMarried   0.105626   0.073167   1.444 0.148842    \nkid5        -0.153493   0.049209  -3.119 0.001813 ** \nphd          0.003053   0.028629   0.107 0.915060    \nment         0.021427   0.002171   9.869  < 2e-16 ***\n\nZero-inflation model coefficients (binomial with logit link):\n            Estimate Std. Error z value Pr(>|z|)    \n(Intercept)  -1.5807     0.3011  -5.249 1.53e-07 ***\nfemWomen      0.0564     0.3185   0.177    0.859    \nmarMarried   -0.2967     0.3575  -0.830    0.407    \nkid5          0.1804     0.2301   0.784    0.433    \n---\nSignif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 "

# polr summary has expected short output

    Code
      output
    Output
      [1] "Coefficients:\n                  Value Std. Error   t value\nInflMedium    <NUM>     <NUM> <NUM>\nInflHigh      <NUM>     <NUM> <NUM>\nTypeApartment <NUM>     <NUM> <NUM>\nTypeAtrium    <NUM>     <NUM> <NUM>\nTypeTerrace   <NUM>     <NUM> <NUM>\nContHigh      <NUM>     <NUM> <NUM>\n\nIntercepts:\n            Value   Std. Error t value\nLow|Medium  <NUM>  <NUM>    <NUM>\nMedium|High  <NUM>  <NUM>     <NUM>\n\nResidual Deviance: <NUM> "

