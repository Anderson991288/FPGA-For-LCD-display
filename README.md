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






# HDMI output color bar experiment

Previously, we have understood what VGA timing is, and have successfully driven the LCD
The display shows a simple moving square on the development board, and the audio and video signals can be directly transmitted through the FPGA pins. The FPGA pins can be used for direct audio and video signal transmission. In this experiment, the FPGA will be used to complete the HDMI output experiment. In this experiment, the FPGA will be used to output the image on an HDMI-enabled display based on the previous one. First, we need to understand the following structure of HDMI.
