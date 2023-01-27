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



VGA_GEN.v


```

`timescale 1ns / 1ps

module VGA_GEN(

input   wire			  clk,      
input	wire			  rst_n,     
output	wire			  vga_clk,	 
output	wire			  vpg_de,
output 	wire 			  vpg_disp,
output	reg			      vga_hs,
output	reg			      vga_vs,
output	reg      [23:0]	  rgb  
   	
);

parameter       HS_TOTAL = 525 - 1; //Total number of values to count in a row
parameter       HS_SYNC = 41 - 1;   // line synchronization count value
parameter       HS_START = 43 - 1;	//Row image data valid start count value
parameter       HS_END = 523 - 1;   //Valid end count value for line image data
parameter       V_TOTAL = 286 - 1;  //The total number of values to be counted in the field
parameter       V_SYNC = 10 - 1;    //Field synchronization count value
parameter       V_START = 12 - 1;   //Field image data valid start count value
parameter       V_END = 284 - 1;    //Field image data valid end count value
parameter       SQUARE_X    =   150; //Width of the square
parameter       SQUARE_Y    =   150; //Length of the square
parameter       SCREEN_X    =   480; //Screen horizontal length
parameter       SCREEN_Y    =   272; //Screen vertical length



wire 		rst;
reg [12:0]	cnt_h;
reg [12:0]	cnt_v;
reg [11:0]	x;
reg 		flag_x;
reg [11:0]	y;
reg 		flag_y;
wire        locked1;       


assign vpg_disp = 1'b1;
assign rst = ~rst_n;

 clk_wiz_0 clock(
    .clk_out1(vga_clk),    
    .reset(rst), 
    .locked(locked1),     
    .clk_in1(clk));     
    
always @(posedge vga_clk )    // Line counter
	begin
		if (rst==1'b1) 
		begin
		cnt_h <= 'd0;
		end
		
	else if (cnt_h == HS_TOTAL) // Count to maximum value, clear zero	
		begin
		cnt_h <= 'd0;
		end
		
	else if(cnt_h != HS_TOTAL) //Has not counted to the maximum value, plus one every clock cycle
		begin
		cnt_h <= cnt_h + 1'b1;
		end
end


always @(posedge vga_clk )     //Field Counter
	begin
	if (rst==1'b1) 
		begin
		cnt_v <='d0;
		end
		
	else if (cnt_v == V_TOTAL && cnt_h == HS_TOTAL)//Field counter counts to maximum value. Clear zero(end of a frame)
		begin
		cnt_v <= 'd0;
		end
		
	else if(cnt_h == HS_TOTAL) // At the end of a line scan, the field counter is added by one
	begin
		cnt_v <= cnt_v + 1'b1;
	end
	
end


always @(posedge vga_clk ) 
	begin
	if (rst==1'b1) 
		begin
		vga_hs <= 1'b1;
		end
		
	else if (cnt_h == HS_TOTAL) 	
		begin
		vga_hs <= 1'b1;
		end
		
	else if (cnt_h == HS_SYNC) 
		begin
		vga_hs <= 1'b0;
		end
end


always @(posedge vga_clk ) 
	begin
	if (rst==1'b1) 
		begin
		vga_vs <= 1'b1;
		end
		
	else if (cnt_v == V_TOTAL && cnt_h == HS_TOTAL) 
		begin
		vga_vs <= 1'b1;
		end 
		
	else if (cnt_v == V_SYNC && cnt_h == HS_TOTAL) 
		begin
		vga_vs <=  1'b0;
		end
		
end


always @(posedge vga_clk ) 
	begin
	if (rst==1'b1) 
		begin
		x <='d0;
		end
	
	else if (flag_x == 1'b0 && cnt_v == V_TOTAL && cnt_h == HS_TOTAL) 
		begin
		x <= x + 1'b1;
		end
		
	else if(flag_x == 1'b1 && cnt_v == V_TOTAL && cnt_h == HS_TOTAL) 
		begin
		x <= x - 1'b1;
		end
end


always @(posedge vga_clk ) 
	begin
	if (rst==1'b1) 
		begin
		flag_x <= 1'b0;
		end
		
	else if (flag_x == 1'b0 && cnt_v ==V_TOTAL && cnt_h == HS_TOTAL && x==(HS_END - HS_START - SQUARE_X - 1'b1)) 
		begin
		flag_x <= 1'b1;
		end
	
	else if (flag_x == 1'b1 && cnt_v ==V_TOTAL && cnt_h == HS_TOTAL && x=='d1) 
		begin
		flag_x <= 1'b0;
		end
end


always @(posedge vga_clk ) 
	begin
	if (rst==1'b1) 
		begin
		y <= 'd0;
		end
	
	else if (flag_y == 1'b0 && cnt_v ==V_TOTAL && cnt_h == HS_TOTAL) 
		begin
		y <= y + 1'b1;
		end
		
	else if (flag_y == 1'b1 && cnt_v ==V_TOTAL && cnt_h == HS_TOTAL) 
		begin
		y <= y - 1'b1;
		end
end


always @(posedge vga_clk )
	begin
	if (rst==1'b1)
		begin
		flag_y <= 1'b0;
		end
	else if (flag_y == 1'b0 && cnt_v ==V_TOTAL && cnt_h == HS_TOTAL && y==(V_END - V_START - SQUARE_Y - 1'b1)) 
		begin
		flag_y <= 1'b1;
		end
	else if (flag_y == 1'b1 && cnt_v ==V_TOTAL && cnt_h == HS_TOTAL && y=='d1 ) 
		begin
		flag_y <= 1'b0;
		end
end



//RGB
//The value of the output image is determined according to the value of the counter.
//The moving squares are grayed out.In the rest of the cases, the background color red, green and blue is displayed.

always @(posedge vga_clk ) 
	begin
	if (rst==1'b1) 
		begin
		rgb <='d0;
		end
	
	else if(cnt_h >=HS_START+x && cnt_h <=HS_START+SQUARE_X+x && cnt_v >=V_START+y && cnt_v <=V_START+SQUARE_Y+y)
		begin
		rgb <= 24'hFFB6C1;   //output square image
		end
		
	else if (cnt_h >=HS_START && cnt_h <HS_END && cnt_v >=V_START && cnt_v <V_END && cnt_h[4:0]>='d20) 
		begin
		rgb <=24'h00FF00;//green
		end
		
	else if (cnt_h >=HS_START && cnt_h <HS_END && cnt_v >=V_START && cnt_v <V_END && (cnt_h[4:0]>='d10 && cnt_h[2:0]<'d20)) 
		begin
		rgb <=24'h0000FF;//blue
		end
		
	else if (cnt_h >=HS_START && cnt_h <HS_END && cnt_v >=V_START && cnt_v <V_END && cnt_h[4:0]<'d10) 
		begin
		rgb <=24'hFF0000;//red
		end
		
	else begin
		rgb <= 'd0;
		end
		
	end

assign  vpg_de = (cnt_h >= HS_START) && (cnt_h < HS_END) && (cnt_v >= V_START) && (cnt_v < V_END);

endmodule


```


testbench:


```
module tb();
parameter       HS_TOTAL = 525 - 1;
parameter       HS_SYNC = 41 - 1;
parameter       HS_START = 43 - 1;
parameter       HS_END = 523 - 1;
parameter       V_TOTAL = 286 - 1;
parameter       V_SYNC = 10 - 1;
parameter       V_START = 12 - 1;
parameter       V_END = 284 - 1;
parameter       SQUARE_X    =   150;
parameter       SQUARE_Y    =   150;
parameter       SCREEN_X    =   480;
parameter       SCREEN_Y    =   272;

reg rst_n;
reg clk;

wire vga_clk;
wire vpg_de;
wire vpg_disp;
wire vga_hs;
wire vga_vs;
wire rgb  ; 


VGA_GEN #(

)
inst_VGA_GEN (
.clk (clk),
.rst_n (rst_n),
.vga_hs(vga_hs),
.vga_vs(vga_vs),
.vga_clk (vga_clk),
.vpg_de(vpg_de),
.rgb(rgb)
);

initial begin
clk = 0;
forever #(10) clk = ~clk;
end
initial begin
rst_n = 0;
#100;
rst_n = 1;
end
endmodule
```

![Screenshot 2023-01-27 162305](https://user-images.githubusercontent.com/68816726/215040795-66658586-1946-4678-b00e-1049b76de3e5.png)

