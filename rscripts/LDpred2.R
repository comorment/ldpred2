## -----------------------
# Mock up analysis script modified from https://privefl.github.io/bigsnpr/articles/LDpred2.html
# 
# Confer the original file for explainations.
## -----------------------

# libraries
library(bigsnpr)
library(bigreadr)

## fix "Error: Two levels of parallelism are used. See `?assert_cores`."
options(bigstatsr.check.parallel.blas = FALSE)
options(default.nproc.blas = NULL)

## ------------------------------------------------------------------------
# $pos is in build GRCh37 / hg19, but we provide positions in 2 other builds
# info <- readRDS(runonce::download_file(
#   "https://figshare.com/ndownloader/files/37802721",
#   dir = "tutorial_data", fname = "map_hm3_plus.rds"))
# str(info)


## ----setup, include=FALSE------------------------------------------------
# options(htmltools.dir.version = FALSE, width = 75, max.print = 30)
# knitr::opts_knit$set(global.par = TRUE, root.dir = "..")
# knitr::opts_chunk$set(echo = TRUE, fig.align = 'center', dev = 'png', out.width = "90%")


## ------------------------------------------------------------------------
# install.packages("runonce")
# zip <- runonce::download_file(
#   "https://github.com/privefl/bigsnpr/raw/master/data-raw/public-data3.zip",
#   dir = "tutorial_data")
# unzip(zip)


## ---- echo=FALSE---------------------------------------------------------
unlink(paste0("tutorial_data/public-data3", c(".bk", ".rds")))

# Read from bed/bim/fam, it generates .bk and .rds files.
# snp_readBed("tutorial_data/public-data3.bed")

## ------------------------------------------------------------------------
# Load packages bigsnpr and bigstatsr
library(bigsnpr)
# Read from bed/bim/fam, it generates .bk and .rds files.
snp_readBed("tutorial_data/public-data3.bed")
# Attach the "bigSNP" object in R session
obj.bigSNP <- snp_attach("tutorial_data/public-data3.rds")
# See how the file looks like
str(obj.bigSNP, max.level = 2, strict.width = "cut")
# Get aliases for useful slots
G   <- obj.bigSNP$genotypes
CHR <- obj.bigSNP$map$chromosome
POS <- obj.bigSNP$map$physical.pos
y   <- obj.bigSNP$fam$affection
(NCORES <- nb_cores())


## ------------------------------------------------------------------------
# Read external summary statistics
sumstats <- bigreadr::fread2("tutorial_data/public-data3-sumstats.txt")
str(sumstats)


## ------------------------------------------------------------------------
set.seed(1)
ind.val <- sample(nrow(G), 350)
ind.test <- setdiff(rows_along(G), ind.val)


## ---- error=TRUE---------------------------------------------------------
# sumstats$n_eff <- 4 / (1 / sumstats$n_case + 1 / sumstats$n_control)
# sumstats$n_case <- sumstats$n_control <- NULL
sumstats$n_eff <- sumstats$N
map <- setNames(obj.bigSNP$map[-3], c("chr", "rsid", "pos", "a1", "a0"))
# df_beta <- snp_match(sumstats, map)
# 50,000 variants to be matched.
# 0 ambiguous SNPs have been removed.
# 4 variants have been matched; 2 were flipped and 2 were reversed.
# Error: Not enough variants have been matched.

## ------------------------------------------------------------------------
df_beta <- snp_match(sumstats, map, join_by_pos = FALSE)  # use rsid instead of pos


## ------------------------------------------------------------------------
# To convert physical positions (in bp) to genetic positions (in cM), use
# POS2 <- snp_asGeneticPos(CHR, POS, dir = "tutorial_data", ncores = NCORES)
# To avoid downloading "large" files, `POS2` has been precomputed here
POS2 <- obj.bigSNP$map$genetic.dist


## ------------------------------------------------------------------------
tmp <- tempfile(tmpdir = "tutorial_data")

for (chr in 1:22) {
  
  # print(chr)
  
  ## indices in 'df_beta'
  ind.chr <- which(df_beta$chr == chr)
  ## indices in 'G'
  ind.chr2 <- df_beta$`_NUM_ID_`[ind.chr]
  
  corr0 <- snp_cor(G, ind.col = ind.chr2, size = 3 / 1000,
                   infos.pos = POS2[ind.chr2], ncores = NCORES)
  
  if (chr == 1) {
    ld <- Matrix::colSums(corr0^2)
    corr <- as_SFBM(corr0, tmp, compact = TRUE)
  } else {
    ld <- c(ld, Matrix::colSums(corr0^2))
    corr$add_columns(corr0, nrow(corr))
  }
}


## ------------------------------------------------------------------------
file.size(corr$sbk) / 1024^3  # file size in GB

## --------------------------------
# Estimate of h2 from LD Score regression
(ldsc <- with(df_beta, snp_ldsc(ld, length(ld), chi2 = (beta / beta_se)^2,
                                sample_size = n_eff, blocks = NULL)))
h2_est <- ldsc[["h2"]]



## -----

(h2_seq <- round(h2_est * c(0.3, 0.7, 1, 1.4), 4))
(p_seq <- signif(seq_log(1e-5, 1, length.out = 21), 2))
(params <- expand.grid(p = p_seq, h2 = h2_seq, sparse = c(FALSE, TRUE)))

set.seed(1)  # to get the same result every time
# takes less than 2 min with 4 cores
beta_grid <- snp_ldpred2_grid(corr, df_beta, params, ncores = NCORES)

pred_grid <- big_prodMat(G, beta_grid, ind.col = df_beta[["_NUM_ID_"]])
params$score <- apply(pred_grid[ind.val, ], 2, function(x) {
  if (all(is.na(x))) return(NA)
  summary(lm(y[ind.val] ~ x))$coef["x", 3]
  # summary(glm(y[ind.val] ~ x, family = "binomial"))$coef["x", 3]
})
library(ggplot2)
ggplot(params, aes(x = p, y = score, color = as.factor(h2))) +
  theme_bigstatsr() +
  geom_point() +
  geom_line() +
  scale_x_log10(breaks = 10^(-5:0), minor_breaks = params$p) +
  facet_wrap(~ sparse, labeller = label_both) +
  labs(y = "GLM Z-Score", color = "h2") +
  theme(legend.position = "top", panel.spacing = unit(1, "lines"))

library(dplyr)
params %>%
  mutate(sparsity = colMeans(beta_grid == 0), id = row_number()) %>%
  arrange(desc(score)) %>%
  mutate_at(c("score", "sparsity"), round, digits = 3) %>%
  slice(1:10)

best_beta_grid <- params %>%
  mutate(id = row_number()) %>%
  # filter(sparse) %>% 
  arrange(desc(score)) %>%
  slice(1) %>%
  print() %>% 
  pull(id) %>% 
  beta_grid[, .]


pred <- big_prodVec(G, best_beta_grid, ind.row = ind.test,
                    ind.col = df_beta[["_NUM_ID_"]])
pcor(pred, y[ind.test], NULL)

# LDpred2-auto: automatic model

## ------------------------------------------------------------------------
set.seed(1)  # to get the same result every time
# takes less than 2 min with 4 cores
multi_auto <- snp_ldpred2_auto(corr, df_beta, h2_init = h2_est,
                               vec_p_init = seq_log(1e-4, 0.2, length.out = 30),
                               allow_jump_sign = FALSE, shrink_corr = 0.95,
                               ncores = NCORES)
str(multi_auto, max.level = 1)
str(multi_auto[[1]], max.level = 1)


## ------------------------------------------------------------------------
library(ggplot2)
auto <- multi_auto[[1]]  # first chain
plot_grid(
  qplot(y = auto$path_p_est) + 
    theme_bigstatsr() + 
    geom_hline(yintercept = auto$p_est, col = "blue") +
    scale_y_log10() +
    labs(y = "p"),
  qplot(y = auto$path_h2_est) + 
    theme_bigstatsr() + 
    geom_hline(yintercept = auto$h2_est, col = "blue") +
    labs(y = "h2"),
  ncol = 1, align = "hv"
)


## ------------------------------------------------------------------------
# `range` should be between 0 and 2
(range <- sapply(multi_auto, function(auto) diff(range(auto$corr_est))))
(keep <- (range > (0.95 * quantile(range, 0.95))))


## ------------------------------------------------------------------------
beta_auto <- rowMeans(sapply(multi_auto[keep], function(auto) auto$beta_est))
pred_auto <- big_prodVec(G, beta_auto, ind.row = ind.test, ind.col = df_beta[["_NUM_ID_"]])


## ------------------------------------------------------------------------
pcor(pred_auto, y[ind.test], NULL)


## ------------------------------------------------------------------------
beta_lassosum2 <- snp_lassosum2(corr, df_beta, ncores = NCORES)


## ------------------------------------------------------------------------
(params2 <- attr(beta_lassosum2, "grid_param"))
pred_grid2 <- big_prodMat(G, beta_lassosum2, ind.col = df_beta[["_NUM_ID_"]])
params2$score <- apply(pred_grid2[ind.val, ], 2, function(x) {
  if (all(is.na(x))) return(NA)
  summary(lm(y[ind.val] ~ x))$coef["x", 3]
  # summary(glm(y[ind.val] ~ x, family = "binomial"))$coef["x", 3]
})


## ------------------------------------------------------------------------
library(ggplot2)
ggplot(params2, aes(x = lambda, y = score, color = as.factor(delta))) +
  theme_bigstatsr() +
  geom_point() +
  geom_line() +
  scale_x_log10(breaks = 10^(-5:0)) +
  labs(y = "GLM Z-Score", color = "delta") +
  theme(legend.position = "top") +
  guides(colour = guide_legend(nrow = 1))


## ------------------------------------------------------------------------
library(dplyr)
best_grid_lassosum2 <- params2 %>%
  mutate(id = row_number()) %>%
  arrange(desc(score)) %>%
  print() %>% 
  slice(1) %>%
  pull(id) %>% 
  beta_lassosum2[, .]


## ------------------------------------------------------------------------
# Choose the best among all LDpred2-grid and lassosum2 models
best_grid_overall <- 
  `if`(max(params2$score, na.rm = TRUE) > max(params$score, na.rm = TRUE),
       best_grid_lassosum2, best_beta_grid)


## ------------------------------------------------------------------------
# Some cleaning
rm(corr); gc(); file.remove(paste0(tmp, ".sbk"))

