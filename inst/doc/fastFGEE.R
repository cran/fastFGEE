## ----eval = FALSE-------------------------------------------------------------
# remotes::install_github("gloewing/fastFGEE", build_vignettes = TRUE)

## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", warning = FALSE, message = FALSE)
library(fastFGEE)

## ----eval = FALSE-------------------------------------------------------------
# install.packages("SuperGauss")

## ----eval = FALSE-------------------------------------------------------------
# data("d", package = "fastFGEE")
# dat <- d
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
#   cv = "fastkfold",
#   joint.CI = "wild",
#   var.type = "sandwich"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_nb <- fgee(
#   formula = Y ~ X1 + X2, data = dat, cluster = "ID",
#   family = mgcv::nb(),                 # or mgcv::nb(theta = 3) to fix it
#   time = "time", corr_long = "exchangeable", corr_fn = "ar1"
# )
# 
# fit_beta <- fgee(
#   formula = Y ~ X1 + X2, data = dat, cluster = "ID",
#   family = mgcv::betar(),
#   time = "time", corr_long = "exchangeable", corr_fn = "ar1"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_prev <- fgee(
#   formula = Y ~ X1 + X2, data = dat, cluster = "ID",
#   family = binomial(), time = "time",
#   corr_long = "exchangeable", corr_fn = "ar1",
#   sp.method = "fastk_grad"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_no_kernel <- fgee(
#   formula = Y ~ X1 + X2, data = dat, cluster = "ID",
#   family = binomial(), time = "time",
#   corr_long = "exchangeable", corr_fn = "ar1",
#   fastk.kernel = FALSE
# )
# 
# # or for the whole session
# options(fastFGEE.kernel = FALSE)

## ----eval = FALSE-------------------------------------------------------------
# options(fastFGEE.corr.kernel = FALSE)

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
#   joint.CI = "wild",
#   var.type = "sandwich"
# )
# 
# fgee.plot(fit_from_pffr)

## ----eval = FALSE-------------------------------------------------------------
# # Sandwich covariance with studentized wild-cluster calibration
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
# # Fast cluster-bootstrap covariance with the same wild calibration
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

## ----eval = FALSE-------------------------------------------------------------
# fit <- fgee(
#   Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = binomial(link = "logit"),
#   time = "time",
#   corr_long = "exchangeable",
#   corr_fn = "ar1",
#   sp.method = "auto",
#   working.retain = "auto",
#   corr.solver = "auto"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_small <- fgee(
#   Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = gaussian(),
#   time = "time",
#   joint.CI = FALSE,
#   sp.method = "sandwich_qreml",
#   keep.data = FALSE,
#   keep.initial.fit = FALSE,
#   keep.working.stats = FALSE
# )

