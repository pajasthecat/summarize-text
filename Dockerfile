FROM rocker/r-apt:bionic

RUN apt-get update && apt-get install -y --no-install-recommends -qq \
      r-cran-plumber \
    	r-cran-tm \
    	r-cran-dplyr \
    	r-cran-stringi \
    	r-cran-readr \
    	r-cran-magrittr \
    	r-cran-catools \
    	r-cran-base64enc \
    	r-cran-rvest \
    	 && rm -rf /var/lib/apt/lists/*

WORKDIR /

COPY . /

EXPOSE 8000

CMD Rscript /src/server.R