# Reliability of PNC with McDonalds Omega - reduced version
#https://www.personality-project.org/r/html/omega.html

pnc_omega <- omega(df3,nfactors = 3,
                  digits=2)


## Reliability with Cronbach's alpha
pnc <- d |> 
  select(starts_with("H38_")) |> 
  drop_na() |> 
  ltm::cronbach.alpha(probs = c(0.025, 0.975), B = 1000, CI = TRUE,
                      na.rm = FALSE, standardized = T)

pnc_short <- df3 |> 
  drop_na() |> 
  ltm::cronbach.alpha(probs = c(0.025, 0.975), B = 1000, CI = TRUE,
                      na.rm = FALSE, standardized = T)
  
nfc <- d |> 
  select(starts_with("H36_")) |> 
  drop_na() |> 
  ltm::cronbach.alpha(probs = c(0.025, 0.975), B = 1000, CI = TRUE,
                      na.rm = FALSE, standardized = T)

toa <- d |> 
  select(starts_with("H37_")) |> 
  drop_na() |> 
  ltm::cronbach.alpha(probs = c(0.025, 0.975), B = 1000, CI = TRUE,
                    na.rm = FALSE, standardized = T)

rel_scales <- tibble(Variable = c("PNC", "PNC-short", "NfC", "ToA"),
                     `Cronbach's Alpha` = c(pnc[[1]], pnc_short[[1]],
                                           nfc[[1]], toa[[1]]),
                     `CI Lower` = c(pnc[[6]][1], pnc_short[[6]][1],
                                    nfc[[6]][1], toa[[6]][1]),
                     `CI Upper` = c(pnc[[6]][2], pnc_short[[6]][2],
                                    nfc[[6]][2], toa[[6]][2])) |> 
  ggplot(aes(y = Variable, x = `Cronbach's Alpha`,
             xmin = `CI Lower`, xmax = `CI Upper`)) +
  geom_point(color = "seagreen4", size = 2) +
  geom_errorbar(width = 0, color = "seagreen4") +
  labs(x = "Cronbach's Alpha", y = "") +
  theme_ipsum()


# Create MCE variable + scales (mean scores)
d <- d |> 
  mutate(PNC = rowMeans(select(d, starts_with("H38")), na.rm = TRUE),
         TOA = rowMeans(select(d, starts_with("H37")), na.rm = TRUE),
         NFC = rowMeans(select(d, starts_with("H36")), na.rm = TRUE),
         H40 = rowSums(across(starts_with("H40_"))),
         H41 = rowSums(across(starts_with("H41_"))),
         H42 = rowSums(across(starts_with("H42_"))),
         MCE = ifelse(H40 == 0, 0, (H41 + H42)))
