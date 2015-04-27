module dec7seg(hex,a,b,c,d,e,f,g);
	
	input [3:0]hex;
	output a,b,c,d,e,f,g;
	reg [6:0]segment;
	
	always@(hex)
		case(hex)
			4'b 0000: segment = 7'b 0000001; 
			4'b 0001: segment = 7'b 1001111; 
			4'b 0010: segment = 7'b 0010010; 
			4'b 0011: segment = 7'b 0000110; 
			4'b 0100: segment = 7'b 1001100; 
			4'b 0101: segment = 7'b 0100100; 
			4'b 0110: segment = 7'b 0100000; 
			4'b 0111: segment = 7'b 0001111; 
			4'b 1000: segment = 7'b 0000000; 
			4'b 1001: segment = 7'b 0001100; 
			4'b 1010: segment = 7'b 0001000; 
			4'b 1011: segment = 7'b 1100000; 
			4'b 1100: segment = 7'b 0110001; 
			4'b 1101: segment = 7'b 1000010; 
			4'b 1110: segment = 7'b 0110000; 
			4'b 1111: segment = 7'b 0111000;
			default : segment = 7'b 0110110; 
		endcase
	
		wire a=segment[6];
		wire b=segment[5];
		wire c=segment[4];
		wire d=segment[3];
		wire e=segment[2];
		wire f=segment[1];
		wire g=segment[0];
		
endmodule
