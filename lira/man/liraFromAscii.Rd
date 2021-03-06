\name{liraFromAscii}
\alias{liraFromAscii}
\title{ Low-Count Image Reconstruction and Analysis }
\description{ 
  This package is designed for multi-scale non-parametric image analysis for use in high-energy astrophysics. The code implements an MCMC sampler that simultaneously fits the image and the necessary tuning/smoothing parameters in the model. The model-based approach allows for quantification of the standard error of the fitted image and can be used to evaluate the goodness-of-fit of a proposed model.
}
\usage{
liraFromAscii(obs.file = stop("obs.file must be specified"),
    start.file = stop("start.file must be specified"), psf.file = NULL, 
    map.file = NULL, bkg.file = NULL, out.file = "LIRA.out",
    param.file = "LIRA.param", max.iter = stop("max.iter must be specified"),
    burn = 0, save.iters = TRUE, thin = 1,
    nrow = stop("nrow must be specified"), 
    ncol = stop("ncol must be specified"),
    nrow.psf = 1, ncol.psf = 1, mcmc = TRUE, fit.bkg.scale = TRUE,
    alpha.init = stop("alpha.init must be specified"),
    ms.total.count.pr = 1, ms.total.count.exp = 0.05, ms.alpha.kap2 = 1000)
}
\arguments{
  \item{obs.file}{ observed data file. }
  \item{start.file}{ file with starting values for each pixel. }
  \item{psf.file}{ point spread function. }
  \item{map.file}{ exposure map file. }
  \item{bkg.file}{ file with image of the background model. }
  \item{out.file}{ output file. }
  \item{param.file}{ parameter output file. }
  \item{max.iter}{ maximum number of iterations. }
  \item{burn}{ number of iterations to discard from the beginning of an MCMC sample. }
  \item{save.iters}{ logical. If \code{TRUE}, print iterations to output file. }
  \item{thin}{ if \code{save.iters = TRUE}, print every \code{(thin)}th iteration to output file. }
  \item{nrow}{ number of rows of input image. }
  \item{ncol}{ number of columns of input image. }
  \item{nrow.psf}{ number of rows of point spread function. }
  \item{ncol.psf}{ number of columns of point spread function. }
  \item{mcmc}{ logical. If \code{TRUE}, \code{lira} performs Markov chain Monte Carlo for posterior sampling. If \code{FALSE}, \code{lira} performs EM for mode finding. }
  \item{fit.bkg.scale}{ logical. If \code{TRUE}, \code{lira} fits a scale parameter to the background model. }
  \item{alpha.init}{ starting values for the vector of multiscale smoothing parameters. The length of the vector should be \code{log(nrow, base=2)}. }
  \item{ms.total.count.pr}{ shape of gamma prior on total counts from multiscale component. See `Details'.}
  \item{ms.total.count.exp}{ scale of gamma prior on total counts from multiscale component. See `Details'.}
  \item{ms.alpha.kap2}{ smoothing parameter for multi-scale fitting. }
}
\details{
  Details of the method are found in Esch et al. (2004).
  
  In the gamma prior on total counts in the multiscale component, \code{ms.total.count.pr} is the shape parameter and \code{ms.total.count.exp} is the scale parameter, such that the expectation is equal to \code{ms.total.count.pr / ms.total.count.exp}.
}
\value{
  \item{final}{the final image returned. If \code{mcmc = TRUE}, this will be the mean of the posterior distribution. Otherwise, this will be the image at the last iteration.}
  \item{logPost}{the value of the log posterior density at each iteration.}
  \item{stepSize}{the difference between the log posterior density at the current iteration and at the previous iteration.}
  \item{cycleSpinRow, cycleSpinCol}{the location of the center of the multi-scale grid for each iteration.}
  \item{smoothingParam[0-K]}{the values of the smoothing parameters for each iteration. \code{K = log(nrow, base=2)}.}
  \item{expectedMSCount}{the expected total number of counts in the multi-scale component of the model.}
  \item{bkgScale}{the background scale parameter. Only returned if \code{fit.bkg.scale = TRUE}.}
  \item{out.file}{the image output filename.}
  \item{param.file}{the parameter filename.}
}
\section{Warning}{
Images must be square (\code{nrow = ncol}), with dimensions equal to powers of 2.
}
\references{
Esch, D. N., Connors, A., Karovska, M., and van Dyk, D. A. (2004). An Image Reconstruction Technique with Error Estimates.  The Astrophysical Journal, 610, 1213-1227.

Connors, A. and van Dyk, D. A. (2007). How To Win With Non-Gaussian Data: Poisson Goodness-of-Fit. In  Statistical Challenges in Modern Astronomy IV (Editors: G. J. Babu and E. D. Feigelson), Astronomical Society of the Pacific, San Francisco, Vol. CS371, 101-117.

van Dyk, D. A., Connors, A., Esch, D. N., Freeman, P., Kang, H., Karovska, M., and Kashyap, V. (2006). Deconvolution in High Energy Astrophysics: Science, Instrumentation, and Methods (with discussion).  Bayesian Analysis,  1, 189-236.

\url{http://hea-www.harvard.edu/AstroStat/EMC2/}
}
\author{ Alanna Connors, Nathan Stein, David van Dyk }
\examples{
require(lira)
data(PoissonEImages)
# display simulated observation
image(PoissonE.obs)
# save images to text files
write(PoissonE.obs, file="PoissonEObs.txt")
write(PoissonE.null, file="PoissonENull.txt")
write(PoissonE.flat, file="PoissonEFlat.txt")
# analyze the simulated data using a null model for the background
lira.null <- liraFromAscii(obs.file="PoissonEObs.txt",
                           start.file="PoissonEFlat.txt",
                           bkg.file="PoissonENull.txt", 
                           mcmc=TRUE, max.iter=500, burn=50,
                           nrow=32, ncol=32, alpha.init=c(3,4,5,6,7))
# clean up
unlink("PoissonEObs.txt")
unlink("PoissonENull.txt")
unlink("PoissonEFlat.txt")
unlink("LIRA.out")
unlink("LIRA.param")
}