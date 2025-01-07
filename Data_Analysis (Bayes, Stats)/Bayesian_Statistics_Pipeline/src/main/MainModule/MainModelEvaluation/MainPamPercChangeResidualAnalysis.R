source('MSSP/src/main/model-evaluation/ResidualEvaluation.R')


# Documentation -----------------------------------------------------------

# evaluate_residuals()
# plot_residuals()
# standirized_resid()
# plot_qq()
# plot_binned_residuals()

# load model object -------------------------------------------------------

load('MSSP/data/Refit-Models/PAM-Percent-Change/PAM_percChange_lasso.RDS')


# Residual Diagnostics ----------------------------------------------------

pam_perc_fit <- PAM_percChange_lasso$BestRefit

pp_check(pam_perc_fit)

evaluate_residuals(pam_perc_fit)
plot_residuals(pam_perc_fit)
standirized_resid(pam_perc_fit)
plot_qq(pam_perc_fit)
plot_binned_residuals(pam_perc_fit)
