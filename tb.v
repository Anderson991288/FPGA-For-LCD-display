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
