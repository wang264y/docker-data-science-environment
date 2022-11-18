#!/usr/bin/env Rscript

# Set package repos
r = getOption("repos")
r["CRAN"] = "http://cran.us.r-project.org"
options(repos = r)

# The parent Docker image installs devtools
require(devtools)

# Add your packages below:
if (! require("XML") || packageVersion("XML") != "3.99.0.3") { install_version("XML", version="3.99.0.3") }
