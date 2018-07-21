module m_24(clk,rst,ql,qh,count);//模24计数器
	input clk,rst;
	output[3:0] ql;
	output[3:0] qh;
	output count;
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
				qh<=qh+1;
			end
		else if(qh==2&&ql==3)
			begin
				ql<=0;
				qh<=0;
			end
		else
			ql<=ql+1;
	end

assign count=(qh==2 & ql==3)?1:0;//进位表示

endmodule