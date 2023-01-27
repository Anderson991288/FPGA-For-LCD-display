
`timescale 1ns / 1ps

module VGA_GEN(

input   wire			      clk,
input	wire			  rst_n,
output	wire			  vga_clk,
output	wire			  vpg_de,
output 	wire 			  vpg_disp,
output	reg			      vga_hs,
output	reg			      vga_vs,
output	reg      [23:0]	  rgb  
   	
);

parameter       HS_TOTAL =525 - 1;
parameter       HS_SYNC = 3 - 1;
parameter       HS_START = 43 - 1;
parameter       HS_END = 523 - 1;
parameter       V_TOTAL = 286 - 1;
parameter       V_SYNC =3 - 1;
parameter       V_START = 12 - 1;
parameter       V_END = 284 - 1;
parameter       SQUARE_X    =   150;
parameter       SQUARE_Y    =   150;
parameter       SCREEN_X    =   480;
parameter       SCREEN_Y    =   272;



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
    
always @(posedge vga_clk )
	begin
		if (rst==1'b1) 
		begin
		cnt_h <= 'd0;
		end
		
	else if (cnt_h == HS_TOTAL) 	
		begin
		cnt_h <= 'd0;
		end
		
	else if(cnt_h != HS_TOTAL) 
		begin
		cnt_h <= cnt_h + 1'b1;
		end
end


always @(posedge vga_clk )
	begin
	if (rst==1'b1) 
		begin
		cnt_v <='d0;
		end
		
	else if (cnt_v == V_TOTAL && cnt_h == HS_TOTAL) 
		begin
		cnt_v <= 'd0;
		end
		
	else if(cnt_h == HS_TOTAL) 
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
always @(posedge vga_clk ) 
	begin
	if (rst==1'b1) 
		begin
		rgb <='d0;
		end
	
	else if(cnt_h >=HS_START+x && cnt_h <=HS_START+SQUARE_X+x && cnt_v >=V_START+y && cnt_v <=V_START+SQUARE_Y+y)
		begin
		rgb <= 24'hFFB6C1;
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
