# Wine Quality Research Paper

## Overview
This repository contains my research paper titled **“Predicting Wine Quality From Physicochemical Properties Using Linear Regression.”**  
The project analyzes how measurable chemical properties of Portuguese *Vinho Verde* red wines influence their perceived quality ratings.

## Abstract
Using the [Wine Quality Dataset](https://archive.ics.uci.edu/dataset/186/wine+quality) from the UCI Machine Learning Repository, this study applies exploratory data analysis and linear regression modeling to determine which physicochemical factors most strongly predict wine quality.  
The analysis finds that **alcohol content** and **volatile acidity** are the most influential predictors — with alcohol showing a positive relationship and volatile acidity showing a negative one with wine quality.

## Methods
- Performed data cleaning and exploratory data analysis (EDA)  
- Conducted correlation analysis and multicollinearity checks (VIF)  
- Applied stepwise forward and backward model selection  
- Built and evaluated linear regression models with residual diagnostics  

## Key Findings
- **Alcohol content** positively correlates with wine quality  
- **Volatile acidity** negatively correlates with wine quality  
- **Sulphates** and **sulfur dioxide compounds** have minor yet notable influence  
- Model assumptions were generally satisfied based on diagnostic plots  

## Limitations
- Focused only on red variants of *Vinho Verde* wines  
- Quality ratings are subjective and based on a discrete integer scale  
- Excluded sensory variables such as aroma, tannins, and balance  

## Future Work
Future studies could:
- Expand to include diverse wine types and regions  
- Integrate sensory data (aroma, tannin, and taste profiles)  
- Explore nonlinear or ensemble modeling to capture complex interactions  
