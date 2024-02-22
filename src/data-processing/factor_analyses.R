#PCA (1000 respondents drawn by a random sample) - extended version (24 items)
#https://rpubs.com/KarolinaSzczesna/862710

df1 <- d |> 
  sample_n(1000) |> 
  select(starts_with("H38_")) 

res_pca <- prcomp(df1, scale = TRUE)
eig_val<-get_eigenvalue(res_pca)
var <- get_pca_var(res_pca)

# Contributions of variables to PC1
a<-fviz_contrib(res_pca, choice = "var", axes = 1)
# Contributions of variables to PC2
b<-fviz_contrib(res_pca, choice = "var", axes = 2)

#EFA (1000 respondents drawn by a random sample) - extended version (24 items)
#https://rpubs.com/pjmurphy/758265

df2 <- d |> 
  sample_n(1000) |> 
  select(starts_with("H38_"))

# Determine Number of Factors to Extract
ev <- eigen(cor(df2)) # get eigenvalues

# Extract (and rotate) factors
Nfacs <- 6  # This is for six factors. According to the prediction of 6 factors in the book chapter.
fit <- factanal(df2, Nfacs, rotation="promax")
loads <- fit$loadings

# CFA (1000 respondents drawn by a random sample)
#https://lavaan.ugent.be/tutorial/cfa.html

#a) reduced version: same items from book chapter Katalin; 
# H38_1_1, H38_1_2, H38_1_3, H38_1_4, H38_1_5
# H38_2_1, H38_3_1, H38_3_3, H38_3_4, H38_3_5
# H38_4_1, H38_4_2, H38_4_3, H38_5_2

df3 <- d |> 
  sample_n(1000) |> 
  select(H38_1_1, H38_1_2, H38_1_3, H38_1_4, H38_1_5,
         H38_2_1, H38_3_1, H38_3_3, H38_3_4, H38_3_5,
         H38_4_1, H38_4_2, H38_4_3, H38_5_2)

#b) other reduced version?
