module COORDENADAS(x,y,seg0,seg1,seg2,seg3,seg4,seg5,todo0,todo1);
input [11:0]x,y;
output [6:0]seg0,seg1,seg2,seg3,seg4,seg5,todo0,todo1;

wire [3:0]hex0,hex1,hex2,hex3,hex4,hex5;


assign hex3 = x[3:0];
assign hex4 = x[7:4];
assign hex5 = x[11:8];

assign hex0 = y[3:0];
assign hex1 = y[7:4];
assign hex2 = y[11:8];


assign todo0 = 7'b1110001; 
assign todo1 = 7'b1110001;

dec7seg d0
(
	.hex(hex0) ,
	.a(seg0[6]) ,
	.b(seg0[5]) ,
	.c(seg0[4]) ,
	.d(seg0[3]) ,
	.e(seg0[2]) ,
	.f(seg0[1]) ,
	.g(seg0[0])
);

dec7seg d1
(
	.hex(hex1) ,
	.a(seg1[6]) ,
	.b(seg1[5]) ,
	.c(seg1[4]) ,
	.d(seg1[3]) ,
	.e(seg1[2]) ,
	.f(seg1[1]) ,
	.g(seg1[0])
);

dec7seg d2
(
	.hex(hex2) ,
	.a(seg2[6]) ,
	.b(seg2[5]) ,
	.c(seg2[4]) ,
	.d(seg2[3]) ,
	.e(seg2[2]) ,
	.f(seg2[1]) ,
	.g(seg2[0])
);

dec7seg d3
(
	.hex(hex3) ,
	.a(seg3[6]) ,
	.b(seg3[5]) ,
	.c(seg3[4]) ,
	.d(seg3[3]) ,
	.e(seg3[2]) ,
	.f(seg3[1]) ,
	.g(seg3[0])
);

dec7seg d4
(
	.hex(hex4) ,
	.a(seg4[6]) ,
	.b(seg4[5]) ,
	.c(seg4[4]) ,
	.d(seg4[3]) ,
	.e(seg4[2]) ,
	.f(seg4[1]) ,
	.g(seg4[0])
);

dec7seg d5
(
	.hex(hex5) ,
	.a(seg5[6]) ,
	.b(seg5[5]) ,
	.c(seg5[4]) ,
	.d(seg5[3]) ,
	.e(seg5[2]) ,
	.f(seg5[1]) ,
	.g(seg5[0])
);
endmodule 
 
