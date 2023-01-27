# FPGA For LCD Display

* * *

There are many standards for the display of computer display area, the common ones are VGA, SVGA, etc. Here we use VGA interface to control the monitor, VGA stands for Video Graphics Array, which means video graphics array. VGA stands for Video Graphics Array.



It is widely used as a standard display interface. Common color displays are generally composed of CRT (cathode ray tube), and the colors are composed of R, G, B (red, yellow, blue). Yellow and blue). The display is solved by progressive scanning, the cathode ray gun emits an electron beam to hit on a phosphor-coated phosphor screen to produce RGB trichromes, which are combined into a color pixel. Scanning starts at the top left, from left to right, top to bottom, scanning, and after each line, the electron beam returns to the screen's The CRT fades the electron beam during this time.


At the end of each line, the beam is synchronized with the line synchronization signal at the end of each line; after scanning all the lines, the field synchronization signal is used to synchronize and bring the scan back to the top left of the screen. At the end of each line, the CRT is synchronized with the line synchronization signal; after scanning all lines, the CRT is synchronized with the field synchronization signal, and the scan returns to the top left of the screen.
For a normal VGA display, there are five signals: R, G, and B; HS (line sync signal); VS (field sync signal). signal); and VS (field synchronization signal).
For the timing driver, the VGA monitor should strictly follow the "VGA" industry standard. We choose the resolution of 1920x1080@60Hz mode.
Usually the monitors we use meet the industrial Therefore, we design the VGA controller with reference to the technical specifications of the monitor.




The time to complete a line scan is called horizontal scan time, and its inverse is called line frequency; the time to complete a frame (the whole screen) scan is called vertical scan time, and its inverse is called field frequency, that is, the frequency of refreshing a screen, commonly 60Hz, 75Hz, etc. The standard display field frequency is 60Hz.


* * *

![Screenshot 2023-01-27 165147](https://user-images.githubusercontent.com/68816726/215047836-3769d0ab-b09c-41ad-82f6-e68774740646.png)


Clock frequency: 1024x768@59.94Hz(60Hz) for example, each field corresponds to 806 line cycles, of which 768 are display lines. Each display line includes 1344 clock points, of which 1024 points for the effective display area.

### It can be seen: the need for point clock frequency:806 * 1344 * 60 about 65MHz

VGA scanning, the basic element is line scan, multiple lines form a frame, the following figure shows the timing of a line, where "Active" Video is the active pixels of a line of video, most of the resolution clock Top/Left Border and Bottom/Right Border are 0.
Blanking" is the synchronization time of a line, the "Blanking" time plus the "Active" Video time is the time of a line. "Blanking" is divided into "Front Porch", "Sync" and "Back Porch "Back Porch".



![20210201205043407](https://user-images.githubusercontent.com/68816726/215064972-32632ddc-4250-4ffc-bdd3-5ba7f4ec7b7f.png)



![20210201205105610](https://user-images.githubusercontent.com/68816726/215064994-57432683-5fcd-4319-bd35-d3d1dafabc8a.png)


![Screenshot 2023-01-27 183150](https://user-images.githubusercontent.com/68816726/215065857-fd70be30-f44e-4372-9700-b6fe1c988296.png)


![VS](https://user-images.githubusercontent.com/68816726/215065863-ffdac18c-22c4-449e-bf9e-7112c6c11d70.png)


