module clk_s2(clk,clk_2);//2Ãë·ÖÆµÆ÷
	input clk;
	output clk_2;
	reg a,clk_2;
	always@(posedge clk)
	begin
		if(a==1)
		 begin
			a <= 0;
			clk_2 <=1;
		 end
		else
		 begin
			a <= 1;
			clk_2 <=0;
		 end
	end
endmodule