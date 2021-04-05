## Changes proposed by ALR April 4, 2021

General

* Remove package install commands, reliance on `wrapr` and `pacman` -- we want our readers to be able to run our code without having to install packages *unless* they are required for data prep and modeling
* The package `conflicted` does not work on my machine, but it appears the code runs fine without it
* Shortened list of loaded packages to the bare minimum
* Applied consistent style to R code:
    + Spaces around "=", around "<-", and after commas in function argument lists
    + Wrap lines to make long statements more readable
    + Use `dplyr` for data prep wherever possible
    + "T" and "F" spelled out



Question #1

* Move data prep to appendix
* Normalize all numerics, including factors
* Make code and narrative more concise 
* Add k = 1:20 trials as part of narrative instead of appendix, but show odd values of k only
* Experiment with model that doesn't use island (because of it's abnormally strong predictive quality)


Question #2

* Moved non-specific data prep code to an intermediary section
* Changed some narrative
* Edited correlation plot to match style of Ajay's for question #1
* Removed extraneous proportion table for loan status
* Moved paragraph on kappa
* Removed candidate models #2, #4, #5


