module backclock(clr,clk,H_SET,M_SET,S_SET,EN,H_h,H_l,M_h,M_l,S_h,S_l,out);
	input H_SET,M_SET,S_SET,EN,clk,clr;
	output reg [3:0]H_h,H_l,M_h,M_l,S_h,S_l;	
	output reg out;
	wire rclk;
	
	assign rclk=(clk && EN && !clr) || (M_SET && !EN && !S_SET && !H_SET &&!clr) || (S_SET && !EN && !M_SET && !H_SET && !clr) || (H_SET && !EN && !S_SET && !M_SET && !clr) || clr;
	
	always@(posedge rclk)
		begin
			if(clr)//清零
			begin
				S_l<=0;
				S_h<=0;
				M_l<=0;
			    M_h<=0;	
				H_l<=0;
			    H_h<=0;
			end
			else if(clk)//倒计时模块
			begin
				if(EN)
				begin
					if(S_l==0)
					begin
						S_l<=9;
						if(S_h==0)
						begin
							S_h<=5;
							if(M_l==0)
							begin
								M_l<=9;
								if(M_h==0)
								begin
									M_h<=5;
									if(H_l==0)
									begin
										H_l<=9;
										if(H_h==0)
										begin
											out<=1;
											S_l<=0;
											S_h<=0;
											M_l<=0;
										    M_h<=0;	
											H_l<=0;
										    H_h<=0;
										end
										else
										begin
											H_h<=H_h-1;	
											out<=0;
										end
									end
									else
									begin
										H_l<=H_l-1;	
										out<=0;
									end
								end
								else
								begin
									M_h<=M_h-1;	
									out<=0;
								end	
							end
							else
							begin
								M_l<=M_l-1;	
								out<=0;
							end
						end
						else
						begin
							S_h<=S_h-1;
							out<=0;
						end	
					end
					else
					begin
						S_l<=S_l-1;
						out<=0;
					end
				 end
				 else
				 begin
				 end
			end	
			
			else if(H_SET)//小时置数
			begin
				if(H_l==9)
				begin
					H_l<=0;
					if(H_h==9)
						H_h<=0;
					else
						H_h<=H_h+1;
				end
				else
					H_l<=H_l+1;
			end
				
			else if(M_SET)//分钟置数
			begin
				if(M_l==9)
				begin
					M_l<=0;
					if(M_h==5)
						M_h<=0;
					else
						M_h<=M_h+1;
				end
				else
					M_l<=M_l+1;
			end
			
			else if(S_SET)//秒置数
			begin
				if(S_l==9)
				begin
					S_l<=0;
					if(S_h==5)
						S_h<=0;
					else
						S_h<=S_h+1;
				end
				else
					S_l<=S_l+1;
			end
		end
endmodule