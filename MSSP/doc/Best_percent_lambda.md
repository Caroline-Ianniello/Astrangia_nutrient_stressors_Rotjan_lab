# Best Lambda

* Lambda: 0.0891832646448165
* Fold: 3


# Model Summary

```


Model Info:
 function:     stan_glmer
 family:       gaussian [identity]
 formula:      pam_percent_change ~ feed + dose_level + temp + symbiont + dose_level_x_temp + 
	   dose_level_x_feed + dose_level_x_symbiont + temp_x_feed + 
	   temp_x_symbiont + feed_x_symbiont + dose_level_x_temp_x_feed + 
	   dose_level_x_temp_x_symbiont + dose_level_x_feed_x_symbiont + 
	   temp_x_feed_x_symbiont + dose_level_x_temp_x_feed_x_symbiont + 
	   (1 | col_num_3)
 algorithm:    sampling
 sample:       4000 (posterior sample size)
 priors:       see help('prior_summary')
 observations: 450
 groups:       col_num_3 (88)

Estimates:
                                                                      mean   sd   10%   50%   90%
(Intercept)                                                          0.1    0.7 -0.8   0.1   1.0 
feedStarved                                                          0.0    0.1 -0.1   0.0   0.1 
dose_levelHigh                                                       0.0    0.1 -0.2   0.0   0.1 
dose_levelLow                                                        0.0    0.1 -0.1   0.0   0.1 
dose_levelMedium                                                     0.0    0.1 -0.2   0.0   0.1 
temp                                                                 0.0    0.0  0.0   0.0   0.0 
symbiontSymbiotic                                                    0.0    0.1 -0.1   0.0   0.1 
dose_level_x_tempcontrol-0-x-30                                      0.1    0.2 -0.1   0.1   0.3 
dose_level_x_tempHigh-x-20                                           0.0    0.1 -0.1   0.0   0.1 
dose_level_x_tempLow-x-20                                            0.0    0.1 -0.1   0.0   0.2 
dose_level_x_feedcontrol-0-x-Starved                                 0.0    0.1 -0.1   0.0   0.2 
dose_level_x_feedHigh-x-Fed                                          0.0    0.1 -0.1   0.0   0.1 
dose_level_x_feedLow-x-Fed                                           0.0    0.1 -0.2   0.0   0.1 
dose_level_x_symbiontcontrol-0-x-Symbiotic                           0.1    0.1  0.0   0.1   0.3 
dose_level_x_symbiontHigh-x-Aposymbiotic                             0.0    0.1 -0.1   0.0   0.1 
dose_level_x_symbiontLow-x-Aposymbiotic                              0.0    0.1 -0.1   0.0   0.2 
temp_x_feed20-x-Starved                                              0.0    0.1 -0.1   0.0   0.2 
temp_x_symbiont20-x-Symbiotic                                       -0.1    0.2 -0.3  -0.1   0.0 
feed_x_symbiontFed-x-Symbiotic                                       0.0    0.1 -0.1   0.0   0.2 
dose_level_x_temp_x_feedcontrol-0-x-20-x-Starved                     0.0    0.1 -0.1   0.0   0.1 
dose_level_x_temp_x_feedHigh-x-20-x-Fed                              0.0    0.1 -0.1   0.0   0.1 
dose_level_x_temp_x_feedLow-x-20-x-Fed                               0.0    0.1 -0.1   0.0   0.1 
dose_level_x_temp_x_symbiontcontrol-0-x-20-x-Symbiotic               0.0    0.1 -0.2   0.0   0.1 
dose_level_x_temp_x_symbiontHigh-x-20-x-Aposymbiotic                 0.0    0.1 -0.1   0.0   0.1 
dose_level_x_temp_x_symbiontLow-x-20-x-Aposymbiotic                  0.1    0.2 -0.1   0.1   0.3 
dose_level_x_feed_x_symbiontcontrol-0-x-Fed-x-Symbiotic              0.1    0.1 -0.1   0.0   0.2 
dose_level_x_feed_x_symbiontHigh-x-Fed-x-Aposymbiotic                0.0    0.1 -0.1   0.0   0.1 
dose_level_x_feed_x_symbiontLow-x-Fed-x-Aposymbiotic                 0.0    0.1 -0.2   0.0   0.1 
temp_x_feed_x_symbiont20-x-Fed-x-Symbiotic                          -0.1    0.1 -0.2   0.0   0.1 
dose_level_x_temp_x_feed_x_symbiontcontrol-0-x-20-x-Fed-x-Symbiotic  0.0    0.1 -0.2   0.0   0.1 
dose_level_x_temp_x_feed_x_symbiontHigh-x-20-x-Fed-x-Aposymbiotic    0.0    0.1 -0.1   0.0   0.1 
dose_level_x_temp_x_feed_x_symbiontLow-x-20-x-Fed-x-Aposymbiotic     0.0    0.1 -0.1   0.0   0.1 
b[(Intercept) col_num_3:142]                                        -0.3    0.7 -1.2  -0.3   0.6 
b[(Intercept) col_num_3:145]                                         0.1    1.1 -1.4   0.1   1.5 
b[(Intercept) col_num_3:147]                                        -0.1    0.9 -1.2  -0.1   1.0 
b[(Intercept) col_num_3:148]                                         0.0    1.2 -1.5   0.0   1.5 
b[(Intercept) col_num_3:149]                                        -0.3    0.9 -1.5  -0.3   0.8 
b[(Intercept) col_num_3:150]                                         0.7    0.6 -0.1   0.7   1.4 
b[(Intercept) col_num_3:151]                                        -0.3    0.8 -1.2  -0.3   0.8 
b[(Intercept) col_num_3:152]                                        -0.2    0.9 -1.4  -0.2   0.9 
b[(Intercept) col_num_3:153]                                        -0.3    0.7 -1.2  -0.3   0.6 
b[(Intercept) col_num_3:154]                                        -0.1    1.0 -1.4  -0.1   1.1 
b[(Intercept) col_num_3:155]                                        -0.2    1.0 -1.4  -0.2   1.1 
b[(Intercept) col_num_3:157]                                        -0.2    0.8 -1.2  -0.2   0.8 
b[(Intercept) col_num_3:159]                                        -0.2    0.8 -1.3  -0.2   0.9 
b[(Intercept) col_num_3:160]                                        -0.1    0.9 -1.2  -0.1   1.0 
b[(Intercept) col_num_3:161]                                         0.0    0.9 -1.2   0.0   1.1 
b[(Intercept) col_num_3:162]                                         0.3    0.9 -0.8   0.3   1.4 
b[(Intercept) col_num_3:163]                                         0.0    0.8 -1.1   0.0   1.1 
b[(Intercept) col_num_3:164]                                        -0.4    0.8 -1.4  -0.4   0.6 
b[(Intercept) col_num_3:165]                                        -0.4    1.0 -1.6  -0.4   0.8 
b[(Intercept) col_num_3:166]                                         0.3    0.7 -0.6   0.3   1.1 
b[(Intercept) col_num_3:167]                                        -0.3    0.9 -1.5  -0.3   0.9 
b[(Intercept) col_num_3:168]                                         0.2    0.6 -0.6   0.2   1.0 
b[(Intercept) col_num_3:169]                                         0.2    0.7 -0.7   0.2   1.2 
b[(Intercept) col_num_3:170]                                        -0.5    0.7 -1.4  -0.5   0.5 
b[(Intercept) col_num_3:171]                                         0.4    0.6 -0.3   0.4   1.1 
b[(Intercept) col_num_3:172]                                        -0.2    0.8 -1.3  -0.2   0.9 
b[(Intercept) col_num_3:173]                                         0.0    1.0 -1.3  -0.1   1.2 
b[(Intercept) col_num_3:174]                                        -0.4    0.7 -1.3  -0.4   0.6 
b[(Intercept) col_num_3:175]                                        -0.5    0.9 -1.7  -0.6   0.6 
b[(Intercept) col_num_3:177]                                         0.2    1.2 -1.3   0.2   1.7 
b[(Intercept) col_num_3:180]                                         0.0    1.2 -1.5   0.0   1.4 
b[(Intercept) col_num_3:183]                                        -0.1    0.8 -1.1  -0.1   0.9 
b[(Intercept) col_num_3:184]                                         0.0    0.7 -0.8   0.0   0.9 
b[(Intercept) col_num_3:185]                                        -0.4    0.8 -1.4  -0.4   0.6 
b[(Intercept) col_num_3:186]                                        -0.3    0.7 -1.2  -0.3   0.6 
b[(Intercept) col_num_3:187]                                         0.5    1.0 -0.7   0.5   1.7 
b[(Intercept) col_num_3:188]                                        -0.3    1.0 -1.6  -0.3   0.9 
b[(Intercept) col_num_3:189]                                        -0.2    1.2 -1.7  -0.2   1.3 
b[(Intercept) col_num_3:191]                                        -0.2    1.2 -1.6  -0.2   1.3 
b[(Intercept) col_num_3:192]                                        -0.5    0.9 -1.7  -0.4   0.7 
b[(Intercept) col_num_3:193]                                        -0.3    0.8 -1.4  -0.3   0.7 
b[(Intercept) col_num_3:194]                                        -0.2    1.0 -1.4  -0.2   1.1 
b[(Intercept) col_num_3:195]                                        -0.2    1.2 -1.7  -0.2   1.3 
b[(Intercept) col_num_3:196]                                        -0.3    1.0 -1.6  -0.3   1.0 
b[(Intercept) col_num_3:197]                                        -0.2    1.2 -1.7  -0.2   1.3 
b[(Intercept) col_num_3:198]                                        -0.1    1.1 -1.6  -0.1   1.3 
b[(Intercept) col_num_3:199]                                         0.2    0.9 -0.9   0.2   1.3 
b[(Intercept) col_num_3:201]                                        -0.2    1.0 -1.4  -0.2   1.0 
b[(Intercept) col_num_3:202]                                         0.0    0.9 -1.2   0.0   1.2 
b[(Intercept) col_num_3:203]                                         0.0    1.1 -1.4   0.0   1.4 
b[(Intercept) col_num_3:204]                                         0.0    1.1 -1.4   0.0   1.4 
b[(Intercept) col_num_3:205]                                        -0.1    0.9 -1.2  -0.1   1.0 
b[(Intercept) col_num_3:206]                                        -0.4    0.7 -1.3  -0.4   0.4 
b[(Intercept) col_num_3:207]                                        -0.6    0.8 -1.6  -0.6   0.4 
b[(Intercept) col_num_3:208]                                         1.4    0.7  0.5   1.4   2.3 
b[(Intercept) col_num_3:209]                                        -0.3    0.9 -1.4  -0.3   0.9 
b[(Intercept) col_num_3:210]                                        -0.1    1.1 -1.5  -0.1   1.4 
b[(Intercept) col_num_3:211]                                         0.1    1.1 -1.3   0.1   1.4 
b[(Intercept) col_num_3:212]                                        -0.2    1.0 -1.4  -0.2   1.1 
b[(Intercept) col_num_3:218]                                        -0.3    1.0 -1.6  -0.2   1.1 
b[(Intercept) col_num_3:223]                                        -0.4    0.7 -1.3  -0.4   0.5 
b[(Intercept) col_num_3:224]                                         0.0    1.1 -1.5   0.0   1.4 
b[(Intercept) col_num_3:225]                                        -0.2    0.8 -1.2  -0.2   0.9 
b[(Intercept) col_num_3:226]                                        -0.4    0.7 -1.3  -0.4   0.5 
b[(Intercept) col_num_3:227]                                        -0.3    0.9 -1.4  -0.3   0.8 
b[(Intercept) col_num_3:228]                                         0.1    0.9 -1.1   0.1   1.2 
b[(Intercept) col_num_3:229]                                        -0.2    1.2 -1.7  -0.2   1.4 
b[(Intercept) col_num_3:230]                                         0.0    0.9 -1.1   0.0   1.1 
b[(Intercept) col_num_3:231]                                         0.1    1.0 -1.2   0.1   1.4 
b[(Intercept) col_num_3:232]                                        -0.1    1.0 -1.4  -0.1   1.2 
b[(Intercept) col_num_3:235]                                        -0.1    1.1 -1.6  -0.1   1.3 
b[(Intercept) col_num_3:237]                                        -0.3    0.5 -0.9  -0.3   0.4 
b[(Intercept) col_num_3:238]                                         0.0    0.6 -0.8   0.0   0.8 
b[(Intercept) col_num_3:239]                                        -0.5    0.7 -1.4  -0.5   0.3 
b[(Intercept) col_num_3:240]                                        -0.5    0.8 -1.5  -0.4   0.6 
b[(Intercept) col_num_3:241]                                        -0.6    0.7 -1.5  -0.5   0.4 
b[(Intercept) col_num_3:242]                                        -0.2    0.8 -1.2  -0.2   0.8 
b[(Intercept) col_num_3:243]                                        -0.6    0.9 -1.7  -0.5   0.6 
b[(Intercept) col_num_3:244]                                         0.0    0.8 -1.0   0.0   0.9 
b[(Intercept) col_num_3:245]                                         0.7    1.0 -0.6   0.6   1.9 
b[(Intercept) col_num_3:246]                                         4.4    1.1  3.0   4.4   5.8 
b[(Intercept) col_num_3:247]                                        -0.5    1.0 -1.7  -0.5   0.7 
b[(Intercept) col_num_3:249]                                        -0.4    0.9 -1.5  -0.4   0.7 
b[(Intercept) col_num_3:250]                                        -0.3    1.2 -1.8  -0.2   1.2 
b[(Intercept) col_num_3:251]                                        -0.2    0.8 -1.2  -0.2   0.7 
b[(Intercept) col_num_3:252]                                        -0.2    0.8 -1.2  -0.2   0.7 
b[(Intercept) col_num_3:256]                                         6.7    1.1  5.3   6.7   8.1 
b[(Intercept) col_num_3:257]                                        -0.4    1.0 -1.6  -0.3   0.9 
sigma                                                                2.5    0.1  2.3   2.5   2.6 
Sigma[col_num_3:(Intercept),(Intercept)]                             1.7    0.5  1.1   1.7   2.4 

Fit Diagnostics:
           mean   sd   10%   50%   90%
mean_PPD 0.4    0.2  0.2   0.4   0.6  

The mean_ppd is the sample average posterior predictive distribution of the outcome variable (for details see help('summary.stanreg')).

MCMC diagnostics
                                                                    mcse Rhat n_eff
(Intercept)                                                         0.0  1.0   4486
feedStarved                                                         0.0  1.0   5989
dose_levelHigh                                                      0.0  1.0   5265
dose_levelLow                                                       0.0  1.0   5060
dose_levelMedium                                                    0.0  1.0   5970
temp                                                                0.0  1.0   4621
symbiontSymbiotic                                                   0.0  1.0   6348
dose_level_x_tempcontrol-0-x-30                                     0.0  1.0   6323
dose_level_x_tempHigh-x-20                                          0.0  1.0   6295
dose_level_x_tempLow-x-20                                           0.0  1.0   6091
dose_level_x_feedcontrol-0-x-Starved                                0.0  1.0   6200
dose_level_x_feedHigh-x-Fed                                         0.0  1.0   5461
dose_level_x_feedLow-x-Fed                                          0.0  1.0   6512
dose_level_x_symbiontcontrol-0-x-Symbiotic                          0.0  1.0   6709
dose_level_x_symbiontHigh-x-Aposymbiotic                            0.0  1.0   6131
dose_level_x_symbiontLow-x-Aposymbiotic                             0.0  1.0   5899
temp_x_feed20-x-Starved                                             0.0  1.0   6034
temp_x_symbiont20-x-Symbiotic                                       0.0  1.0   5614
feed_x_symbiontFed-x-Symbiotic                                      0.0  1.0   6123
dose_level_x_temp_x_feedcontrol-0-x-20-x-Starved                    0.0  1.0   5796
dose_level_x_temp_x_feedHigh-x-20-x-Fed                             0.0  1.0   6131
dose_level_x_temp_x_feedLow-x-20-x-Fed                              0.0  1.0   5698
dose_level_x_temp_x_symbiontcontrol-0-x-20-x-Symbiotic              0.0  1.0   5961
dose_level_x_temp_x_symbiontHigh-x-20-x-Aposymbiotic                0.0  1.0   6052
dose_level_x_temp_x_symbiontLow-x-20-x-Aposymbiotic                 0.0  1.0   4251
dose_level_x_feed_x_symbiontcontrol-0-x-Fed-x-Symbiotic             0.0  1.0   5533
dose_level_x_feed_x_symbiontHigh-x-Fed-x-Aposymbiotic               0.0  1.0   5937
dose_level_x_feed_x_symbiontLow-x-Fed-x-Aposymbiotic                0.0  1.0   5913
temp_x_feed_x_symbiont20-x-Fed-x-Symbiotic                          0.0  1.0   6171
dose_level_x_temp_x_feed_x_symbiontcontrol-0-x-20-x-Fed-x-Symbiotic 0.0  1.0   5426
dose_level_x_temp_x_feed_x_symbiontHigh-x-20-x-Fed-x-Aposymbiotic   0.0  1.0   6738
dose_level_x_temp_x_feed_x_symbiontLow-x-20-x-Fed-x-Aposymbiotic    0.0  1.0   6476
b[(Intercept) col_num_3:142]                                        0.0  1.0   7992
b[(Intercept) col_num_3:145]                                        0.0  1.0   9634
b[(Intercept) col_num_3:147]                                        0.0  1.0   9773
b[(Intercept) col_num_3:148]                                        0.0  1.0   9930
b[(Intercept) col_num_3:149]                                        0.0  1.0   9517
b[(Intercept) col_num_3:150]                                        0.0  1.0   8609
b[(Intercept) col_num_3:151]                                        0.0  1.0  10615
b[(Intercept) col_num_3:152]                                        0.0  1.0   8871
b[(Intercept) col_num_3:153]                                        0.0  1.0   8570
b[(Intercept) col_num_3:154]                                        0.0  1.0   9538
b[(Intercept) col_num_3:155]                                        0.0  1.0   9396
b[(Intercept) col_num_3:157]                                        0.0  1.0   9557
b[(Intercept) col_num_3:159]                                        0.0  1.0   7804
b[(Intercept) col_num_3:160]                                        0.0  1.0   9882
b[(Intercept) col_num_3:161]                                        0.0  1.0  11038
b[(Intercept) col_num_3:162]                                        0.0  1.0  10202
b[(Intercept) col_num_3:163]                                        0.0  1.0  10330
b[(Intercept) col_num_3:164]                                        0.0  1.0   7845
b[(Intercept) col_num_3:165]                                        0.0  1.0   8883
b[(Intercept) col_num_3:166]                                        0.0  1.0   7924
b[(Intercept) col_num_3:167]                                        0.0  1.0  10072
b[(Intercept) col_num_3:168]                                        0.0  1.0   8281
b[(Intercept) col_num_3:169]                                        0.0  1.0   8168
b[(Intercept) col_num_3:170]                                        0.0  1.0   9951
b[(Intercept) col_num_3:171]                                        0.0  1.0   8253
b[(Intercept) col_num_3:172]                                        0.0  1.0   8444
b[(Intercept) col_num_3:173]                                        0.0  1.0  11174
b[(Intercept) col_num_3:174]                                        0.0  1.0  10754
b[(Intercept) col_num_3:175]                                        0.0  1.0  11261
b[(Intercept) col_num_3:177]                                        0.0  1.0   8467
b[(Intercept) col_num_3:180]                                        0.0  1.0  10602
b[(Intercept) col_num_3:183]                                        0.0  1.0   9475
b[(Intercept) col_num_3:184]                                        0.0  1.0   9342
b[(Intercept) col_num_3:185]                                        0.0  1.0   9780
b[(Intercept) col_num_3:186]                                        0.0  1.0   8250
b[(Intercept) col_num_3:187]                                        0.0  1.0   8567
b[(Intercept) col_num_3:188]                                        0.0  1.0  10734
b[(Intercept) col_num_3:189]                                        0.0  1.0  10853
b[(Intercept) col_num_3:191]                                        0.0  1.0   9382
b[(Intercept) col_num_3:192]                                        0.0  1.0   9970
b[(Intercept) col_num_3:193]                                        0.0  1.0   9714
b[(Intercept) col_num_3:194]                                        0.0  1.0  11725
b[(Intercept) col_num_3:195]                                        0.0  1.0   9673
b[(Intercept) col_num_3:196]                                        0.0  1.0  10987
b[(Intercept) col_num_3:197]                                        0.0  1.0  10997
b[(Intercept) col_num_3:198]                                        0.0  1.0   9288
b[(Intercept) col_num_3:199]                                        0.0  1.0   8114
b[(Intercept) col_num_3:201]                                        0.0  1.0  10092
b[(Intercept) col_num_3:202]                                        0.0  1.0  10096
b[(Intercept) col_num_3:203]                                        0.0  1.0  11713
b[(Intercept) col_num_3:204]                                        0.0  1.0  10570
b[(Intercept) col_num_3:205]                                        0.0  1.0   7812
b[(Intercept) col_num_3:206]                                        0.0  1.0   8873
b[(Intercept) col_num_3:207]                                        0.0  1.0   8860
b[(Intercept) col_num_3:208]                                        0.0  1.0   7600
b[(Intercept) col_num_3:209]                                        0.0  1.0   9929
b[(Intercept) col_num_3:210]                                        0.0  1.0  10256
b[(Intercept) col_num_3:211]                                        0.0  1.0   8999
b[(Intercept) col_num_3:212]                                        0.0  1.0   9086
b[(Intercept) col_num_3:218]                                        0.0  1.0  11737
b[(Intercept) col_num_3:223]                                        0.0  1.0   9752
b[(Intercept) col_num_3:224]                                        0.0  1.0   8524
b[(Intercept) col_num_3:225]                                        0.0  1.0   9199
b[(Intercept) col_num_3:226]                                        0.0  1.0   7420
b[(Intercept) col_num_3:227]                                        0.0  1.0  10952
b[(Intercept) col_num_3:228]                                        0.0  1.0   9963
b[(Intercept) col_num_3:229]                                        0.0  1.0  10047
b[(Intercept) col_num_3:230]                                        0.0  1.0  10456
b[(Intercept) col_num_3:231]                                        0.0  1.0   9621
b[(Intercept) col_num_3:232]                                        0.0  1.0   9291
b[(Intercept) col_num_3:235]                                        0.0  1.0  11011
b[(Intercept) col_num_3:237]                                        0.0  1.0   7135
b[(Intercept) col_num_3:238]                                        0.0  1.0   7827
b[(Intercept) col_num_3:239]                                        0.0  1.0   8281
b[(Intercept) col_num_3:240]                                        0.0  1.0   9493
b[(Intercept) col_num_3:241]                                        0.0  1.0   9431
b[(Intercept) col_num_3:242]                                        0.0  1.0   8802
b[(Intercept) col_num_3:243]                                        0.0  1.0   9917
b[(Intercept) col_num_3:244]                                        0.0  1.0   9078
b[(Intercept) col_num_3:245]                                        0.0  1.0   8457
b[(Intercept) col_num_3:246]                                        0.0  1.0   3606
b[(Intercept) col_num_3:247]                                        0.0  1.0  10207
b[(Intercept) col_num_3:249]                                        0.0  1.0  10227
b[(Intercept) col_num_3:250]                                        0.0  1.0  11263
b[(Intercept) col_num_3:251]                                        0.0  1.0   9663
b[(Intercept) col_num_3:252]                                        0.0  1.0   8474
b[(Intercept) col_num_3:256]                                        0.0  1.0   2680
b[(Intercept) col_num_3:257]                                        0.0  1.0   8537
sigma                                                               0.0  1.0   4944
Sigma[col_num_3:(Intercept),(Intercept)]                            0.0  1.0   1761
mean_PPD                                                            0.0  1.0   4017
log-posterior                                                       0.4  1.0   1017

For each parameter, mcse is Monte Carlo standard error, n_eff is a crude measure of effective sample size, and Rhat is the potential scale reduction factor on split chains (at convergence Rhat=1).
```


# Model Coefficients

```

$col_num_3
    (Intercept)  feedStarved dose_levelHigh dose_levelLow dose_levelMedium        temp symbiontSymbiotic
142 -0.17521278 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
145  0.19103960 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
147  0.04107384 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
148  0.11051220 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
149 -0.19724137 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
150  0.77235712 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
151 -0.15364446 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
152 -0.11777360 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
153 -0.17573131 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
154 -0.02954102 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
155 -0.06870992 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
157 -0.08712334 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
159 -0.06699481 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
160  0.04454007 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
161  0.09960573 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
162  0.46323538 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
163  0.11153631 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
164 -0.24915248 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
165 -0.29857268 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
166  0.37804519 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
167 -0.16751753 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
168  0.30366866 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
169  0.31330705 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
170 -0.35602487 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
171  0.50353270 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
172 -0.06293952 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
173  0.05780513 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
174 -0.27146527 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
175 -0.43595441 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
177  0.27541302 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
180  0.10713120 -0.003321636    -0.01140373  0.0003869486      -0.02546386 0.009818742      -0.002386448
    dose_level_x_tempcontrol-0-x-30 dose_level_x_tempHigh-x-20 dose_level_x_tempLow-x-20 dose_level_x_feedcontrol-0-x-Starved
142                       0.0699626                -0.00477343                 0.0248685                           0.01501802
145                       0.0699626                -0.00477343                 0.0248685                           0.01501802
147                       0.0699626                -0.00477343                 0.0248685                           0.01501802
148                       0.0699626                -0.00477343                 0.0248685                           0.01501802
149                       0.0699626                -0.00477343                 0.0248685                           0.01501802
150                       0.0699626                -0.00477343                 0.0248685                           0.01501802
151                       0.0699626                -0.00477343                 0.0248685                           0.01501802
152                       0.0699626                -0.00477343                 0.0248685                           0.01501802
153                       0.0699626                -0.00477343                 0.0248685                           0.01501802
154                       0.0699626                -0.00477343                 0.0248685                           0.01501802
155                       0.0699626                -0.00477343                 0.0248685                           0.01501802
157                       0.0699626                -0.00477343                 0.0248685                           0.01501802
159                       0.0699626                -0.00477343                 0.0248685                           0.01501802
160                       0.0699626                -0.00477343                 0.0248685                           0.01501802
161                       0.0699626                -0.00477343                 0.0248685                           0.01501802
162                       0.0699626                -0.00477343                 0.0248685                           0.01501802
163                       0.0699626                -0.00477343                 0.0248685                           0.01501802
164                       0.0699626                -0.00477343                 0.0248685                           0.01501802
165                       0.0699626                -0.00477343                 0.0248685                           0.01501802
166                       0.0699626                -0.00477343                 0.0248685                           0.01501802
167                       0.0699626                -0.00477343                 0.0248685                           0.01501802
168                       0.0699626                -0.00477343                 0.0248685                           0.01501802
169                       0.0699626                -0.00477343                 0.0248685                           0.01501802
170                       0.0699626                -0.00477343                 0.0248685                           0.01501802
171                       0.0699626                -0.00477343                 0.0248685                           0.01501802
172                       0.0699626                -0.00477343                 0.0248685                           0.01501802
173                       0.0699626                -0.00477343                 0.0248685                           0.01501802
174                       0.0699626                -0.00477343                 0.0248685                           0.01501802
175                       0.0699626                -0.00477343                 0.0248685                           0.01501802
177                       0.0699626                -0.00477343                 0.0248685                           0.01501802
180                       0.0699626                -0.00477343                 0.0248685                           0.01501802
    dose_level_x_feedHigh-x-Fed dose_level_x_feedLow-x-Fed dose_level_x_symbiontcontrol-0-x-Symbiotic
142                 0.005403389                -0.01775329                                 0.07137287
145                 0.005403389                -0.01775329                                 0.07137287
147                 0.005403389                -0.01775329                                 0.07137287
148                 0.005403389                -0.01775329                                 0.07137287
149                 0.005403389                -0.01775329                                 0.07137287
150                 0.005403389                -0.01775329                                 0.07137287
151                 0.005403389                -0.01775329                                 0.07137287
152                 0.005403389                -0.01775329                                 0.07137287
153                 0.005403389                -0.01775329                                 0.07137287
154                 0.005403389                -0.01775329                                 0.07137287
155                 0.005403389                -0.01775329                                 0.07137287
157                 0.005403389                -0.01775329                                 0.07137287
159                 0.005403389                -0.01775329                                 0.07137287
160                 0.005403389                -0.01775329                                 0.07137287
161                 0.005403389                -0.01775329                                 0.07137287
162                 0.005403389                -0.01775329                                 0.07137287
163                 0.005403389                -0.01775329                                 0.07137287
164                 0.005403389                -0.01775329                                 0.07137287
165                 0.005403389                -0.01775329                                 0.07137287
166                 0.005403389                -0.01775329                                 0.07137287
167                 0.005403389                -0.01775329                                 0.07137287
168                 0.005403389                -0.01775329                                 0.07137287
169                 0.005403389                -0.01775329                                 0.07137287
170                 0.005403389                -0.01775329                                 0.07137287
171                 0.005403389                -0.01775329                                 0.07137287
172                 0.005403389                -0.01775329                                 0.07137287
173                 0.005403389                -0.01775329                                 0.07137287
174                 0.005403389                -0.01775329                                 0.07137287
175                 0.005403389                -0.01775329                                 0.07137287
177                 0.005403389                -0.01775329                                 0.07137287
180                 0.005403389                -0.01775329                                 0.07137287
    dose_level_x_symbiontHigh-x-Aposymbiotic dose_level_x_symbiontLow-x-Aposymbiotic temp_x_feed20-x-Starved
142                             -0.004823247                              0.02793428              0.01875303
145                             -0.004823247                              0.02793428              0.01875303
147                             -0.004823247                              0.02793428              0.01875303
148                             -0.004823247                              0.02793428              0.01875303
149                             -0.004823247                              0.02793428              0.01875303
150                             -0.004823247                              0.02793428              0.01875303
151                             -0.004823247                              0.02793428              0.01875303
152                             -0.004823247                              0.02793428              0.01875303
153                             -0.004823247                              0.02793428              0.01875303
154                             -0.004823247                              0.02793428              0.01875303
155                             -0.004823247                              0.02793428              0.01875303
157                             -0.004823247                              0.02793428              0.01875303
159                             -0.004823247                              0.02793428              0.01875303
160                             -0.004823247                              0.02793428              0.01875303
161                             -0.004823247                              0.02793428              0.01875303
162                             -0.004823247                              0.02793428              0.01875303
163                             -0.004823247                              0.02793428              0.01875303
164                             -0.004823247                              0.02793428              0.01875303
165                             -0.004823247                              0.02793428              0.01875303
166                             -0.004823247                              0.02793428              0.01875303
167                             -0.004823247                              0.02793428              0.01875303
168                             -0.004823247                              0.02793428              0.01875303
169                             -0.004823247                              0.02793428              0.01875303
170                             -0.004823247                              0.02793428              0.01875303
171                             -0.004823247                              0.02793428              0.01875303
172                             -0.004823247                              0.02793428              0.01875303
173                             -0.004823247                              0.02793428              0.01875303
174                             -0.004823247                              0.02793428              0.01875303
175                             -0.004823247                              0.02793428              0.01875303
177                             -0.004823247                              0.02793428              0.01875303
180                             -0.004823247                              0.02793428              0.01875303
    temp_x_symbiont20-x-Symbiotic feed_x_symbiontFed-x-Symbiotic dose_level_x_temp_x_feedcontrol-0-x-20-x-Starved
142                   -0.07937809                     0.02111536                                     -0.002037329
145                   -0.07937809                     0.02111536                                     -0.002037329
147                   -0.07937809                     0.02111536                                     -0.002037329
148                   -0.07937809                     0.02111536                                     -0.002037329
149                   -0.07937809                     0.02111536                                     -0.002037329
150                   -0.07937809                     0.02111536                                     -0.002037329
151                   -0.07937809                     0.02111536                                     -0.002037329
152                   -0.07937809                     0.02111536                                     -0.002037329
153                   -0.07937809                     0.02111536                                     -0.002037329
154                   -0.07937809                     0.02111536                                     -0.002037329
155                   -0.07937809                     0.02111536                                     -0.002037329
157                   -0.07937809                     0.02111536                                     -0.002037329
159                   -0.07937809                     0.02111536                                     -0.002037329
160                   -0.07937809                     0.02111536                                     -0.002037329
161                   -0.07937809                     0.02111536                                     -0.002037329
162                   -0.07937809                     0.02111536                                     -0.002037329
163                   -0.07937809                     0.02111536                                     -0.002037329
164                   -0.07937809                     0.02111536                                     -0.002037329
165                   -0.07937809                     0.02111536                                     -0.002037329
166                   -0.07937809                     0.02111536                                     -0.002037329
167                   -0.07937809                     0.02111536                                     -0.002037329
168                   -0.07937809                     0.02111536                                     -0.002037329
169                   -0.07937809                     0.02111536                                     -0.002037329
170                   -0.07937809                     0.02111536                                     -0.002037329
171                   -0.07937809                     0.02111536                                     -0.002037329
172                   -0.07937809                     0.02111536                                     -0.002037329
173                   -0.07937809                     0.02111536                                     -0.002037329
174                   -0.07937809                     0.02111536                                     -0.002037329
175                   -0.07937809                     0.02111536                                     -0.002037329
177                   -0.07937809                     0.02111536                                     -0.002037329
180                   -0.07937809                     0.02111536                                     -0.002037329
    dose_level_x_temp_x_feedHigh-x-20-x-Fed dose_level_x_temp_x_feedLow-x-20-x-Fed
142                              0.00266788                           0.0003497894
145                              0.00266788                           0.0003497894
147                              0.00266788                           0.0003497894
148                              0.00266788                           0.0003497894
149                              0.00266788                           0.0003497894
150                              0.00266788                           0.0003497894
151                              0.00266788                           0.0003497894
152                              0.00266788                           0.0003497894
153                              0.00266788                           0.0003497894
154                              0.00266788                           0.0003497894
155                              0.00266788                           0.0003497894
157                              0.00266788                           0.0003497894
159                              0.00266788                           0.0003497894
160                              0.00266788                           0.0003497894
161                              0.00266788                           0.0003497894
162                              0.00266788                           0.0003497894
163                              0.00266788                           0.0003497894
164                              0.00266788                           0.0003497894
165                              0.00266788                           0.0003497894
166                              0.00266788                           0.0003497894
167                              0.00266788                           0.0003497894
168                              0.00266788                           0.0003497894
169                              0.00266788                           0.0003497894
170                              0.00266788                           0.0003497894
171                              0.00266788                           0.0003497894
172                              0.00266788                           0.0003497894
173                              0.00266788                           0.0003497894
174                              0.00266788                           0.0003497894
175                              0.00266788                           0.0003497894
177                              0.00266788                           0.0003497894
180                              0.00266788                           0.0003497894
    dose_level_x_temp_x_symbiontcontrol-0-x-20-x-Symbiotic dose_level_x_temp_x_symbiontHigh-x-20-x-Aposymbiotic
142                                            -0.01293106                                         0.0004649001
145                                            -0.01293106                                         0.0004649001
147                                            -0.01293106                                         0.0004649001
148                                            -0.01293106                                         0.0004649001
149                                            -0.01293106                                         0.0004649001
150                                            -0.01293106                                         0.0004649001
151                                            -0.01293106                                         0.0004649001
152                                            -0.01293106                                         0.0004649001
153                                            -0.01293106                                         0.0004649001
154                                            -0.01293106                                         0.0004649001
155                                            -0.01293106                                         0.0004649001
157                                            -0.01293106                                         0.0004649001
159                                            -0.01293106                                         0.0004649001
160                                            -0.01293106                                         0.0004649001
161                                            -0.01293106                                         0.0004649001
162                                            -0.01293106                                         0.0004649001
163                                            -0.01293106                                         0.0004649001
164                                            -0.01293106                                         0.0004649001
165                                            -0.01293106                                         0.0004649001
166                                            -0.01293106                                         0.0004649001
167                                            -0.01293106                                         0.0004649001
168                                            -0.01293106                                         0.0004649001
169                                            -0.01293106                                         0.0004649001
170                                            -0.01293106                                         0.0004649001
171                                            -0.01293106                                         0.0004649001
172                                            -0.01293106                                         0.0004649001
173                                            -0.01293106                                         0.0004649001
174                                            -0.01293106                                         0.0004649001
175                                            -0.01293106                                         0.0004649001
177                                            -0.01293106                                         0.0004649001
180                                            -0.01293106                                         0.0004649001
    dose_level_x_temp_x_symbiontLow-x-20-x-Aposymbiotic dose_level_x_feed_x_symbiontcontrol-0-x-Fed-x-Symbiotic
142                                          0.05387462                                              0.03345601
145                                          0.05387462                                              0.03345601
147                                          0.05387462                                              0.03345601
148                                          0.05387462                                              0.03345601
149                                          0.05387462                                              0.03345601
150                                          0.05387462                                              0.03345601
151                                          0.05387462                                              0.03345601
152                                          0.05387462                                              0.03345601
153                                          0.05387462                                              0.03345601
154                                          0.05387462                                              0.03345601
155                                          0.05387462                                              0.03345601
157                                          0.05387462                                              0.03345601
159                                          0.05387462                                              0.03345601
160                                          0.05387462                                              0.03345601
161                                          0.05387462                                              0.03345601
162                                          0.05387462                                              0.03345601
163                                          0.05387462                                              0.03345601
164                                          0.05387462                                              0.03345601
165                                          0.05387462                                              0.03345601
166                                          0.05387462                                              0.03345601
167                                          0.05387462                                              0.03345601
168                                          0.05387462                                              0.03345601
169                                          0.05387462                                              0.03345601
170                                          0.05387462                                              0.03345601
171                                          0.05387462                                              0.03345601
172                                          0.05387462                                              0.03345601
173                                          0.05387462                                              0.03345601
174                                          0.05387462                                              0.03345601
175                                          0.05387462                                              0.03345601
177                                          0.05387462                                              0.03345601
180                                          0.05387462                                              0.03345601
    dose_level_x_feed_x_symbiontHigh-x-Fed-x-Aposymbiotic dose_level_x_feed_x_symbiontLow-x-Fed-x-Aposymbiotic
142                                          -0.001028932                                          -0.01600965
145                                          -0.001028932                                          -0.01600965
147                                          -0.001028932                                          -0.01600965
148                                          -0.001028932                                          -0.01600965
149                                          -0.001028932                                          -0.01600965
150                                          -0.001028932                                          -0.01600965
151                                          -0.001028932                                          -0.01600965
152                                          -0.001028932                                          -0.01600965
153                                          -0.001028932                                          -0.01600965
154                                          -0.001028932                                          -0.01600965
155                                          -0.001028932                                          -0.01600965
157                                          -0.001028932                                          -0.01600965
159                                          -0.001028932                                          -0.01600965
160                                          -0.001028932                                          -0.01600965
161                                          -0.001028932                                          -0.01600965
162                                          -0.001028932                                          -0.01600965
163                                          -0.001028932                                          -0.01600965
164                                          -0.001028932                                          -0.01600965
165                                          -0.001028932                                          -0.01600965
166                                          -0.001028932                                          -0.01600965
167                                          -0.001028932                                          -0.01600965
168                                          -0.001028932                                          -0.01600965
169                                          -0.001028932                                          -0.01600965
170                                          -0.001028932                                          -0.01600965
171                                          -0.001028932                                          -0.01600965
172                                          -0.001028932                                          -0.01600965
173                                          -0.001028932                                          -0.01600965
174                                          -0.001028932                                          -0.01600965
175                                          -0.001028932                                          -0.01600965
177                                          -0.001028932                                          -0.01600965
180                                          -0.001028932                                          -0.01600965
    temp_x_feed_x_symbiont20-x-Fed-x-Symbiotic dose_level_x_temp_x_feed_x_symbiontcontrol-0-x-20-x-Fed-x-Symbiotic
142                                -0.03388859                                                        -0.008172557
145                                -0.03388859                                                        -0.008172557
147                                -0.03388859                                                        -0.008172557
148                                -0.03388859                                                        -0.008172557
149                                -0.03388859                                                        -0.008172557
150                                -0.03388859                                                        -0.008172557
151                                -0.03388859                                                        -0.008172557
152                                -0.03388859                                                        -0.008172557
153                                -0.03388859                                                        -0.008172557
154                                -0.03388859                                                        -0.008172557
155                                -0.03388859                                                        -0.008172557
157                                -0.03388859                                                        -0.008172557
159                                -0.03388859                                                        -0.008172557
160                                -0.03388859                                                        -0.008172557
161                                -0.03388859                                                        -0.008172557
162                                -0.03388859                                                        -0.008172557
163                                -0.03388859                                                        -0.008172557
164                                -0.03388859                                                        -0.008172557
165                                -0.03388859                                                        -0.008172557
166                                -0.03388859                                                        -0.008172557
167                                -0.03388859                                                        -0.008172557
168                                -0.03388859                                                        -0.008172557
169                                -0.03388859                                                        -0.008172557
170                                -0.03388859                                                        -0.008172557
171                                -0.03388859                                                        -0.008172557
172                                -0.03388859                                                        -0.008172557
173                                -0.03388859                                                        -0.008172557
174                                -0.03388859                                                        -0.008172557
175                                -0.03388859                                                        -0.008172557
177                                -0.03388859                                                        -0.008172557
180                                -0.03388859                                                        -0.008172557
    dose_level_x_temp_x_feed_x_symbiontHigh-x-20-x-Fed-x-Aposymbiotic
142                                                       0.001930224
145                                                       0.001930224
147                                                       0.001930224
148                                                       0.001930224
149                                                       0.001930224
150                                                       0.001930224
151                                                       0.001930224
152                                                       0.001930224
153                                                       0.001930224
154                                                       0.001930224
155                                                       0.001930224
157                                                       0.001930224
159                                                       0.001930224
160                                                       0.001930224
161                                                       0.001930224
162                                                       0.001930224
163                                                       0.001930224
164                                                       0.001930224
165                                                       0.001930224
166                                                       0.001930224
167                                                       0.001930224
168                                                       0.001930224
169                                                       0.001930224
170                                                       0.001930224
171                                                       0.001930224
172                                                       0.001930224
173                                                       0.001930224
174                                                       0.001930224
175                                                       0.001930224
177                                                       0.001930224
180                                                       0.001930224
    dose_level_x_temp_x_feed_x_symbiontLow-x-20-x-Fed-x-Aposymbiotic
142                                                      0.002079059
145                                                      0.002079059
147                                                      0.002079059
148                                                      0.002079059
149                                                      0.002079059
150                                                      0.002079059
151                                                      0.002079059
152                                                      0.002079059
153                                                      0.002079059
154                                                      0.002079059
155                                                      0.002079059
157                                                      0.002079059
159                                                      0.002079059
160                                                      0.002079059
161                                                      0.002079059
162                                                      0.002079059
163                                                      0.002079059
164                                                      0.002079059
165                                                      0.002079059
166                                                      0.002079059
167                                                      0.002079059
168                                                      0.002079059
169                                                      0.002079059
170                                                      0.002079059
171                                                      0.002079059
172                                                      0.002079059
173                                                      0.002079059
174                                                      0.002079059
175                                                      0.002079059
177                                                      0.002079059
180                                                      0.002079059
 [ reached 'max' / getOption("max.print") -- omitted 57 rows ]

attr(,"class")
[1] "coef.mer"
```


