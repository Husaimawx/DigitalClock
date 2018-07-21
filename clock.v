module clock(clk_1,en,out_Hh,out_Hl,out_mh,out_ml,A,B,C,D,Hh,Hl,Mh,Ml);
	input clk_1;
	input[3:0] out_Hh,out_Hl,out_mh,out_ml;
	input A,B,C,D;
	output reg en;
	output[3:0] Hh,Hl,Mh,Ml;
	reg[3:0] Hh=0,Hl=0,Mh=0,Ml=0;
	
	always@(posedge A)
		begin
				if(A)
					begin
						if(Hh==4'b0010)
							Hh<=0;
						else if(Hh==4'b0000)
							Hh<=4'b0001;
						else 
							Hh<=4'b0010;	
					end
		end
		
	always@(posedge B)
	begin
		if(B)
				begin
					if(Hl==4'b0011)
						Hl<=0;
					else
						Hl<=Hl+1'b1;	
				end
	end
	always@(posedge C)
	begin
		if(C)
				begin
					if(Mh==4'b0101)
						Mh<=0;
					else
						Mh<=Mh+1'b1;	
				end
	end
	always@(posedge D)
	begin
		if(D)
				begin
					if(Ml==4'b1001)
						Ml<=0;
					else
						Ml<=Ml+1'b1;	
				end
	end
		
	always@(clk_1)
		begin
			if((out_Hh==Hh)&&(out_Hl==Hl)&&(out_mh==Mh)&&(out_ml==Ml))//可以先不用用来测试好不好使
				en<=1;//满足时分等于预设条件时使out为1，讲out连于led可实现提示
			else 
				en<=0;
		end
		
		
endmodule
