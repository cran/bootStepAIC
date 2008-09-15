\name{boot.stepAIC}
\alias{boot.stepAIC}

\title{Bootstraps the Stepwise Algorithm of stepAIC() for Choosing a Model by AIC}

\description{
  Implements a Bootstrap procedure to investigate the variability of model selection under the
  stepAIC() stepwise algorithm of package MASS.
}

\usage{
boot.stepAIC(object, data, B = 100, alpha = 0.05, direction = "backward", 
             k = 2, verbose = FALSE, ...)
}

\arguments{
  \item{object}{an object representing a model of an appropriate class; currently, \code{"lm"}, \code{"aov"}, 
        \code{"glm"}, \code{"negbin"}, \code{"polr"}, \code{"survreg"}, and \code{"coxph"} objects are supported.}
  \item{data}{a \code{data.frame} or a \code{matrix} that contains the response variable and covariates.}
  \item{B}{the number of Bootstrap samples.}
  \item{alpha}{the significance level.}
  \item{direction}{the \code{direction} argument of \code{stepAIC()}.}
  \item{k}{the \code{k} argument of \code{stepAIC()}.}
  \item{verbose}{logical; if \code{TRUE} information about the evolution of the procedure is printed in the screen.}
  \item{\dots}{extra arguments to \code{stepAIC()}, e.g., \code{scope}.}
}

\details{
  The following procedure is replicated \code{B} times:
  \describe{
    \item{Step 1:}{Simulate a new data-set taking a sample with replacement from the rows of \code{data}.}
    \item{Step 2:}{Refit the model using the data-set from Step 1.}
    \item{Step 3:}{For the refitted model of Step 2 run the \code{stepAIC()} algorithm.}
  }
  Summarize the results by counting how many times (out of the \code{B} data-sets) each variable was selected, how
  many times the estimate of the regression coefficient of each variable (out of the times it was selected) it was 
  statistically significant in significance level \code{alpha}, and how many times the estimate of the regression 
  coefficient of each variable (out of the times it was selected) changed signs (see also Austin and Tu, 2004).
}

\value{An object of class \code{BootStep} with components
  \item{Covariates}{a numeric matrix containing the percentage of times each variable was selected.}
  \item{Sign}{a numeric matrix containing the percentage of times the regression coefficient of each variable
        had sign \eqn{+} and \eqn{-}.}
  \item{Significance}{a numeric matrix containing the percentage of times the regression coefficient of each 
        variable was significant under the \code{alpha} significance level.}
  \item{OrigModel}{a copy of \code{object}.}
  \item{OrigStepAIC}{the result of applying \code{stepAIC()} in \code{object}.}
  \item{direction}{a copy of the \code{direction} argument.}
  \item{k}{a copy of the \code{k} argument.}
  \item{BootStepAIC}{a list of length \code{B} containing the results of \code{stepAIC()} for each
    Bootstrap data-set.}
}

\references{
Austin, P. and Tu, J. (2004). Bootstrap methods for developing predictive models, \emph{The American Statistician},
\bold{58}, 131--137.

Venables, W. N. and Ripley, B. D. (2002). Modern Applied Statistics with S, 4th ed. Springer, New York.
}

\author{
Dimitris Rizopoulos \email{d.rizopoulos@erasmusmc.nl}
}


\seealso{
\code{stepAIC} in package MASS
}

\examples{

## lm() Example ##
n <- 350
x1 <- runif(n, -4, 4)
x2 <- runif(n, -4, 4)
x3 <- runif(n, -4, 4)
x4 <- runif(n, -4, 4)
x5 <- runif(n, -4, 4)
x6 <- runif(n, -4, 4)
x7 <- factor(sample(letters[1:3], n, rep = TRUE))
y <- 5 + 3 * x1 + 2 * x2 - 1.5 * x3 - 0.8 * x4 + rnorm(n, sd = 2.5)
data <- data.frame(y, x1, x2, x3, x4, x5, x6, x7)
rm(n, x1, x2, x3, x4, x5, x6, x7, y)

lmFit <- lm(y ~ (. - x7) * x7, data = data)
boot.stepAIC(lmFit, data)

#####################################################################

## glm() Example ##
n <- 200
x1 <- runif(n, -3, 3)
x2 <- runif(n, -3, 3)
x3 <- runif(n, -3, 3)
x4 <- runif(n, -3, 3)
x5 <- factor(sample(letters[1:2], n, rep = TRUE))
eta <- 0.1 + 1.6 * x1 - 2.5 * as.numeric(as.character(x5) == levels(x5)[1])
y1 <- rbinom(n, 1, plogis(eta))
y2 <- rbinom(n, 1, 0.6)
data <- data.frame(y1, y2, x1, x2, x3, x4, x5)
rm(n, x1, x2, x3, x4, x5, eta, y1, y2)

glmFit1 <- glm(y1 ~ x1 + x2 + x3 + x4 + x5, family = binomial, data = data)
glmFit2 <- glm(y2 ~ x1 + x2 + x3 + x4 + x5, family = binomial, data = data)

boot.stepAIC(glmFit1, data, B = 50)
boot.stepAIC(glmFit2, data, B = 50)

}

\keyword{regression}
