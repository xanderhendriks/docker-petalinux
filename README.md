docker-petalinux
=============

[Petalinux](https://www.xilinx.com/products/design-tools/embedded-software/petalinux-sdk.html): The PetaLinux Tools offers everything necessary to customize, build and deploy Embedded Linux solutions on Xilinx processing systems. Tailored to accelerate design productivity, the solution works with the Xilinx hardware design tools to ease the development of Linux systems for Versal, Zynq® UltraScale+™ MPSoC, Zynq®-7000 SoCs, and MicroBlaze™.

Based on [Microdent's Petalinux Docker](https://github.com/Microdent/Petalinux)

Build
-----

To create the image `xanderhendriks/petalinux`, execute the following command in the
`docker-petalinux` folder:

    docker build --build-arg USER=[Xilinx Account Username] --build-arg PASSWORD=[Xilinx Account Password] -t xanderhendriks/petalinux .

You can now push the new image to the public registry:
    
    docker push xanderhendriks/petalinux

A demo to use petalinux in docker

Run
---

    $ docker pull xanderhendriks/petalinux

    $ docker run -it -v /YOUR_LOCAL_PATH:/DOCKER_PATH --privileged xanderhendriks/petalinux
