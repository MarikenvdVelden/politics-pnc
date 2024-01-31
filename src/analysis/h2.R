h2_1 <- tidy(lm(PNC ~ E2 + sex + education + age, d)) |> 
  mutate(lower = estimate - (1.96*std.error),
         upper = estimate + (1.96*std.error),
         term = recode(term,
                       `E2` = "Ideology",
                       `sexMale` = "Gender: Male",
                       `educationLow` = "Education: Low",
                       `educationMedium` = "Education: Medium",
                       `age` = "Age",
                       .default = term),
         model = "Left-Right")

h2_2 <- tidy(lm(PNC ~ E2_2 + sex + education + age, d)) |> 
  mutate(lower = estimate - (1.96*std.error),
         upper = estimate + (1.96*std.error),
         term = recode(term,
                       `E2_2` = "Ideology",
                       `sexMale` = "Gender: Male",
                       `educationLow` = "Education: Low",
                       `educationMedium` = "Education: Medium",
                       `age` = "Age",
                       .default = term),
         model = "Progressive-Conservative")

d <- d |> 
  mutate(vote = recode(A2,
                       `CDA` = 1,
                       `Boerburgerbewegging (BBB)` = 1,
                       `BNVL` = 1,
                       `ChristenUnie` = 1,
                       `Forum voor Democratie` = 1,
                       `JA21` = 1,
                       `Nieuw Sociaal Contract` = 1,
                       `PVV` = 1,
                       `SGP` = 1,
                       `VVD` = 1,
                       .default = 0))

h2_3 <- tidy(lm(PNC ~ vote + sex + education + age, d)) |> 
  mutate(lower = estimate - (1.96*std.error),
         upper = estimate + (1.96*std.error),
         term = recode(term,
                       `vote` = "Ideology",
                       `sexMale` = "Gender: Male",
                       `educationLow` = "Education: Low",
                       `educationMedium` = "Education: Medium",
                       `age` = "Age",
                       .default = term),
         model = "Voting for Conservative Party")

p2 <- h2_1 |> 
  add_case(h2_2) |> 
  add_case(h2_3) |> 
  filter(term != "(Intercept)") |> 
  ggplot(aes(x = estimate, y = term,
             xmin = lower,  xmax = upper)) +
  geom_point(color = "seagreen4", size = 2) +
  geom_errorbar(width = 0, color = "seagreen4") +
  labs(x = "Predicted PNC", y = "") +
  facet_grid(.~model, scales = "free") +  
  geom_vline(xintercept = 0, linewidth = .5, 
             color = "gray65", linetype = "dashed") +
  theme_ipsum()
  