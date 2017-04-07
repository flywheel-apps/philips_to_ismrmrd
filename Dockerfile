# flywheel/philips_to_ismrmrd
FROM ubuntu:14.04
MAINTAINER Jennifer Reiter <jenniferreiter@invenshure.com>

## Install Dependencies
#   HDF5, Boost, Libxslt, Libxml2
#   Xerces-C XML parser library, Cmake build tool
RUN sudo apt-get update \
    && apt-get install -y build-essential \
        cmake \
        libboost-all-dev \
        fftw-dev \
        libhdf5-serial-dev \
        hdf5-tools \
        libxml2-dev \
        libxslt1-dev

# Download the ISMRMRD code
RUN mkdir /ismrmrd
ADD https://github.com/ismrmrd/ismrmrd/archive/v1.3.2.tar.gz /ismrmrd
# Unpack the tar.gz
RUN cd /ismrmrd && tar -zxvf v1.3.2.tar.gz
# Install ISMRMRD code
RUN cd ismrmrd/ismrmrd-1.3.2 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    sudo make install && \
    sudo ldconfig

# Set ISMRMRD environment variable
ENV ISMRMRD_HOME /usr/local/ismrmrd
# SET LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH /usr/local/lib

# Download the Philips to ISMRMRD code (v0.1.0)
RUN mkdir /philips_to_ismrmrd
ADD https://github.com/ismrmrd/philips_to_ismrmrd/archive/v0.1.0.tar.gz /philips_to_ismrmrd
# Unpack the tar.gz
RUN cd /philips_to_ismrmrd && tar -zxvf v0.1.0.tar.gz
# Install
RUN cd philips_to_ismrmrd/philips_to_ismrmrd-0.1.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    sudo make install

# Install wget in order to install jq
RUN apt-get update && apt-get -y install wget
# Install jq to parse the JSON config file
RUN wget -N -qO- -O /usr/bin/jq http://stedolan.github.io/jq/download/linux64/jq
RUN chmod +x /usr/bin/jq

# Make directory for flywheel spec (v0)
ENV FLYWHEEL /flywheel/v0
RUN mkdir -p ${FLYWHEEL}
# Copy manifest file
COPY manifest.json ${FLYWHEEL}
# Copy run script
COPY run ${FLYWHEEL}/run
RUN chmod +x ${FLYWHEEL}/run

# Copy over IsmrmrdPhilips.xsl file
COPY IsmrmrdPhilips.xsl ${FLYWHEEL}/IsmrmrdPhilips.xsl

# ENV preservation for Flywheel Engine
RUN env -u HOSTNAME -u PWD > ${FLYWHEEL}/docker-env.sh

# Configure entrypoint
ENTRYPOINT ["/flywheel/v0/run"]
