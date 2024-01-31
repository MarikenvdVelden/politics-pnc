#Merge data sets
d2 <- d2|> 
  select(id, age:urbanisation, #background variables
         A2,#vote choice
         E2, E2_2, #left right placement & progressive-conservative placement
         H36_1:H36_5, #need for cognition
         H37_1_1:H37_3_2, #tolerance for ambiguity
         H38_1_1: H38_5_2) |> #PNC 
  distinct(id, .keep_all = T)

d3 <- d3 |> 
  select(id, H40_1:H42_14)|> #PNC |> 
  distinct(id, .keep_all = T)

d <- full_join(d2, d3, by = "id")

# We want factors for variable
d <-  d |> 
  mutate_at(vars(c(sex, ethnicity, education, region, urbanisation, A2)),
            funs(factor(.)))

# We need to impute missings for NFC (6 questions), TOA (13 questions), PNC (21 questions), MCE (14 questions) -- if H40_i == 1, we move on to H41_i and H42_i
d <- d |> 
  mutate_at(vars(H36_1:H36_5), #impute missings NFC (6 questions)
            funs(replace_na(., round(mean(., na.rm=T),0)))) |> 
  mutate_at(vars(H37_1_1:H37_3_2), #impute missings TOA 
            funs(replace_na(., round(mean(., na.rm=T),0)))) |> 
  mutate_at(vars(H38_1_1:H38_5_2), #impute missings PNC
            funs(replace_na(., round(mean(., na.rm=T),0)))) |> 
  mutate_at(vars(H40_1:H40_14), #MCE: make all that are not 1 0
            funs(recode(., `1` = 1, .default = 0, .missing = 0))) |> 
  mutate_at(vars(H41_1:H41_14), #impute missings MCE - part1
            funs(replace_na(., 0))) |> 
  mutate_at(vars(H42_1:H42_14), #impute missings MCE - part1
            funs(replace_na(., 0))) |> 
  mutate(E2_2 = na_if(E2_2, 99),
         E2_2 = replace_na(E2_2, mean(E2_2, na.rm = TRUE)),
         E2_2 = 11 - E2_2)

# Reverse coding
d <- d |> 
  mutate_at(vars(c("H36_3", "H36_4")),
            funs(6 - .)) |> #NFC reverse:
  mutate_at(vars(c("H37_1_1","H37_1_2","H37_1_3","H37_1_5","H37_2_1","H37_2_2","H37_2_3","H37_2_5","H37_3_1")),
            funs(6 - .)) |> #TOA reverse:
  mutate_at(vars(c("H38_1_2","H38_1_3","H38_1_5","H38_2_2","H38_2_3","H38_3_1","H38_3_4","H38_3_6","H38_4_2","H38_4_3","H38_4_4","H38_5_1")), #PNC reverse:
            funs(6 - .))



