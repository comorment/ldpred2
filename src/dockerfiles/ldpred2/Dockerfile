FROM rocker/verse:4.2.1

ENV TZ=Europe
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /tmp
# COPY /scripts/apt_get_essential.sh .
# RUN bash apt_get_essential.sh

# R packages.
# CRAN packages
RUN R -e "install.packages('devtools', version='2.4.4', repos='http://cran.us.r-project.org')" && \
    R -e "require(devtools); install_version('bigreadr', version='0.2.4', repos='http://cran.us.r-project.org')" && \
    R -e "require(devtools); install_version('bigsnpr', version='1.10.8', repos='http://cran.us.r-project.org')" && \
    R -e "require(devtools); install_version('data.table', version='1.14.2', repos='http://cran.us.r-project.org')" && \
    R -e "require(devtools); install_version('DescTools', version='0.99.46', repos='http://cran.us.r-project.org')" && \
    R -e "require(devtools); install_version('dplyr', version='1.0.10', repos='http://cran.us.r-project.org')" && \
    R -e "require(devtools); install_version('fmsb', version='0.7.3', repos='http://cran.us.r-project.org')" && \
    R -e "require(devtools); install_version('ggplot2', version='3.3.5', repos='http://cran.us.r-project.org')" && \
    R -e "require(devtools); install_version('magrittr', version='2.0.3', repos='http://cran.us.r-project.org')" && \
    R -e "require(devtools); install_version('reghelper', version='1.1.1', repos='http://cran.us.r-project.org')" && \
    R -e "require(devtools); install_version('runonce', version='0.2.3', repos='http://cran.us.r-project.org')" && \
    R -e "require(devtools); install_version('tibble', version='3.1.8', repos='http://cran.us.r-project.org')" && \
    R -e "require(devtools); install_version('tidyr', version='1.2.1', repos='http://cran.us.r-project.org')"

WORKDIR /tools
