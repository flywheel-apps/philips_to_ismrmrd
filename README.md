[![Docker Pulls](https://img.shields.io/docker/pulls/flywheel/philips_to_ismrmrd.svg)](https://hub.docker.com/r/flywheel/philips_to_ismrmrd/)
[![Docker Stars](https://img.shields.io/docker/stars/flywheel/philips_to_ismrmrd.svg)](https://hub.docker.com/r/flywheel/philips_to_ismrmrd/)

# philips_to_ismrmrd
Philips to ISMRMRD converter

Build context for a [Flywheel Gear](https://github.com/flywheel-io/gears/tree/master/spec) which runs the `philips_to_ismrmrd` tool (v0.1.0).
For more information on the ISMRMRD format see [ISMRMRD's documentation](http://ismrmrd.github.io/)

* You can change ```build.sh``` to edit the repository name for the image (default=`flywheel/philips_to_ismrmrd`).
* The resulting image is ~1GB

### Build the Image
To build the image:
```
git clone https://github.com/flywheel-apps/philips_to_ismrmrd.git
./build.sh
```

### Example Local Usage
To run the `philips_to_ismrmrd` command in this image on your local instance, do the following:
```
docker run --rm -ti \
  -v </path/to/raw/data>:/flywheel/v0/input/raw \
  -v </path/to/lab/data>:/flywheel/v0/input/lab \
  -v </path/to/sin/data>:/flywheel/v0/input/sin \
  -v </path/for/output/data>:/flywheel/v0/output \
  flywheel/philips_to_ismrmrd
```

Usage notes:
  * You are mounting the directories (using the ```-v``` flag) which contain the three input data files in directories in the container at ```/flywheel/v0/input/``` and mounting the directory where you want your output data within the container at ```/flywheel/v0/output```.
  * The three input directories are mounted separately within the container. Each input directory should contain only one file (.raw, .sin or .lab)
  * If an alternate stylesheet (.xsl file) for conversion is desired, an optional directory can be mounted with the added line ```-v </path/to/xsl/data>:/flywheel/v0/input/user_stylesheet```
  * No input arguments are required for the container to be executed
