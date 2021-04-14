# crip4tracking

This repo mainly test the "Configurable & Reversible Imaging Pipeline" for object tracking algorithms.

This repository contains:
1. [Shell scripts](batch_test/) for batch image conversion using multiple threads.

## Table of Contents


## Background

The "Configurable & Reversible Imaging Pipeline" was proposed in the paper ["Reconfiguring the Imaging Pipeline for Computer Vision"](https://capra.cs.cornell.edu/research/visionmode/) by Mark Buckler, Suren Jayasuriya, and Adrian Sampson. The paper shows that most traditional ISP stages are unnecessary when targeting computer vision, and only two stages had significant effects on vision accuracy: demosaicing and gamma compression. However, their work only evaluated on a limited range of CV tasks (mainly include CNN-based object classification and detection). This project is dedicated to investigate whether the ISP with only two stages proposed in the paper are compatible with complex CV tasks such as object tracking.

The state-of-the-art object tracking algorithms are mainly divided into two groups: `Correlation Filter` based trackers and `Siamese Network` based trackers. And the Correlation Filter based trackers may use the `handcrafted feature` or `deep feature`. We will pick up some popular trackers among them for testing, e.g., ECO, Autotrack, etc. 

## Install

* Install `imagemagick` for converting JPG images to PNG images.
```
# install imagemagick on your Linux OS, btw, i use arch
$ sudo pacman -S imagemagick
```
* Install `Docker` for using the `CRIP` tool.
```
# install docker
$ sudo pacman -S docker
# add the current user to the docker group
$ sudo gpasswd -a ${USER} docker
# start docker using systemctl
$ sudo systemctl start docker.service 
```
* Or you may install `WSL2` and `Docker` on Windows 10. See [Get started with Docker remote containers on WSL 2](https://docs.microsoft.com/zh-cn/windows/wsl/tutorials/wsl-containers)
* Acquire the Docker for [approx-vision](https://github.com/cucapra/approx-vision) image
```
$ docker pull mbuckler/approx-vision
```

## Usage

### Convert JPG to PNG

* Run [batch_convert_m.sh](batch_test/batch_convert_m.sh) script, which use multi threads to accelerate.
```
$ cd batch_test
$ ./batch_convert_m.sh <folder of your JPG images>
```

### CRIP Usage

* Clone the [modified version](https://github.com/01xz/approx-vision) of [approx-vision](https://github.com/cucapra/approx-vision) repo.
* Run a docker container to use `CRIP`. Include both the input data and approx-vision repo as volumes.
```
$ sudo docker run -v <path to your image directory>:/datasets -v <path to your approx-vision repo>:/approx-vision -it mbuckler/approx-vision /bin/bash
```
* Run [batch_crip_m.sh](batch_test/batch_crip_m.sh) script, which use multi threads to accelerate.
```
$ ./batch_crip_m.sh <folder of images you wish to feed crip> <crip version>
```

## Related Efforts

* [approx-vision](https://github.com/cucapra/approx-vision)

## Maintainers

[01xz](https://github.com/01xz).

## Contributing

Feel free to dive in! [Open an issue](https://github.com/01xz/crip4tracking/issues/new) or submit PRs.

### Contributors

* 01xz

## License

[MIT](LICENSE) © 01xz