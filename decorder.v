module decorder(a,Y);//4£¬7ÒëÂëÆ÷
	input[3:0] a;
	output[6:0] Y;
	reg[6:0] Y;
	always@(a)
	begin
		case(a)
			4'b0000:Y<=7'b1000000;
			4'b0001:Y<=7'b1111001;

			4'b0010:Y<=7'b0100100;
			4'b0011:Y<=7'b0110000;
			4'b0100:Y<=7'b0011001;

			4'b0101:Y<=7'b0010010;
			4'b0110:Y<=7'b0000010;
			4'b0111:Y<=7'b1111000;

			4'b1000:Y<=7'b0000000;
			4'b1001:Y<=7'b0010000;
			default:Y<=7'bz;
		endcase
	end
endmodule