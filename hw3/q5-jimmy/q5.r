# set working directory
setwd("~/data622-group4/hw3")

# load packages
packages <- c(
    'tidyverse', 
    'corrplot', 
    'palmerpenguins',
    'class',
    'kableExtra',
    'naniar',
    'DataExplorer',
    'caret',
    'tidymodels',
    'rsample',
    'themis',
    'randomForest',
    # 'htmlTable', 
    # 'gmodels', 
    # 'car', 
    # 'mice', 
    # 'tidyselect', 
    # 'skimr', 
    # 'tidymodels', 
    'broom'
    # 'dotwhisker', 
    # 'vip', 
    # 'parsnip', 
    # 'workflows', 
    # 'recipes', 
    # 'tune', 
    # 'yardstick'
)

for (pkg in packages) {
    suppressPackageStartupMessages(suppressWarnings(
        library(
            pkg, character.only = TRUE, 
            warn.conflicts = FALSE, quietly = TRUE)
    ))
}

# load rds into session
rds_files = c(paste0("output/", list.files("output")), 
              paste0("data/", list.files("data"))) %>%
    grep(pattern = ".rds$", ., ignore.case = TRUE, value = TRUE)

var_names = gsub(pattern = "(output/|data/|.[Rr]ds)", replacement = "", x = rds_files) %>%
    gsub(pattern = "-", replacement = "_", .)

sapply(1:length(rds_files), function(x) assign(var_names[x], readRDS(rds_files[x]), envir = .GlobalEnv)) %>% invisible()

#########################################
### look at prediction result

# reorder level 
loans_test_target <- relevel(loans_test$Loan_Status, ref = "Y")

# decision tree
dt_testing_predictions = relevel(dt_testing_Predictions$.pred_class, ref = "Y")
dt_confusionMatrix = caret::confusionMatrix(dt_testing_predictions, loans_test_target)
dt_confusionMatrix

# random forest
rf_mod2_predictions = relevel(rf_mod2_predictions, ref = "Y")
rf_confusionMatrix = caret::confusionMatrix(rf_mod2_predictions, loans_test_target)
rf_confusionMatrix

# xgb boost
xgb_pred = ifelse(xgb_final_predictions > .5, 'Y', 'N') %>% 
    factor(., levels = c("Y", "N"), labels = c("Y", "N"))
xgb_confusionMatrix = caret::confusionMatrix(xgb_pred, loans_test_target)
xgb_confusionMatrix

# tidy output
dt_stat = broom::tidy(dt_confusionMatrix)
rf_stat = broom::tidy(rf_confusionMatrix)
xgb_stat = broom::tidy(xgb_confusionMatrix)

model_stat_tidy = dplyr::inner_join(dt_stat %>% dplyr::select(term, `decision tree` = estimate),
                                    rf_stat %>% dplyr::select(term, `random forest` = estimate), 
                                    by = "term") %>%
    dplyr::inner_join(., xgb_stat %>% dplyr::select(term, `gradient boosting` = estimate),
                      by = "term")

model_stat_tidy %>% dplyr::filter(term != "mcnemar")


























