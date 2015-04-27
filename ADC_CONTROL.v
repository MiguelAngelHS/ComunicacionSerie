// Nombre del archivo: ADC_CONTROL.v
//
// DescripciOn: Este codigo   nos permite btener las coordenadas X e Y del punto de la
//	pantalla que toquemos y representar las coordenadas por el 7 segmentos en hexadecimal. 
// incluye un decodificador 7 segmentos y un modulo para mostrar las coordenadas
//			Las seÃ±ales son las siguientes:
//
//			-iCLK: la seÃ±al de reloj 
//			-iRST_n:reset 
//			-oADC_DIN: byte de control 
//			-oADC_DCLK: es el reloj que utilizaremos para la pantalla
//			-oADC_CS: enable.
//			-iADC_DOUT: seÃ±al de entrada que contenga las coordenadas.
//			-iADC_PENIRQ_n: seÃ±al activa a nivel bajo, que se pone a nivel bajo a tocar la pantalla
//			-oX_COORD: es la seÃ±al de salida donde se almacenarÃ¡ la coordenada X 
//			-oY_COORD: es la seÃ±al de salida donde se almacenarÃ¡ la coordenada Y 
//			 
//----------------------------------------------------------------------------------

module ADC_CONTROL(
					iCLK,
					iRST_n,
					oADC_DIN,
					oADC_DCLK,
					oADC_CS,
					iADC_DOUT,
					iADC_BUSY,
					iADC_PENIRQ_n,
					oTOUCH_IRQ,
					oX_COORD,
					oY_COORD,
					bcd0,
					bcd1,
					bcd2,
					bcd3,
					bcd4,
					bcd5,
					bcd6, 
					bcd7
					);

parameter SYSCLK_FRQ	= 50000000;  
parameter ADC_DCLK_FRQ	= 70000;  

parameter ADC_DCLK_CNT	= SYSCLK_FRQ/(ADC_DCLK_FRQ*2);

parameter control_x = 8'b10010010; 
parameter control_y = 8'b11010010;

parameter STATE1 = 0, STATE2 = 1, STATE3 = 2;


input					iCLK;
input					iRST_n;
input					iADC_DOUT;
input					iADC_PENIRQ_n;
input					iADC_BUSY;
output reg			oADC_DIN;
output reg				oADC_DCLK;
output reg				oADC_CS;
output reg				oTOUCH_IRQ;
output reg	[11:0]	oX_COORD;
output reg 	[11:0]	oY_COORD;
reg         [6:0]		contador80;
reg         [9:0]		contador70; 
reg         [2:0]		STATE;
wire 	SCEN;

output [6:0] bcd0, bcd1, bcd2, bcd3, bcd4, bcd5, bcd6, bcd7;


always @(posedge iCLK or negedge iRST_n) 
	begin 
		if (!iRST_n) 
			contador80 <= 0;
		else
			if(SCEN)
				if(contador80 == 79) 
					contador80 <= 0;
				else
					contador80 <= contador80 + 1;
	end


always @(posedge iCLK or negedge iRST_n)
begin
	if(!iRST_n) 
		contador70 <= 0;	
	else
		if(oADC_CS)
			begin
				if (contador70 == ADC_DCLK_CNT-1)
					begin
						contador70 <= 0;
						oADC_DCLK <= ~ oADC_DCLK; 
					end
			else
				contador70 <= contador70+ 1;
			end
		else
			oADC_DCLK <=0;
end
assign SCEN = (contador70== ADC_DCLK_CNT-1)? 1'b1:1'b0;






always @ (STATE) 
	begin
		case (STATE)
			
			STATE1:
			
				begin
	
				oADC_CS = 1'b0;
				end
				
			STATE2:
			
				oADC_CS = 1'b1; 
				
			STATE3:
			
				oADC_CS = 1'b1;
				
			default: 
				begin
			
				oADC_CS = 1'b0;
				end
		endcase
	end

	
	always @ (posedge iCLK or negedge iRST_n) 
	begin
		if (!iRST_n)
			STATE <= STATE1; 
		else
			case (STATE)
				STATE1:
					case (iADC_PENIRQ_n)
					0: STATE <= STATE2; 
					1: STATE<= STATE1; 
					endcase
				STATE2:
					if(contador80 == 80-1)
						STATE <= STATE3; 
					else
						STATE <= STATE2;  
				STATE3:
					if(contador80 == 0) 
					begin
						if(!iADC_PENIRQ_n) 
							STATE <= STATE2; 
						else
							STATE <= STATE1;
					end
				default:
					STATE <= STATE1;
			endcase
	end
	
	
	
	always @(posedge iCLK or negedge iRST_n)
begin
	if(!iRST_n) 
		begin
			oX_COORD <=0;
			oY_COORD <=0;
			oADC_DIN <=0;
		end
	else
	begin
		if(oADC_CS)
		begin
			case(contador80) 
				0 : oADC_DIN <= control_x[7];
				2 : oADC_DIN <= control_x[6];
				4 : oADC_DIN <= control_x[5];
				6 : oADC_DIN <= control_x[4];
				8 : oADC_DIN <= control_x[3];
				10 : oADC_DIN <= control_x[2];
				12 : oADC_DIN <= control_x[1];
				14 : oADC_DIN <= control_x[0];
				16 : oADC_DIN <= 1'b0;
				
				32 : oADC_DIN <= control_y[7];
				34 : oADC_DIN <= control_y[6];
				36 : oADC_DIN <= control_y[5];
				38 : oADC_DIN <= control_y[4];
				40 : oADC_DIN <= control_y[3];
				42 : oADC_DIN <= control_y[2];
				44 : oADC_DIN <= control_y[1];
				46 : oADC_DIN <= control_y[0];
				48 : oADC_DIN <= 1'b0;
			endcase

			case(contador80) 
				18 : oX_COORD [11] <= iADC_DOUT;
				20 : oX_COORD [10] <= iADC_DOUT;
				22 : oX_COORD [9] <= iADC_DOUT;
				24 : oX_COORD [8] <= iADC_DOUT;
				26 : oX_COORD [7] <= iADC_DOUT;
				28 : oX_COORD [6] <= iADC_DOUT;
				30 : oX_COORD [5] <= iADC_DOUT;
				32 : oX_COORD [4] <= iADC_DOUT;
				34 : oX_COORD [3] <= iADC_DOUT;
				36 : oX_COORD [2] <= iADC_DOUT;
				38 : oX_COORD [1] <= iADC_DOUT;
				40 : oX_COORD [0] <= iADC_DOUT;
				
				50 : oY_COORD [11] <= iADC_DOUT;
				52 : oY_COORD [10] <= iADC_DOUT;
				54 : oY_COORD [9] <= iADC_DOUT;
				56 : oY_COORD [8] <= iADC_DOUT;
				58 : oY_COORD [7] <= iADC_DOUT;
				60 : oY_COORD [6] <= iADC_DOUT;
				62 : oY_COORD [5] <= iADC_DOUT;
				64 : oY_COORD [4] <= iADC_DOUT;
				66 : oY_COORD [3] <= iADC_DOUT;
				68 : oY_COORD [2] <= iADC_DOUT;
				70 : oY_COORD [1] <= iADC_DOUT;
				72 : oY_COORD [0] <= iADC_DOUT;
			endcase
		end
		else
			begin
				oADC_DIN <=0;
			end
		end
	end
	
	


COORDENADAS MUESTRA (
		.x(oX_COORD) ,
		.y(oY_COORD) ,
		.todo0(bcd6) ,
		.todo1(bcd7) ,
		.seg0(bcd0) ,
		.seg1(bcd1) ,
		.seg2(bcd2) ,
		.seg3(bcd3) ,
		.seg4(bcd4) ,
		.seg5(bcd5) ,
			);
	
endmodule 
