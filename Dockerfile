# FROM rocker/verse
# I was using `FROM --platform=linux/amd64 rocker/verse` to compile
FROM --platform=linux/amd64 rocker/verse

RUN apt-get update && apt-get install -y make

RUN R -e "install.packages(c('tidyverse','caret','xgboost','rmarkdown','lubridate','factoextra','Rtsne'))"

WORKDIR /home/rstudio/work