
library(dplyr)
library(stringr)
library(tidyr)
library(lavaan)
library(ggplot2)

# --------------------------------------------------
# 0) Start clean
# --------------------------------------------------
data <- d

# --------------------------------------------------
# 1) Party groupings & voting
# --------------------------------------------------
conservative_parties <- c(
  "VVD", "PVV", "Forum voor Democratie", "SGP", "JA21",
  "Boerburgerbewegging (BBB)", "BVNL", "CDA", "ChristenUnie",
  "Nieuw Sociaal Contract"
)

progressive_parties <- c(
  "PvdA/GroenLinks", "D66", "SP", "Partij voor de Dieren",
  "Volt", "BIJ1", "Denk"
)

data <- data %>%
  mutate(
    voting_bin_num = case_when(
      A2 %in% conservative_parties ~ 1,
      A2 %in% progressive_parties  ~ 0,
      TRUE                         ~ NA_real_
    ),
    voting_bin = ordered(voting_bin_num, levels = c(0, 1), labels = c("prog", "cons"))
  )

# Rename ideology variable
data <- data %>% rename(E2pc = E2_2)

# --------------------------------------------------
# 2) Coerce core vars & controls
# --------------------------------------------------
data <- data %>%
  mutate(
    PNC  = suppressWarnings(as.numeric(PNC)),
    TOA  = suppressWarnings(as.numeric(TOA)),
    NFC  = suppressWarnings(as.numeric(NFC)),
    MCE  = suppressWarnings(as.numeric(MCE)),
    E2   = suppressWarnings(as.numeric(E2)),     # left-right
    E2pc = suppressWarnings(as.numeric(E2pc)),   # progressive-conservative
    age  = suppressWarnings(as.numeric(age)),
    
    sex = case_when(
      str_to_lower(as.character(sex)) %in% c("male", "m", "1")   ~ 1,
      str_to_lower(as.character(sex)) %in% c("female", "f", "0") ~ 0,
      TRUE ~ NA_real_
    ),
    
    education = case_when(
      str_to_lower(as.character(education)) %in% c("low", "laag", "1")      ~ 1,
      str_to_lower(as.character(education)) %in% c("medium", "midden", "2") ~ 2,
      str_to_lower(as.character(education)) %in% c("high", "hoog", "3")     ~ 3,
      TRUE ~ NA_real_
    )
  )

# Guard against miscoded ideology values
data <- data %>%
  mutate(
    E2   = ifelse(E2 %in% c(99, 999)   | E2 < 0   | E2 > 10,   NA_real_, E2),
    E2pc = ifelse(E2pc %in% c(99, 999) | E2pc < 0 | E2pc > 10, NA_real_, E2pc)
  )

# --------------------------------------------------
# 3) Build analysis datasets
# --------------------------------------------------
# Main SEM dataset (continuous outcomes only)
sem_data_main <- data %>%
  select(PNC, TOA, NFC, E2, E2pc, MCE, age, sex, education) %>%
  drop_na() %>%
  mutate(MCE_z = as.numeric(scale(MCE)))

# Voting model dataset
sem_data_vote <- data %>%
  select(PNC, TOA, NFC, E2, E2pc, MCE, voting_bin, voting_bin_num, age, sex, education) %>%
  drop_na()

# Quick check
nrow(sem_data_main)
nrow(sem_data_vote)

#descriptives:
library(dplyr)

desc_main <- sem_data_main %>%
  summarise(
    N = n(),
    age_M = mean(age, na.rm = TRUE),
    age_SD = sd(age, na.rm = TRUE),
    PNC_M = mean(PNC, na.rm = TRUE),
    PNC_SD = sd(PNC, na.rm = TRUE),
    TOA_M = mean(TOA, na.rm = TRUE),
    TOA_SD = sd(TOA, na.rm = TRUE),
    NFC_M = mean(NFC, na.rm = TRUE),
    NFC_SD = sd(NFC, na.rm = TRUE),
    E2_M = mean(E2, na.rm = TRUE),
    E2_SD = sd(E2, na.rm = TRUE),
    E2pc_M = mean(E2pc, na.rm = TRUE),
    E2pc_SD = sd(E2pc, na.rm = TRUE),
    MCE_M = mean(MCE, na.rm = TRUE),
    MCE_SD = sd(MCE, na.rm = TRUE),
    sex_prop_male = mean(sex, na.rm = TRUE),
    education_M = mean(education, na.rm = TRUE),
    education_SD = sd(education, na.rm = TRUE)
  )

desc_vote <- sem_data_vote %>%
  summarise(
    N = n(),
    age_M = mean(age, na.rm = TRUE),
    age_SD = sd(age, na.rm = TRUE),
    PNC_M = mean(PNC, na.rm = TRUE),
    PNC_SD = sd(PNC, na.rm = TRUE),
    TOA_M = mean(TOA, na.rm = TRUE),
    TOA_SD = sd(TOA, na.rm = TRUE),
    NFC_M = mean(NFC, na.rm = TRUE),
    NFC_SD = sd(NFC, na.rm = TRUE),
    E2_M = mean(E2, na.rm = TRUE),
    E2_SD = sd(E2, na.rm = TRUE),
    E2pc_M = mean(E2pc, na.rm = TRUE),
    E2pc_SD = sd(E2pc, na.rm = TRUE),
    MCE_M = mean(MCE, na.rm = TRUE),
    MCE_SD = sd(MCE, na.rm = TRUE),
    sex_prop_male = mean(sex, na.rm = TRUE),
    education_M = mean(education, na.rm = TRUE),
    education_SD = sd(education, na.rm = TRUE)
  )

desc_main
desc_vote

# Gender counts
table(sem_data_main$sex, useNA = "ifany")

# Gender proportions
prop.table(table(sem_data_main$sex, useNA = "ifany"))

# Convert to percentages
prop.table(table(sem_data_main$sex, useNA = "ifany")) * 100

# Voting counts
table(sem_data_vote$voting_bin, useNA = "ifany")

# Voting proportions
prop.table(table(sem_data_vote$voting_bin, useNA = "ifany"))

# Convert to percentages
prop.table(table(sem_data_vote$voting_bin, useNA = "ifany")) * 100

table(sem_data_vote$voting_bin)
prop.table(table(sem_data_vote$voting_bin))

# Main SEM for H1, H2, H3, H5, RQ1, RQ2

model_test_separate <- '
  # H2: cognitive styles (separate) -> ideology
  E2pc ~ TOA + NFC + age + sex + education
  E2   ~ TOA + NFC + age + sex + education
  
  # H1 + H3 + H5: PNC predicted by cognition (separate) and ideology
  PNC ~ a1*TOA + a2*NFC + c1*E2pc + c2*E2 + age + sex + education
  
  # RQ1 + RQ2 + preference->exposure check
  MCE_z ~ p*PNC + q1*TOA + q2*NFC + r1*E2pc + r2*E2 + age + sex + education
  
  # Ideology measures may correlate beyond predictors
  E2pc ~~ E2
  
  # Allow the two cognitive styles to covary (standard for related exogenous predictors)
  TOA ~~ NFC
'

fit_test_separate <- sem(
  model = model_test_separate,
  data = sem_data_main,
  estimator = "MLR",        # Using MLR because these are continuous variables
  meanstructure = TRUE,
  missing = "fiml"
)

lavaan::summary(
  fit_test_separate,
  fit.measures = TRUE,
  standardized = TRUE,
  rsquare = TRUE,
  ci = TRUE
)

model_main <- '
  # Latent cognitive styles
  cog =~ TOA + NFC
    # Controls on latent cognition
  cog ~ age + sex + education
    # H2: cognitive styles -> ideology
  E2pc ~ b1*cog + age + sex + education
  E2   ~ b2*cog + age + sex + education
    # H1 + H3 + H5: PNC predicted by cognition and ideology
  PNC ~ a*cog + c1*E2pc + c2*E2 + age + sex + education
    # RQ1 + RQ2 + preference->exposure check
  MCE_z ~ p*PNC + q*cog + r1*E2pc + r2*E2 + age + sex + education
    # Ideology measures may correlate beyond predictors
  E2pc ~~ E2
'

fit_main <- sem(
  model = model_main,
  data = sem_data_main,
  estimator = "MLR",
  std.lv = TRUE,
  meanstructure = TRUE,
  missing = "fiml"
)

summary(
  fit_main,
  fit.measures = TRUE,
  standardized = TRUE,
  rsquare = TRUE,
  ci = TRUE
)

# H4 model: voting intention as outcome

model_h4_vote <- '
  cog =~ TOA + NFC

  cog ~ age + sex + education

  E2pc ~ cog + age + sex + education
  E2   ~ cog + age + sex + education

  PNC ~ cog + E2pc + E2 + age + sex + education

  voting_bin ~ h*PNC + i*cog + j1*E2pc + j2*E2 + age + sex + education

  E2pc ~~ E2
'

fit_h4_vote <- sem(
  model = model_h4_vote,
  data = sem_data_vote,
  estimator = "WLSMV",
  ordered = "voting_bin",
  std.lv = TRUE,
  parameterization = "theta",
  meanstructure = TRUE
)

summary(
  fit_h4_vote,
  fit.measures = TRUE,
  standardized = TRUE,
  rsquare = TRUE,
  ci = TRUE
)

# H5 

model_h5_reduced <- '
  cog =~ TOA + NFC

  cog ~ age + sex + education

  E2pc ~ cog + age + sex + education
  E2   ~ cog + age + sex + education

  PNC ~ c1*E2pc + c2*E2 + age + sex + education

  E2pc ~~ E2
'

fit_h5_reduced <- sem(
  model = model_h5_reduced,
  data = sem_data_main,
  estimator = "MLR",
  std.lv = TRUE,
  meanstructure = TRUE,
  missing = "fiml"
)

model_h5_full <- '
  cog =~ TOA + NFC

  cog ~ age + sex + education

  E2pc ~ cog + age + sex + education
  E2   ~ cog + age + sex + education

  PNC ~ a*cog + c1*E2pc + c2*E2 + age + sex + education

  E2pc ~~ E2
'

fit_h5_full <- sem(
  model = model_h5_full,
  data = sem_data_main,
  estimator = "MLR",
  std.lv = TRUE,
  meanstructure = TRUE,
  missing = "fiml"
)

summary(fit_h5_reduced, standardized = TRUE, ci = TRUE)
summary(fit_h5_full, standardized = TRUE, ci = TRUE)


data <- data %>%
  mutate(
    MCE_any = ifelse(MCE > 0, 1, 0),
    log_MCE_pos = ifelse(MCE > 0, log(MCE), NA_real_)
  )

data_pos <- data %>%
  filter(MCE > 0)

m_exp_vote_any <- glm(
  MCE_any ~ voting_bin_num + age + sex + education,
  data = data,
  family = binomial(link = "logit")
)

summary(m_exp_vote_any)
exp(cbind(OR = coef(m_exp_vote_any), confint(m_exp_vote_any)))

m_exp_vote_pos <- lm(
  log_MCE_pos ~ voting_bin_num + age + sex + education,
  data = data_pos
)

summary(m_exp_vote_pos)

library(dplyr)

data %>%
  summarise(
    n_total = n(),
    missing_PNC = sum(is.na(PNC)),
    missing_TOA = sum(is.na(TOA)),
    missing_NFC = sum(is.na(NFC)),
    missing_E2 = sum(is.na(E2)),
    missing_E2pc = sum(is.na(E2pc)),
    missing_MCE = sum(is.na(MCE)),
    missing_age = sum(is.na(age)),
    missing_sex = sum(is.na(sex)),
    missing_education = sum(is.na(education)),
    missing_voting = sum(is.na(voting_bin))
  )


data %>%
  summarise(missing_voting = sum(is.na(voting_bin)))

data %>%
  filter(is.na(voting_bin)) %>%
  count(A2, sort = TRUE)


lavaan::parameterEstimates(fit_main, standardized = TRUE, rsquare = TRUE, ci = TRUE)

lavaan::parameterEstimates(fit_h4_vote, standardized = TRUE, rsquare = TRUE, ci = TRUE)

lavaan::parameterEstimates(fit_h5_reduced, standardized = TRUE, ci = TRUE)
lavaan::parameterEstimates(fit_h5_full, standardized = TRUE, ci = TRUE)