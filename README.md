# FPGA For LCD Display




* * *

There are many standards for the display of computer display area, the common ones are VGA, SVGA, etc. Here we use VGA interface to control the monitor, VGA stands for Video Graphics Array, which means video graphics array. VGA stands for Video Graphics Array.



It is widely used as a standard display interface. Common color displays are generally composed of CRT (cathode ray tube), and the colors are composed of R, G, B (red, yellow, blue). Yellow and blue). The display is solved by progressive scanning, the cathode ray gun emits an electron beam to hit on a phosphor-coated phosphor screen to produce RGB trichromes, which are combined into a color pixel. Scanning starts at the top left, from left to right, top to bottom, scanning, and after each line, the electron beam returns to the screen's The CRT fades the electron beam during this time.


At the end of each line, the beam is synchronized with the line synchronization signal at the end of each line; after scanning all the lines, the field synchronization signal is used to synchronize and bring the scan back to the top left of the screen. At the end of each line, the CRT is synchronized with the line synchronization signal; after scanning all lines, the CRT is synchronized with the field synchronization signal, and the scan returns to the top left of the screen.
For a normal VGA display, there are five signals: R, G, and B; HS (line sync signal); VS (field sync signal). signal); and VS (field synchronization signal).
For the timing driver, the VGA monitor should strictly follow the "VGA" industry standard. We choose the resolution of  1024x768@60Hz mode.
Usually the monitors we use meet the industrial Therefore, we design the VGA controller with reference to the technical specifications of the monitor.




The time to complete a line scan is called horizontal scan time, and its inverse is called line frequency; the time to complete a frame (the whole screen) scan is called vertical scan time, and its inverse is called field frequency, that is, the frequency of refreshing a screen, commonly 60Hz, 75Hz, etc. The standard display field frequency is 60Hz.


* * *

![Screenshot 2023-01-27 165147](https://user-images.githubusercontent.com/68816726/215047836-3769d0ab-b09c-41ad-82f6-e68774740646.png)


Clock frequency: 1024x768@59.94Hz(60Hz) for example, each field corresponds to 806 line cycles, of which 768 are display lines. Each display line includes 1344 clock points, of which 1024 points for the effective display area.

### It can be seen: the need for point clock frequency:806 * 1344 * 60 about 65MHz

VGA scanning, the basic element is line scan, multiple lines form a frame, the following figure shows the timing of a line, where "Active" Video is the active pixels of a line of video, most of the resolution clock Top/Left Border and Bottom/Right Border are 0.
Blanking" is the synchronization time of a line, the "Blanking" time plus the "Active" Video time is the time of a line. "Blanking" is divided into "Front Porch", "Sync" and "Back Porch "Back Porch".


# Simulation:

![HS](https://user-images.githubusercontent.com/68816726/215075026-8d868f39-69fd-4f94-8cf9-611e98945a84.png)


![VS](https://user-images.githubusercontent.com/68816726/215075031-99c38b60-466d-4d4a-8c89-d84cc0e5862b.png)


* * *
- - -



# HDMI output color bar experiment
## Introduction

Previously, we have understood what VGA timing is, and have successfully driven the LCD
The display shows a simple moving square on the development board, and the audio and video signals can be directly transmitted through the FPGA pins. The FPGA pins can be used for direct audio and video signal transmission. In this experiment, the FPGA will be used to complete the HDMI output experiment. In this experiment, the FPGA will be used to output the image on an HDMI-enabled display based on the previous one. First, we need to understand the following structure of HDMI.


## Experimental principle

HDMI system architecture consists of a source side and a receiver side. A device may have one or more HDMI inputs and one or more HDMI outputs. On these devices, each HDMI input should follow the HDMI receiver side rules and each HDMI output should follow the HDMI source side rules. As shown in the diagram, the HDMI cable and connectors provide four differential pairs that make up the TMDS data and clock channels. These channels are used to pass video, audio, and auxiliary data. In addition, HDMI provides a VESA DDC channel, which is used to configure and exchange status on a separate source side and a separate receiver side. The optional CEC provides a high level of control in a variety of different audio and video products for the user. Optional HDMI Ethernet and Audio Return (HEAC) provides Ethernet-compatible network data and an audio return channel in the opposite direction of the TMDS in the connected device.



A TMDS clock, typically at the video pixel rate, is transmitted in the TMDS clock channel, which is used as a frequency reference by the receiver side for data recovery of the three TMDS data channels. At the source side, TMDS encoding converts 8 bits of data per TMDS data into a 10-bit DC-balanced minimum transform sequence, which is sent serially, at 10 bits per TMDS clock cycle, on a differential pair. Video data, one pixel can be 24, 30, 36, 48 bits. 30, 36, 48 bits. The default 24-bit depth of video is uploaded at a time equal to the pixel clock TMDS clock is delivered. Higher color depths use a correspondingly higher TMDS clock rate. Video formats with TMDS clock rates below 25M (e.g. 13.5M for 480i/NTSC) can use the repeat pixel delivery strategy. Video pixels can be encoded in RGB, YCbCr4:4:4, YCbCr4:2:2 formats.



An HDMI connection consists of three TMDS data channels, one TMDS clock channel. The TMDS clock channel runs at a constant rate proportional to the pixel rate of the video. During each TMDS clock channel cycle, the three TMDS data channels run at a constant rate proportional to the pixel rate of the video. The TMDS clock channel operates at a constant rate that is proportional to the pixel rate of the video. This 10-bit word is encoded, using some different encoding technique. The input stream to the source contains video pixels, data packets, and control data. The data packets include audio data and auxiliary and associated error correction codes. These data items are processed differently and represented in the TMDS encoder for each TMDS channel as either 2 bits of control data, or 4 bits of message data, and
or 4 bits of telegram data, or 8 bits of video data. The source side encodes these data types in each clock cycle, or encodes a boundary data type. The source side encodes these data types or encodes a boundary character in each clock cycle.


![VGA](https://user-images.githubusercontent.com/68816726/215316579-136f1ded-d044-4b62-874c-baecddf5b6f7.png)

This experiment requires the use of a third-party IP, which can be found on github.

Link: https://github.com/Digilent/vivado-library

Click clone to download files from other users' repositories to your local. Once downloaded locally, we can add the third-party IP to the Vivado project, and then the user can use the third-party IP.

Create a new ip_repo folder in the project directory to store third-party IPs, and assign the required IPs mentioned earlier to this folder. Copy the required IP and if folder to ip_repo. 

![Screenshot 2023-01-29 171835](https://user-images.githubusercontent.com/68816726/215316950-1519ab1c-d8e0-48e2-94d1-4249d41c7fe9.png)


![image](https://user-images.githubusercontent.com/68816726/215320755-a6e09010-f066-4f88-a176-7ba074eccd65.png)
