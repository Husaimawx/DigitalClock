module LED_1(clk,clk_2,en,led1,led2,led3,led4,led5,led6,led7,led8);//使能后按照额定显示
	input en;
	input clk,clk_2;
	reg a;
	output led1,led2,led3,led4,led5,led6,led7,led8;
	reg led1,led2,led3,led4,led5,led6,led7,led8;
	always@(posedge clk)
		begin
			if(en&&(clk_2==0))
				begin
					led1=1;
					led2=1;
					led3=1;
					led4=1;
					led5=1;
					led6=1;
					led7=1;
					led8=1;
				end
			else
				begin
					led1=0;
					led2=0;
					led3=0;
					led4=0;
					led5=0;
					led6=0;
					led7=0;
					led8=0;
				end
		end
	
endmodule