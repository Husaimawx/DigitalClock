module s_1(clk,out_1,cset);//50M��Ƶ��
	input clk,cset;
	integer b;
	output out_1;
	reg out_1;
	parameter m=49999999; 
	
	always @(posedge clk & cset==0)//��Ƶ��ʹ�ܿ���
	  begin
			if(b==m)
			  begin
			    out_1<=1;
			    b<=0;
			  end
			else
			  begin
			 	out_1<=0; 
				b<=b+1;
			  end
	  end
endmodule