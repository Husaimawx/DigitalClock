module LcdWord(X,Y);
	input[3:0] X;
	output reg[7:0] Y;

	always@(X)
	begin
		case(X)
			4'b0000:Y<=8'b00110000;
			4'b0001:Y<=8'b00110001;
			4'b0010:Y<=8'b00110010;
			4'b0011:Y<=8'b00110011;
			4'b0100:Y<=8'b00110100;
			4'b0101:Y<=8'b00110101;
			4'b0110:Y<=8'b00110110;
			4'b0111:Y<=8'b00110111;
			4'b1000:Y<=8'b00111000;
			default:Y<=8'b00111001;
		endcase
	end
	
endmodule