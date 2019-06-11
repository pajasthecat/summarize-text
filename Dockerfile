FROM rocker/r-apt:bionic

RUN apt-get update && apt-get install -y -qq \
      libssl-dev \
      libcurl4-gnutls-dev \
      r-cran-plumber \
    	r-cran-tm \
    	r-cran-dplyr \
    	r-cran-stringi \
    	r-cran-readr \
    	r-cran-magrittr \
    	r-cran-catools \
    	r-cran-base64enc \
    	r-cran-rvest

WORKDIR /app

COPY . /app

EXPOSE 8000

ENTRYPOINT ["Rscript", "/app/src/server.R"]