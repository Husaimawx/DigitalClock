module m_60(clk,rst,ql,qh,count);//模60计数器
	input clk,rst;
	output[3:0] ql;
	output[3:0] qh;
	output reg count;
	reg[3:0] ql;
	reg[3:0] qh;
	
always@(posedge clk or posedge rst)
	begin
		if(rst)//清零
			begin
				ql<=0;
				qh<=0;
			end
		else if(ql==9)
		begin
			ql<=0;
			if(qh==5)
			begin
				qh<=0;
				count<=1;//进位
			end
			else
			begin
				qh<=qh+1;
				count<=0;
			end
		end
		else 
		begin
			ql<=ql+1;
			count<=0;
		end
	end
endmodule