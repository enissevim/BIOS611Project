FROM rocker/verse

RUN apt-get update && apt-get install -y make

RUN R -e "install.packages(c('tidyverse','caret','xgboost','rmarkdown','lubridate','factoextra','Rtsne'))"

WORKDIR /home/rstudio/work