`timescale 1ns / 1ps

module system( select, d, q, t );

input[1:0] select;
input[3:0] d;
input 	t;
output     q;

wire      q;
wire[1:0] select;
wire[3:0] d;

assign q = (d[select] & t); 

endmodule


