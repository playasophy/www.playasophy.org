---
layout: page
title: "WonderDome"
sharing: true
footer: true
---
The WonderDome is an LED-based art project begun in 2013.
There are six LED strips, each 5 meters long and containing 240 LEDs.
Each LED is independently addressable and supports 24-bit RGB color.
The WonderDome runs [Processing](http://processing.org) on a small ARM-based Linux computer to generate the visual effects.


## To-Do
The project is currently in progress, and a lot of work remains to be done!
This section gives a breakdown of the tasks in the various areas of the project.

### Hardware
- decide on a layout for the LED strips
- select and buy ~31 meters of 1" ID tubing to encase the LED strips in
- construct enclosure to secure and protect the electronics
- determine max length from electronics to the PP and construct a combined power/ethernet cable

### Software
- create user account for WD software
- install Processing on the CB
- test headless Processing rendering to LEDs
- set up [repository](https://github.com/mvxcvi/wonderdome) for source code
- determine how to build/deploy processing and control panel to the WD user
- reliability engineering - keep web server and processing alive while CB is on

### Inputs
- test USB microphone for sensitivity/pickup
- look into LeapMotion library and Processing integration
- construct non-phone mechanism for basic interaction with the WD (gestures?)
- design system to pass input data from phones (ideally JS) to Processing

### Visualizations
- design/implement input interfaces
- design/implement rendering interfaces
- utility sketch to turn off the LEDs
- utility sketch for full white LEDs
- utility sketch to draw a test pattern (run at startup to fix slow first rendering)

### Control Panel
- set up Rails(?) site to provide admin controls to the WD
- "remote" page which offers buttons, sliders, captures accellerometer, etc


## Hardware
The hardware making up the WonderDome can be broken down into four categories: power, networking, computing, and display.

### Power
- [300W 120V AC/5V DC Power Supply](https://illuminationsupply.com/pixelpusher-amp-led-strips-c-45/tdk-lambda-sws3005-300w-5v-enclosed-power-supply-for-pixelpusher-led-strips-p-275.html)
- [200W 12V DC/5V DC Converter](http://www.ebay.com/itm/171002548980?ssPageName=STRK:MEWNX:IT&_trksid=p3984.m1497.l2649)
- [15W 12V DC/5V DC Dual-USB Converter](http://www.amazon.com/gp/product/B00CP0PCUQ)
- [12AWG Zip Wire](https://illuminationsupply.com/pixelpusher-amp-led-strips-c-45/12awg-zip-wire-1-foot-p-609.html) (30 feet)
- [Anderson PowerPole Connectors](https://illuminationsupply.com/pixelpusher-amp-led-strips-c-45/anderson-powerpole-set-for-pixelpusher-p-607.html) (6)
- [3' USB to Type M Barrel 5V Power Cable](http://www.amazon.com/gp/product/B003MQO96U)

### Networking
- [5-port 10/100 Ethernet Switch](http://www.amazon.com/gp/product/B000M2TAN4)
- [3' Cat-5e Ethernet Cable](http://www.amazon.com/gp/product/B000067REN) (2)
- 20' Cat-5e Ethernet Cable (?)

### Computing
- [CubieBoard (1GB)](https://store.iotllc.com/product.php?productid=2)
- [USB Microphone](http://www.amazon.com/gp/product/B0052SBAEU)

### Display
- [Heroic Robotics PixelPusher](https://illuminationsupply.com/pixelpusher-amp-led-strips-c-45/heroic-robotics-pixelpusher-p-606.html)
- [PixelPusher LPD8806 RGB LED Strip, IP67 silicone sleeved](https://illuminationsupply.com/pixelpusher-amp-led-strips-c-45/pixelpusher-lpd8806-rgb-led-strip-ip67-silicone-sleeved-p-286.html) (6)


## References
This section contains links to other references related to the project.

### Hardware
- [American wire gauge (AWG)](http://en.wikipedia.org/wiki/American_wire_gauge)
- [AC power supply spec sheet](http://www.tdk-lambda.com/products/sps/ps_unit/sws/pdf/sws300_spc.pdf)

### PixelPusher
- [Heroic Robotics Forum](http://forum.heroicrobotics.com/)
- [How to Push Pixels](https://sites.google.com/a/heroicrobot.com/pixelpusher/home/getting-started)
- [Programming the PixelPusher](https://docs.google.com/document/d/1D3tlMd0-H1p7Nmi4XtdEq_6MiXMoZ2Fhey-4_rigBz4/edit)

### Processing
- [How to Install a Contributed Library](http://wiki.processing.org/w/How_to_Install_a_Contributed_Library)
- [Processing Library Basics](https://github.com/processing/processing/wiki/Library-Basics)
