# Narrative Nuances: Exploring the Interplay of Cognitive Styles, Political Affiliation, and Preferences for Narrative Complexity in Media

Online research compendium of the paper entitled _Narrative Nuances: Exploring the Interplay of Cognitive Styles, Political Affiliation, and Preferences for Narrative Complexity in Media'_ . 
This repository combines the  paper with the data &amp; analysis compendium -- see the scripts in `src/data-processing` for details on the data and `src/analysis` for the analyses presented in the paper.

## Get in touch
For further questions, feel free to reach out at: g.n.yonah@vu.nl

## Paper
View the pre-print of the paper [here](report/preprint.pdf)

## Data  &amp; Descririptives

### Methodology & Procedure

The study used survey data from the VU Election Study 2023b, a four-wave online panel study administered by KiesKompas using the KiesKompas VIP panel (Van der Velden, 2023). Participants were Dutch adults who completed a larger survey battery including measures of narrational complexity preference, exposure to narrationally complex media, cognitive styles, political self-placement, and voting intention.

The full survey sample consisted of 2,400 adult participants. The primary structural equation model was estimated on 2,311 respondents with complete data on the continuous study variables (Mage = 57.0, SD = 16.6; 41.5% women, 58.5% men). Analyses involving voting intention were conducted on a reduced subsample of 2,007 respondents with classifiable progressive-versus-conservative voting intentions.

[This page](src/data-processing/Factoranalysis.Rmd) provides details on data processing, scale construction, and the measurement models.
[This page](src/analysis/Sem_final.R) provides details on the analysis used for the hypotheses and exploratory questions testing

### Measures

* **Preference for Narrational Complexity (PNC) Scale** (Willemsen et al., 2022)
  - A 23-item scale assessing individual preferences for narrationally complex structures in film and television.
  - Items cover features such as nonclosure, puzzles, information load, temporal complexity, twists, and incongruities.
  - Higher scores indicate stronger preference for narrational complexity.

* **Narrational Complexity Exposure (NCE) Composite**
  - A self-reported exposure measure based on 14 narrationally complex films and television series.
  - For each title, participants indicated whether and to what extent they had seen it.
  - The composite reflects both the number of titles participants had encountered and the extent of viewing, with higher scores indicating greater cumulative exposure to narrationally complex media.

* **Tolerance of Ambiguity**
  - Measured using the 13-item Multiple Stimulus Types Ambiguity Tolerance Scale-II (MSTAT-II; McLain, 2009).
  - Assesses the degree to which individuals are comfortable with uncertainty, ambiguity, and unfamiliar situations.
  - Higher scores indicate greater tolerance of ambiguity.

* **Need for Cognition**
  - Measured using the 6-item Need for Cognition scale (Coelho et al., 2020).
  - Assesses the tendency to engage in and enjoy effortful cognitive activity.
  - Higher scores indicate greater need for cognition.

* **Political Ideology**
  - Assessed using two ideological self-placement items adapted from Jost et al. (2009).
  - Participants placed themselves on a left–right dimension and on a progressive–conservative dimension.
  - Higher scores indicate more right-wing and more conservative self-placement, respectively.

* **Voting Intention**
  - Participants indicated which political party they intended to vote for in the upcoming Dutch election.
  - Party choices were classified as progressive or conservative using KiesKompas party positions.
  - The resulting binary variable was coded as 0 = progressive voting intention and 1 = conservative voting intention.
    


## Results

* [This page](report/figures/semfinal.png) shows the results of the SEM anaysis. 

## Code of Conduct
Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
