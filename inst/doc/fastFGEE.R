## ----eval = FALSE-------------------------------------------------------------
# remotes::install_github("gloewing/fastFGEE", build_vignettes = TRUE)

## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", warning = FALSE, message = FALSE)
library(fastFGEE)

## ----eval = FALSE-------------------------------------------------------------
# dat_path <- system.file("data", "binary_ar1_data", package = "fastFGEE")
# if (dat_path == "") {
#   dat_path <- "binary_ar1_data"
# }
# dat0 <- readRDS(dat_path)

## ----eval = FALSE-------------------------------------------------------------
# dat <- data.frame(
#   Y = I(dat0$Y),
#   X1 = dat0$X1,
#   X2 = dat0$X2,
#   ID = dat0$ID,
#   time = dat0$time
# )
# 
# head(as.matrix(dat$Y)[, 1:4])
# head(dat[c("ID", "X1", "X2", "time")])

## ----eval = FALSE-------------------------------------------------------------
# fit_1step <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "ar1",
#   corr_fn = "independence",
#   rho.smooth = TRUE,
#   max.iter = 1,
#   cv = "fastkfold",
#   joint.CI = "wild",
#   var.type = "sandwich"
# )
# 
# fgee.plot(fit_1step)

## ----eval = FALSE-------------------------------------------------------------
# fit_1step <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "ar1",
#   corr_fn = "ar1",
#   max.iter = 1,
#   cv = "fastkfold",
#   joint.CI = "wild",
#   var.type = "sandwich"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_full <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "ar1",
#   corr_fn = "ar1",
#   max.iter = 100,
#   cv = "fastkfold",
#   joint.CI = "wild",
#   var.type = "sandwich"
# )
# 
# fit_full$n_iter
# fit_full$converged

## ----eval = FALSE-------------------------------------------------------------
# fit_full_tuned <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "ar1",
#   corr_fn = "ar1",
#   max.iter = 100,
#   tune.method = "fully-iterated",
#   cv = "fastkfold",
#   joint.CI = "wild",
#   var.type = "sandwich"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_pffr_robust <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   gee.fit = FALSE,
#   max.iter = 1,
#   joint.CI = "wild",
#   var.type = "sandwich"
# )

## ----eval = FALSE-------------------------------------------------------------
# p_pffr <- fgee.plot(
#   fit_pffr_robust,
#   xlab = "Functional Domain",
#   title_names = c("pffr: Intercept", "pffr: X1", "pffr: X2")
# )
# 
# p_1step <- fgee.plot(
#   fit_1step,
#   xlab = "Functional Domain",
#   title_names = c("One-step: Intercept", "One-step: X1", "One-step: X2")
# )
# 
# p_full <- fgee.plot(
#   fit_full,
#   xlab = "Functional Domain",
#   title_names = c("Fully-iterated: Intercept", "Fully-iterated: X1", "Fully-iterated: X2")
# )
# 
# gridExtra::grid.arrange(p_pffr, p_1step, p_full, nrow = 3)

## ----eval = FALSE-------------------------------------------------------------
# fit_long_block <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "ar1",
#   corr_fn = "independence",
#   rho.smooth = TRUE,
#   max.iter = 1,
#   joint.CI = "wild",
#   var.type = "sandwich"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_fn_block <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "independence",
#   corr_fn = "exchangeable",
#   rho.smooth = TRUE,
#   max.iter = 1,
#   joint.CI = "wild",
#   var.type = "sandwich"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_sep <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "ar1",
#   corr_fn = "ar1",
#   max.iter = 1,
#   joint.CI = "wild",
#   var.type = "sandwich"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_fpca_block <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "independence",
#   corr_fn = "fpca",
#   max.iter = 1,
#   joint.CI = "wild",
#   var.type = "sandwich"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_fpca_sep <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "ar1",
#   corr_fn = "fpca",
#   max.iter = 1,
#   joint.CI = "wild",
#   var.type = "sandwich"
# )

## ----eval = FALSE-------------------------------------------------------------
# # Start from the wide data object used above
# Y_wide <- as.matrix(dat$Y)
# colnames(Y_wide) <- paste0("Y_", seq_len(ncol(Y_wide)))
# 
# dat_wide <- data.frame(
#   ID = dat$ID,
#   X1 = dat$X1,
#   X2 = dat$X2,
#   time = dat$time,
#   Y_wide
# )
# 
# # Convert the matrix outcome to long format
# # (shown here with tidyr for readability)
# dat_long <- tidyr::pivot_longer(
#   dat_wide,
#   cols = tidyselect::starts_with("Y_"),
#   names_to = "yindex",
#   names_prefix = "Y_",
#   values_to = "Y",
#   values_drop_na = FALSE
# )
# 
# dat_long$yindex <- as.integer(dat_long$yindex)
# dat_long$time <- as.numeric(dat_long$time)
# 
# # Construct the ydata object expected by refund::pffr()
# Y.mat <- data.frame(
#   .obs = seq_len(nrow(dat_long)),
#   .index = dat_long$yindex,
#   .value = dat_long$Y
# )
# 
# fit_pffr <- refund::pffr(
#   formula = Y ~ X1 + X2,
#   algorithm = "bam",
#   family = binomial(),
#   discrete = TRUE,
#   yind = Y.mat$.index,
#   ydata = Y.mat,
#   bs.yindex = list(bs = "bs", k = 11),
#   data = dat_long
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_from_pffr <- fgee(
#   formula = Y ~ X1 + X2,
#   pffr.mod = fit_pffr,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "exchangeable",
#   corr_fn = "independence",
#   max.iter = 1,
#   joint.CI = "wild",
#   var.type = "sandwich"
# )
# 
# fgee.plot(fit_from_pffr)

## ----eval = FALSE-------------------------------------------------------------
# # Sandwich variance + wild-bootstrap critical values
# fit_sw <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "ar1",
#   corr_fn = "ar1",
#   var.type = "sandwich",
#   joint.CI = "wild"
# )
# 
# # Fast cluster bootstrap variance + wild-bootstrap critical values
# fit_fb <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "ar1",
#   corr_fn = "ar1",
#   var.type = "fastboot",
#   boot.samps = 2000,
#   joint.CI = "wild"
# )
# 
# # Sandwich variance + parametric joint critical values
# fit_param <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "ar1",
#   corr_fn = "ar1",
#   var.type = "sandwich",
#   joint.CI = "parametric"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_gaussian_exact <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "gaussian",
#   time = "time",
#   corr_long = "ar1",
#   corr_fn = "ar1",
#   exact = TRUE,
#   max.iter = 1,
#   joint.CI = "wild",
#   var.type = "sandwich"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit <- fgee(
#   formula = Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = "binomial",
#   time = "time",
#   corr_long = "ar1",
#   corr_fn = "ar1",
#   max.iter = 1,
#   cv = "fastkfold",
#   joint.CI = "wild",
#   var.type = "sandwich"
# )

