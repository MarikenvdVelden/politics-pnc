h2_1 <- tidy(lm(PNC ~ E2 + sex + education + age, d)) |> 
  mutate(lower = estimate - (1.96*std.error),
         upper = estimate + (1.96*std.error),
         term = recode(term,
                       `E2` = "Ideology (Left-Right)",
                       `sexMale` = "Gender: Male",
                       `educationLow` = "Education: Low",
                       `educationMedium` = "Education: Medium",
                       `age` = "Age",
                       .default = term),
         model = "Model 1")

h2_2 <- tidy(lm(PNC ~ E2_2 + sex + education + age, d)) |> 
  mutate(lower = estimate - (1.96*std.error),
         upper = estimate + (1.96*std.error),
         term = recode(term,
                       `E2_2` = "Ideology (Progressive-Conservative)",
                       `sexMale` = "Gender: Male",
                       `educationLow` = "Education: Low",
                       `educationMedium` = "Education: Medium",
                       `age` = "Age",
                       .default = term),
         model = "Model 2")

p2 <- h2_1 |> 
  add_case(h2_2) |> 
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
  