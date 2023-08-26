# RECEIVER OPERATING CHARACTERISTIC CURVE ANALYSIS

## **LOAD LIBRARIES**

```{r}
library(tidyverse)
library(tidyquant)
library(pROC)
library(gtsummary)
library(flextable)
```

## **ATTACH DATA**

```{r}
df <- read.csv(file.choose())
attach(df)
View(df)
```

## **DESCRIPTIVE ANALYSIS**

```{r}
table1 <- tbl_summary(df, include = c("AS", "ASDAS.CRP", "ASDAS.ESR"))
table1
```

## **AUC**

```{r}
crp <- roc(AS ~ ASDAS.CRP)
crp; ci(AS ~ ASDAS.CRP)
esr <- roc(AS ~ ASDAS.ESR)
esr; ci(AS ~ ASDAS.ESR)
```

## SENSITIVITY, SPECIFICITY, PPV, NPV

```{r}
crpc <- coords(crp, x="best", best.method="youden", ret=c("threshold", "sensitivity", "specificity", "npv", "ppv"))
crpc; ci.coords(crp, x="best", best.method="youden", ret=c("threshold", "sensitivity", "specificity", "npv", "ppv"), conf.level=0.95)

esrc <- coords(esr, x="best", best.method="youden", ret=c("threshold", "sensitivity", "specificity", "npv", "ppv"))
esrc; ci.coords(esr, x="best", best.method="youden", ret=c("threshold", "sensitivity", "specificity", "npv", "ppv"), conf.level=0.95)
```

## ROC COMPARISONS

```{r}
roc.test(crp, esr, method="delong")
roc.test(cult, cbn, method="specificity", specificity=0.85)
roc.test(cult, cbn, method="sensitivity", sensitivity=0.85)
```

## CREATING DATA TO PLOT CONFIDENCE BANDS

```{r}
ciobj <- ci.se(crp, specificities=seq(0, 1, l=25))
dat.ci <- data.frame(x = as.numeric(rownames(ciobj)),
                     lower = ciobj[, 1],
                     upper = ciobj[, 3])
```

## PLOTTING ROC CURVES

```{r}
plot <- ggroc(list(crp, esr), legacy.axes=T, linewidth=1) + theme_bw() + scale_color_wsj() + labs(color="Scores") + geom_abline(slope=1, intercept=0, linetype=3, linewidth=0.75) + coord_equal()
plot
```
