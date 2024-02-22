#Merge data sets
d2 <- d2|> 
  select(id, age:urbanisation, #background variables
         A2,#vote choice
         E2, E2_2, #left right placement & progressive-conservative placement
         H36_1:H36_5, #need for cognition
         H37_1_1:H37_3_2, #tolerance for ambiguity
         H38_1_1: H38_5_3) |> #PNC 
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
  rowwise() |> 
  mutate(H37_3_1 = replace_na(H37_3_1, H37_3_2), #impute missings ToA
         H37_3_2 = replace_na(H37_3_2, H37_3_1),
         H37_2_1 = replace_na(H37_2_1, H37_2_2),
         H37_2_2 = replace_na(H37_2_2, H37_2_1),
         H37_1_1 = replace_na(H37_1_1, sum(c(H37_1_2,
                                             H37_1_3,
                                             H37_1_4,
                                             H37_1_5,
                                             H37_1_6), na.rm=T)/5),
         H37_1_2 = replace_na(H37_1_2, sum(c(H37_1_1,
                                             H37_1_3,
                                             H37_1_4,
                                             H37_1_5,
                                             H37_1_6), na.rm=T)/5),
         H37_1_3 = replace_na(H37_1_3, sum(c(H37_1_2,
                                             H37_1_1,
                                             H37_1_4,
                                             H37_1_5,
                                             H37_1_6), na.rm=T)/5),
         H37_1_4 = replace_na(H37_1_4, sum(c(H37_1_2,
                                             H37_1_3,
                                             H37_1_1,
                                             H37_1_5,
                                             H37_1_6), na.rm=T)/5),
         H37_1_5 = replace_na(H37_1_5, sum(c(H37_1_2,
                                             H37_1_3,
                                             H37_1_4,
                                             H37_1_1,
                                             H37_1_6), na.rm=T)/5),
         H37_1_6 = replace_na(H37_1_6, sum(c(H37_1_2,
                                             H37_1_3,
                                             H37_1_4,
                                             H37_1_5,
                                             H37_1_1), na.rm=T)/5),
         #impute missings PNC
        H38_1_2 = replace_na(H38_1_2, sum(c(H38_1_3, H38_1_4), na.rm = T)/2),
        H38_1_3 = replace_na(H38_1_3, sum(c(H38_1_2, H38_1_4), na.rm = T)/2),
        H38_1_4 = replace_na(H38_1_4, sum(c(H38_1_3, H38_1_2), na.rm = T)/2),
        H38_2_1 = replace_na(H38_2_1, sum(c(H38_2_2, H38_2_3), na.rm = T)/2),
        H38_2_2 = replace_na(H38_2_2, sum(c(H38_2_1, H38_2_3), na.rm = T)/2),
        H38_2_3 = replace_na(H38_2_3, sum(c(H38_2_1, H38_2_2), na.rm = T)/2),
        H38_5_1 = replace_na(H38_5_1, sum(c(H38_5_2, H38_5_3), na.rm = T)/2),
        H38_5_2 = replace_na(H38_5_2, sum(c(H38_5_1, H38_5_3), na.rm = T)/2),
        H38_5_3 = replace_na(H38_5_3, sum(c(H38_5_1, H38_5_2), na.rm = T)/2),
        H38_4_1 = replace_na(H38_4_1, sum(c(H38_4_2,
                                            H38_4_3,
                                            H38_4_4,
                                            H38_4_5), na.rm=T)/4),
        H38_4_2 = replace_na(H38_4_2, sum(c(H38_4_1,
                                            H38_4_3,
                                            H38_4_4,
                                            H38_4_5), na.rm=T)/4),
        H38_4_3 = replace_na(H38_4_3, sum(c(H38_4_2,
                                            H38_4_1,
                                            H38_4_4,
                                            H38_4_5), na.rm=T)/4),
        H38_4_4 = replace_na(H38_4_4, sum(c(H38_4_2,
                                            H38_4_3,
                                            H38_4_1,
                                            H38_4_5), na.rm=T)/4),
        H38_4_5 = replace_na(H38_4_5, sum(c(H38_4_2,
                                            H38_4_3,
                                            H38_4_4,
                                            H38_4_1), na.rm=T)/4),
        H38_3_1 = replace_na(H38_3_1, sum(c(H38_3_2,
                                            H38_3_3,
                                            H38_3_4,
                                            H38_3_5,
                                            H38_3_6,
                                            H38_3_7), na.rm=T)/6),
        H38_3_2 = replace_na(H38_3_2, sum(c(H38_3_1,
                                            H38_3_3,
                                            H38_3_4,
                                            H38_3_5,
                                            H38_3_6,
                                            H38_3_7), na.rm=T)/6),
        H38_3_3 = replace_na(H38_3_3, sum(c(H38_3_2,
                                            H38_3_1,
                                            H38_3_4,
                                            H38_3_5,
                                            H38_3_6,
                                            H38_3_7), na.rm=T)/6),
        H38_3_4 = replace_na(H38_3_4, sum(c(H38_3_2,
                                            H38_3_3,
                                            H38_3_1,
                                            H38_3_5,
                                            H38_3_6,
                                            H38_3_7), na.rm=T)/6),
        H38_3_5 = replace_na(H38_3_5, sum(c(H38_3_2,
                                            H38_3_3,
                                            H38_3_4,
                                            H38_3_1,
                                            H38_3_6,
                                            H38_3_7), na.rm=T)/6),
        H38_3_6 = replace_na(H38_3_6, sum(c(H38_3_2,
                                            H38_3_3,
                                            H38_3_4,
                                            H38_3_5,
                                            H38_3_1,
                                            H38_3_7), na.rm=T)/6),
        H38_3_7 = replace_na(H38_3_7, sum(c(H38_3_2,
                                            H38_3_3,
                                            H38_3_4,
                                            H38_3_5,
                                            H38_3_6,
                                            H38_3_1), na.rm=T)/6)) |> 
  ungroup() |> 
  mutate_at(vars(H40_1:H40_14), #MCE: make all that are not 1 0
            funs(recode(., `1` = 1, .default = 0, .missing = 0))) |> 
  mutate_at(vars(H41_1:H41_14), #impute missings MCE - part1
            funs(replace_na(., 0))) |> 
  mutate_at(vars(H42_1:H42_14), #impute missings MCE - part1
            funs(replace_na(., 0))) |> 
  mutate(E2_2 = na_if(E2_2, 99),
         E2_2 = replace_na(E2_2, mean(E2_2, na.rm = TRUE)),
         E2_2 = 11 - E2_2) |> 
  drop_na(H38_1_1)

# Impute missings other
d <- d |> 
  mutate_at(vars(H37_1_1:H37_3_2), #impute missings ToA (13 questions)
            funs(replace_na(., round(mean(., na.rm=T),0)))) |> 
  mutate_at(vars(H38_1_1:H38_5_2), #impute missings PNC (21 questions)
            funs(replace_na(., round(mean(., na.rm=T),0))))

# Reverse coding
d <- d |> 
  mutate_at(vars(c("H36_3", "H36_4")),
            funs(6 - .)) |> #NFC reverse:
  mutate_at(vars(c("H37_1_1","H37_1_2","H37_1_3","H37_1_5","H37_2_1","H37_2_2","H37_2_3","H37_2_5","H37_3_1")),
            funs(6 - .)) |> #TOA reverse:
  mutate_at(vars(c("H38_1_2","H38_1_3","H38_1_5","H38_2_2","H38_2_3","H38_3_1","H38_3_4","H38_3_6","H38_4_2","H38_4_3","H38_4_4","H38_5_1")), #PNC reverse:
            funs(6 - .))|>
  mutate_at(vars(c("H41_1","H41_2","H41_3","H41_4","H41_5","H41_6","H41_7","H41_8","H41_9","H41_10","H41_11","H41_12","H41_13","H41_14")), #MCE reverse:
            funs(5 - .))




