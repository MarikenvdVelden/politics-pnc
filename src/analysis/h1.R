h1 <- tidy(lm(PNC ~ TOA + NFC + sex + education + age, d)) |> 
  mutate(lower = estimate - (1.96*std.error),
         upper = estimate + (1.96*std.error),
         term = recode(term,
                       `NFC` = "NfC",
                       `TOA` = "ToA",
                       `sexMale` = "Gender: Male",
                       `educationLow` = "Education: Low",
                       `educationMedium` = "Education: Medium",
                       `age` = "Age",
                       .default = term))

p1 <- h1 |> 
  filter(term != "(Intercept)") |> 
  ggplot(aes(x = estimate, y = term,
             xmin = lower,  xmax = upper)) +
  geom_point(color = "seagreen4", size = 2) +
  geom_errorbar(width = 0, color = "seagreen4") +
  labs(x = "Predicted PNC", y = "") +
  geom_vline(xintercept = 0, linewidth = .5, 
             color = "gray65", linetype = "dashed") +
  theme_ipsum()
