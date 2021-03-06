\name{create.life}

\alias{create.life}
\alias{simulate.boral}

\title{Simulate a Multivariate Response Matrix}

\description{Simulate a multivariate response matrix, given parameters such as but not necessarily all of: family, number of latent variables and related coefficients, an matrix of explanatory variables and related coefficients, row effects, cutoffs for cumulative probit regression of ordinal responses.}

\usage{ 
create.life(true.lv = NULL, lv.coefs, X = NULL, X.coefs = NULL, 
     traits = NULL, traits.coefs = NULL, family, row.eff = "none", 
     row.params = NULL, row.ids = NULL, offset = NULL, 
     trial.size = 1, cutoffs = NULL, powerparam = NULL, 
     manual.dim = NULL, save.params = FALSE)

\method{simulate}{boral}(object, nsim = 1, seed = NULL, est = "median", ...)   
 }

\arguments{
  \item{object}{An object of class "boral".}

  \item{nsim}{Number of multivariate response matrices to simulate. Defaults to 1.}

 \item{seed}{Seed for dataset simulation. Defaults to \code{NULL}, in which case no seed is set.}

  \item{est}{A choice of either the posterior median (\code{est == "median"}) or posterior mean (\code{est == "mean"}), which are then treated as estimates and the fitted values are calculated from. Default is posterior median.}

  \item{true.lv}{A matrix of true latent variables. With multivariate abundance data in ecology for instance, each row corresponds to the true site ordination coordinates. Defaults to \code{NULL}, in which case no latent variables are included.}

 \item{lv.coefs}{A matrix containing column-specific intercepts, latent variable coefficients relating to \code{true.lv}, and dispersion parameters.}

  \item{X}{An model matrix of covariates, which can be included as part of the data generation. Defaults to \code{NULL}, in which case no model matrix is used. No intercept column should be included in \code{X}.}  

  \item{X.coefs}{The coefficients relating to the model matrix \code{X}. Defaults to \code{NULL}. This argument needs to be supplied if \code{X} is supplied and no \code{traits} are supplied.}

  \item{traits}{A model matrix of species covariates, which can be included as part of the data generation. Defaults to \code{NULL}, in which case no matrix is used. No intercept column should be included in \code{traits}, as it is included automatically.}  

  \item{traits.coefs}{A matrix of coefficients that are used to generate "new" column-specific intercepts and \code{X.coefs}. The number of rows should equal to (\code{ncol(X)+1}) and the number of columns should equal to (\code{ncol(traits)}+2). 
  
  How this argument works is as follows: when both \code{traits} and \code{traits.coefs} are supplied, then new column-specific intercepts (i.e. the first column of \code{lv.coefs} is overwritten) are generated by simulating from a normal distribution with mean equal to \cr \code{traits.coefs[1,1] + traits*traits.coefs[1,2:(ncol(traits.coefs)-1)]} and standard deviation \cr \code{traits.coefs[1,ncol(traits.coefs)]}. In other words, the last column of \code{trait.coefs} provides the standard deviation of the normal distribution, with the other columns being the regression coefficients in the mean of the normal distribution. Analogously, new \code{X.coefs} are generated in the same manner using the remaining rows of \code{trait.coefs}. Please see \code{\link{about.traits}} for more information.
   
	It is important that highlight then with in this data generation mechanism, the new column-specific intercepts and \code{X.coefs} are now random effects, being drawn from a normal distribution. 

	Defaults to \code{NULL}, in conjuction with \code{traits = NULL}.}  

  \item{family}{Either a single element, or a vector of length equal to the number of columns in \code{y}. The former assumes all columns of \code{y} come from this distribution. The latter option allows for different distributions for each column of \code{y}. Elements can be one of "binomial" (with probit link), "poisson" (with log link), "negative.binomial" (with log link), "normal" (with identity link), "lnormal" for lognormal (with log link), "tweedie" (with log link), "exponential" (with log link), "gamma" (with log link), "beta" (with logit link), "ordinal" (cumulative probit regression). 

  Please see \code{\link{about.distributions}} for information on distributions available in boral overall.
  }

  \item{row.eff}{Single element indicating whether row effects are included as fixed effects ("fixed"), random effects ("random") or not included ("none") in the boral model. If random effects, they are drawn from a normal distribution with mean zero and standard deviation given by \code{row.params}. Defaults to "none". } 

  \item{row.params}{Parameters corresponding to the row effect from the boral model. If \cr \code{row.eff = "fixed"}, then these are the fixed effects and should have length equal to the number of columns in \code{y}. If \code{row.eff = "random"}, then this is the standard deviation for the random effects normal distribution. \cr If \code{row.eff = "none"}, then this argument is ignored.}

 \item{row.ids}{A matrix with the number of rows equal to the number of rows in \code{y}, and the number of columns equal to the number of row effects to be included in the model. Element \eqn{(i,j)} indicates to the cluster ID of row \eqn{i} in \code{y} for random effect eqn{j}; please see \code{\link{boral}} for details. Defaults to \code{NULL}, so that if \code{row.params = NULL} then the argument is ignored, otherwise if \code{row.params} is supplied then \code{row.ids = matrix(1:nrow(y), ncol = 1)} i.e., a single, row effect unique to each row. An internal check is done to see \code{row.params} and \code{row.ids} are consistent in terms of arguments supplied.}    

 \item{offset}{A matrix with the same dimensions as the response matrix \code{y}, specifying an a-priori known component to be included in the linear predictor during fitting. Defaults to \code{NULL}.}

 \item{trial.size}{Either equal to a single element, or a vector of length equal to the number of columns in y. If a single element, then all columns assumed to be binomially distributed will have trial size set to this. If a vector, different trial sizes are allowed in each column of y. The argument is ignored for all columns not assumed to be binomially distributed. Defaults to 1, i.e. Bernoulli distribution.}

  \item{cutoffs}{A vector of common common cutoffs for proportional odds regression when any of \code{family} is ordinal. They should be increasing order. Defaults to \code{NULL}.}

  \item{powerparam}{A common power parameter for tweedie regression when any of \code{family} is tweedie. Defaults to \code{NULL}.}

  \item{manual.dim}{A vector of length 2, containing the number of rows (\eqn{n}) and columns (\eqn{p}) for the multivariate response matrix. This is a "backup" argument only required when \code{create.life} can not determine how many rows or columns the multivariate response matrix should be.}

  \item{save.params}{If \code{save.params = TRUE}, then all parameters provided as input and/or generated (e.g. when \code{traits} and \code{traits.coefs} are supplied then \code{X.coefs} is generated internally; please see \code{traits.coefs} argument above) are returned, in addition to the simulated multivariate response matrix. Defaults to \code{FALSE}.}
    
  \item{...}{Not used.}
}

\details{
\code{create.life} gives the user full capacity to control the true parameters of the model from which the multivariate responses matrices are generated from. 

\code{simulate} makes use of the generic function of the same name in \code{R}: it takes a fitted boral model, treats either the posterior medians and mean estimates from the model as the true parameters, and generates response matrices based off that.
}

\value{
If \code{create.life} is used, then: 1) if \code{save.params} = FALSE, a \eqn{n} by \eqn{p} multivariate response matrix is returned only, 2) if \code{save.params} = TRUE, then a list containing the element \code{resp} which is a \eqn{n} times \eqn{p} multivariate response matrix, as well as other elements for the parameters used in the true model, e.g. \code{true.lv, lv.coefs = lv.coefs, traits.coef}, is returned.

If \code{simulate} is used, then a three dimensional array of dimension \eqn{n} by \eqn{p} by \code{nsim} is returned. 
}

\author{
Francis K.C. Hui \email{fhui28@gmail.com}
}

\seealso{
\code{\link{boral}} for the default function for fitting a boral model. 
}

\examples{
## NOTE: The values below MUST NOT be used in a real application;
## they are only used here to make the examples run quick!!!
example.mcmc.control <- list(n.burnin = 10, n.iteration = 100, 
     n.thin = 1)

## Example 1a - Simulate a response matrix of normally distributed data
library(mvtnorm)

## 30 rows (sites) with two latent variables 
true.lv <- rbind(rmvnorm(n=15,mean=c(1,2)),rmvnorm(n=15,mean=c(-3,-1))) 
## 30 columns (species)
lv.coefs <- cbind(matrix(runif(30*3),30,3),1)

X <- matrix(rnorm(30*4),30,4) 
## 4 explanatory variables
X.coefs <- matrix(rnorm(30*4),30,4)

sim.y <- create.life(true.lv, lv.coefs, X, X.coefs, family = "normal")

\dontrun{
fit.boral <- boral(sim.y, X = X, family = "normal", num.lv = 2,
      mcmc.control = example.mcmc.control)

summary(fit.boral)
}

## Example 1b - Include a nested random row effect
## 30 subregions nested within six regions
row.ids <- cbind(1:30, rep(1:6,each=5))
## Subregion has a small std deviation; region has a larger one
true.row.sigma <- list(ID1 = 0.5, ID2 = 2)

sim.y <- create.life(true.lv, lv.coefs, X, X.coefs, row.eff = "random",
	row.params = true.row.sigma, row.ids = row.ids, family = "normal",
	save.params = TRUE)


## Example 2 - Simulate a response matrix of ordinal data
## 30 rows (sites) with two latent variables 
true.lv <- rbind(rmvnorm(15,mean=c(-2,-2)),rmvnorm(15,mean=c(2,2)))
## 10 columns (species)
true.lv.coefs <- rmvnorm(10,mean = rep(0,3)); 
## Cutoffs for proportional odds regression (must be in increasing order)
true.ordinal.cutoffs <- seq(-2,10,length=10-1)

sim.y <- create.life(true.lv = true.lv, lv.coefs = true.lv.coefs, 
     family = "ordinal", cutoffs = true.ordinal.cutoffs, save.params = TRUE) 

\dontrun{
fit.boral <- boral(y = sim.y$resp, family = "ordinal", num.lv = 2,
      mcmc.control = example.mcmc.control)
}

\dontrun{
## Example 3 - Simulate a response matrix of count data based off
## a fitted boral model involving traits (ants data from mvabund)
library(mvabund)
data(antTraits)

y <- antTraits$abun
X <- as.matrix(antTraits$env)
## Include only traits 1, 2, and 5, plus an intercept
traits <- as.matrix(antTraits$traits[,c(1,2,5)])
## Please see help file for boral regarding the use of which.traits
which.traits <- vector("list",ncol(X)+1)
for(i in 1:length(which.traits)) which.traits[[i]] <- 1:ncol(traits)

fit.traits <- boral(y, X = X, traits = traits, which.traits = which.traits, 
	family = "negative.binomial", num.lv = 2, 
      mcmc.control = example.mcmc.control)

## The hard way
sim.y <- create.life(true.lv = NULL, lv.coefs = fit.traits$lv.coefs.median, 
	X = X, X.coefs = fit.traits$X.coefs.median, 
	traits = traits, traits.coefs = fit.traits$traits.coefs.median, 
	family = "negative.binomial")

## The easy way
sim.y <- simulate(object = fit.traits)

}


## Example 4 - simulate Bernoulli data, based on a model with two latent variables, 
## no site variables, with two traits and one environmental covariates 
## This example is a proof of concept that traits can used 
## to explain environmental responses 
library(mvtnorm)

n <- 100; s <- 50
X <- as.matrix(scale(1:n))
colnames(X) <- c("elevation")

traits <- cbind(rbinom(s,1,0.5), rnorm(s)) 
## one categorical and one continuous variable
colnames(traits) <- c("thorns-dummy","SLA")

simfit <- list(true.lv = rmvnorm(n, mean = rep(0,2)), 
	lv.coefs = cbind(rnorm(s), rmvnorm(s, mean = rep(0,2))), 
	traits.coefs = matrix(c(0.1,1,-0.5,1,0.5,0,-1,1), 2, byrow = TRUE))
rownames(simfit$traits.coefs) <- c("beta0","elevation")
colnames(simfit$traits.coefs) <- c("kappa0","thorns-dummy","SLA","sigma")

simy = create.life(true.lv = simfit$true.lv, lv.coefs = simfit$lv.coefs, X = X, 
	traits = traits, traits.coefs = simfit$traits.coefs, family = "binomial") 


\dontrun{
## NOTE: The values below MUST NOT be used in a real application;
## they are only used here to make the examples run quick!!!
example.mcmc.control <- list(n.burnin = 10, n.iteration = 100, 
     n.thin = 1)

which.traits <- vector("list",ncol(X)+1); 
for(i in 1:length(which.traits)) which.traits[[i]] <- 1:ncol(traits)
fit.traits <- boral(y = simy, X = X, traits = traits, which.traits = which.traits, 
	family = "binomial", num.lv = 2, save.model = TRUE, calc.ics = FALSE,
	mcmc.control = example.mcmc.control)
}

}