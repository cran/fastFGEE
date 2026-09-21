## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE,
  fig.align = "center",
  fig.width = 8.5,
  fig.height = 5.2,
  out.width = "100%"
)
library(fastFGEE)

## ----eval = FALSE-------------------------------------------------------------
# install.packages("fastFGEE")

## ----eval = FALSE-------------------------------------------------------------
# remotes::install_github("gloewing/fastFGEE", build_vignettes = TRUE)

## ----data-preview-------------------------------------------------------------
data("d", package = "fastFGEE")
dat <- d
Y <- as.matrix(dat$Y)

c(
  rows = nrow(dat),
  clusters = length(unique(dat$ID)),
  functional_grid_points = ncol(Y)
)

head(dat[c("ID", "X1", "X2", "time")])
head(Y[, 1:4])

## ----basic-fit, results = "hide"----------------------------------------------
fit_1step <- fgee(
  formula = Y ~ X1 + X2,
  data = dat,
  cluster = "ID",
  family = binomial(link = "logit"),
  time = "time",
  corr_long = "ar1",
  corr_fn = "independent",
  rho.smooth = TRUE,
  var.type = "sandwich",
  joint.CI = "wild",
  verbose.tuning = FALSE
)

## ----basic-fit-output---------------------------------------------------------
fit_1step$sp.method
fit_1step$lambda

## ----basic-plot---------------------------------------------------------------
fgee.plot(
  fit_1step,
  xlab = "Functional domain",
  title_names = c("Intercept", "X1", "X2")
)

## ----eval = FALSE-------------------------------------------------------------
# plot_data <- fgee.plot(fit_1step, return = TRUE)
# head(plot_data[[1]])

## ----eval = FALSE-------------------------------------------------------------
# # Longitudinal correlation only
# fit_long <- fgee(
#   Y ~ X1 + X2, data = dat, cluster = "ID",
#   family = binomial(), time = "time",
#   corr_long = "ar1", corr_fn = "independent"
# )
# 
# # Correlation in both directions
# fit_sep <- fgee(
#   Y ~ X1 + X2, data = dat, cluster = "ID",
#   family = binomial(), time = "time",
#   corr_long = "ar1", corr_fn = "ar1"
# )
# 
# # Flexible functional covariance
# fit_fpca <- fgee(
#   Y ~ X1 + X2, data = dat, cluster = "ID",
#   family = binomial(), time = "time",
#   corr_long = "independent", corr_fn = "fpca"
# )

## ----ci-output----------------------------------------------------------------
head(fit_1step$crit$ci$ci_pointwise[[2]], 3)
head(fit_1step$crit$ci$ci_joint[[2]], 3)

## ----eval = FALSE-------------------------------------------------------------
# fit_sw <- fgee(
#   Y ~ X1 + X2, data = dat, cluster = "ID",
#   family = binomial(), time = "time",
#   corr_long = "ar1", corr_fn = "ar1",
#   var.type = "sandwich",
#   joint.CI = "wild"
# )
# 
# fit_fb <- fgee(
#   Y ~ X1 + X2, data = dat, cluster = "ID",
#   family = binomial(), time = "time",
#   corr_long = "ar1", corr_fn = "ar1",
#   var.type = "fastboot",
#   boot.samps = 2000,
#   joint.CI = "wild"
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_pffr <- refund::pffr(
#   Y ~ X1 + X2,
#   data = dat,
#   family = binomial(),
#   algorithm = "bam",
#   method = "fREML",
#   discrete = TRUE,
#   bs.yindex = list(bs = "bs", k = 11, m = c(2, 1))
# )
# 
# fit_from_pffr <- fgee(
#   Y ~ X1 + X2,
#   pffr.mod = fit_pffr,
#   data = dat,
#   cluster = "ID",
#   family = binomial(),
#   time = "time",
#   corr_long = "exchangeable",
#   corr_fn = "independent"
# )
# 
# fgee.plot(fit_from_pffr)

## ----eval = FALSE-------------------------------------------------------------
# # Start from the wide data object used above
# Y_wide <- as.matrix(dat$Y)
# colnames(Y_wide) <- paste0("Y_", seq_len(ncol(Y_wide)))
# 
# # Functional-domain locations. These may be irregularly spaced.
# s_grid <- attr(dat$Y, "yindex")
# if (is.null(s_grid)) {
#   s_grid <- seq_len(ncol(Y_wide))
# }
# 
# stopifnot(length(s_grid) == ncol(Y_wide))
# 
# dat_wide <- data.frame(
#   ID = dat$ID,
#   X1 = dat$X1,
#   X2 = dat$X2,
#   time = dat$time,
#   Y_wide
# )
# 
# # Convert the matrix response to long form.
# # tidyr is used here only to make the reshaping easy to read.
# dat_long <- tidyr::pivot_longer(
#   dat_wide,
#   cols = tidyselect::starts_with("Y_"),
#   names_to = "yindex_col",
#   names_prefix = "Y_",
#   values_to = "Y",
#   values_drop_na = FALSE
# )
# 
# # Map each response column back to its functional-domain location.
# dat_long$yindex_col <- as.integer(dat_long$yindex_col)
# dat_long$yindex <- s_grid[dat_long$yindex_col]
# dat_long$time <- as.numeric(dat_long$time)
# 
# head(dat_long[c("ID", "time", "yindex", "Y")])
# 
# # Construct the ydata object expected by refund::pffr().
# Y.mat <- data.frame(
#   .obs = seq_len(nrow(dat_long)),
#   .index = dat_long$yindex,
#   .value = dat_long$Y
# )
# 
# fit_pffr_irregular <- refund::pffr(
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
# fit_from_irregular_pffr <- fgee(
#   formula = Y ~ X1 + X2,
#   pffr.mod = fit_pffr_irregular,
#   data = dat,
#   cluster = "ID",
#   family = binomial(),
#   time = "time",
#   corr_long = "exchangeable",
#   corr_fn = "independent",
#   joint.CI = "wild",
#   var.type = "sandwich"
# )
# 
# fgee.plot(fit_from_irregular_pffr)

## ----eval = FALSE-------------------------------------------------------------
# fit_small <- fgee(
#   Y ~ X1 + X2,
#   data = dat,
#   cluster = "ID",
#   family = binomial(),
#   time = "time",
#   corr_long = "exchangeable",
#   corr_fn = "independent",
#   joint.CI = FALSE,
#   keep.data = FALSE,
#   keep.initial.fit = FALSE,
#   keep.working.stats = FALSE
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_R_kernel <- fgee(
#   Y ~ X1 + X2, data = dat, cluster = "ID",
#   family = binomial(), time = "time",
#   corr_long = "exchangeable", corr_fn = "ar1",
#   fastk.kernel = FALSE
# )

## ----eval = FALSE-------------------------------------------------------------
# fit_nb <- fgee(
#   Y ~ X1 + X2, data = nb_dat, cluster = "ID",
#   family = mgcv::nb(),
#   time = "time", corr_long = "exchangeable", corr_fn = "ar1"
# )
# 
# # Fix theta if you want to supply it rather than estimate it initially
# fit_nb_fixed <- fgee(
#   Y ~ X1 + X2, data = nb_dat, cluster = "ID",
#   family = mgcv::nb(theta = 3),
#   time = "time", corr_long = "exchangeable", corr_fn = "ar1"
# )
# 
# fit_beta <- fgee(
#   Y ~ X1 + X2, data = beta_dat, cluster = "ID",
#   family = mgcv::betar(),
#   time = "time", corr_long = "exchangeable", corr_fn = "ar1"
# )

## ----eval = FALSE-------------------------------------------------------------
# install.packages("SuperGauss")
# 
# fit_sg <- fgee(
#   Y ~ X1 + X2, data = dat, cluster = "ID",
#   family = binomial(), time = "time",
#   corr_long = "ar1", corr_fn = "independent",
#   corr.solver = "supergauss"
# )

