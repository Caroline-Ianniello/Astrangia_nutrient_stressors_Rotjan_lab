<h1 style="text-align: center;"> Documentation </h1>


## Files Directory Tree:
```
./MSSP/src/main
├── MainModule
│   ├── MainBayesianModel
│   │   ├── MainPamDeltaStanLasso.R
│   │   ├── MainPamPercentStanLasso.R
│   │   └── MainRespirationStanLasso.R
│   ├── MainCoefPlot
│   │   ├── MainPamCoefPlot.R
│   │   └── MainRespirationCoefPlot.R
│   ├── MainDataProcess
│   │   ├── MainPamDataProcess.R
│   │   └── MainRespirationDataProcess.R
│   ├── MainMSEVisualization
│   │   └── MainMSEViolinPlot.R
│   ├── MainModelEvaluation
│   │   ├── MainPamDeltaResidualAnalysis.R
│   │   ├── MainPamMCMCDiagnostics.R
│   │   ├── MainPamPercChangeResidualAnalysis.R
│   │   ├── MainRespMCMCDiagnostics.R
│   │   ├── MainRespModelCheck.R
│   │   └── MainRespirationResidualAnalysis.R
│   ├── MainModelSelection
│   │   ├── MainPamDeltaModelSelect.R
│   │   ├── MainPamPercentModelSelect.R
│   │   └── MainRespModelSelect.R
│   └── MainRefitModel
│       ├── MainRefitPamDeltaModel.R
│       ├── MainRefitPamPercentChangeModel.R
│       └── MainRefitRespirationModel.R
├── Visualization
│   ├── Coef-Plot.R
│   └── MSE_violin_plot.R
├── model-evaluation
│   ├── MCMC-Diagnostics.R
│   ├── ModelSelect.r
│   └── ResidualEvaluation.R
├── modeling
│   ├── KFold-CV.R
│   ├── Refit-RStan-Lasso.R
│   └── Rstan-MixEff-Lasso.R
└── prelimEDA
    └── CoralsPamEDA.R
```

Files starts with **`Main`** are those we are going to execute. Required functions are written in external files located in different folders based on the tasks. The `Main` R scripts will import those functions, and complete the tasks.

## Main Module:

1. **`MainDataProcess`**: Files in `MainDataProcess` are used to maipulate the dataset, extract columns which will be used in the future analysis, and export the cleaned data.

2. **`MainBayesianModel`**: Files in `MainBayesianModel` construct the mixed effect regression with Laplace distribution applied, and also using cross validation to output the MSE for each `lambda` (parameter of Laplace dist.) and each fold.

3. **`MainModelSelection`**: Files in `MainModelSelection` are used to export the information of cross validation result to external markdown files.

4. **`MainMSEVisualization`**: Files in `MainMSEVisualization` are used to visualize the MSE result from cross validation as violin plots. 

5. **`MainRefitModel`**: Files in `MainRefitModel` are used to refit the mixed effect linear regression after we obtain the `lambda` with the **lowest MSE** from the output of files in `MainBayesModel`. 

6. **`MainCoefPlot`**: Files in `MainCoefPlot` are used to visualize the **posterior mean** and the **95% quantile interval** of the estimation from the mixed effect linear regression estimated in Bayesian approach.

7. **`MainModelEvaluation`**: 
   
   -  `ResidualAnalysis`: Files with `ResidualAnalysis` suffix mean to check the residuals pattern of the model.
   -  `MCMCDiagnostics`: Files with `MCMCDiagnostics` suffix mean to diagnose the MCMC sampling, checking if the sampling converge or not.
   -  `ModelCheck`: Files with `ModelCheck` suffix mean to compare the result between our estimation and the results from a frequantist approach. If both of them are close enough, then we can state that our estimation is valid.