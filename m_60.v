module m_60(clk,rst,ql,qh,count);//ģ60������
	input clk,rst;
	output[3:0] ql;
	output[3:0] qh;
	output reg count;
	reg[3:0] ql;
	reg[3:0] qh;
	
always@(posedge clk or posedge rst)
	begin
		if(rst)//����
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
				count<=1;//��λ
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