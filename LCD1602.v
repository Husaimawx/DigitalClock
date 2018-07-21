module LCD1602(clk,rst,LCD_EN,RS,RW,DB8,LCD_ON,/*,data_row1*/out_Hhlcd,out_Hllcd,out_mhlcd,out_mllcd,out_shlcd,out_sllcd);
	/*input[127:0] data_row1,data_row2;*///第一行和第二行输入数据
	input[7:0] out_Hhlcd,out_Hllcd,out_mhlcd,out_mllcd,out_shlcd,out_sllcd;
	input   clk,rst;        //rst为全局复位信号（高电平有效）
	output  LCD_EN,LCD_ON;//LCD_EN为LCD模块的使能信号（下降沿触发）
	output  RS;//RS=0时为写指令；RS=1时为写数据
	output  RW;//RW=0时对LCD模块执行写操作；RW=1时对LCD模块执行读操作
	output reg [7:0] DB8; //8位指令或数据总线
	reg     RS,LCD_EN_Sel;
	wire[127:0] data_row1,data_row2;
	assign  LCD_ON = 1'b1;
	
	//------------------------------------//
	//输入时钟50MHz  输出周期2ms
	//division50MHz_2ms.v
	reg [15:0]count;
	reg clk_2ms;//2ms输出时钟
	always @ (posedge clk)
	begin
		if(count <16'd50_000)
			count <= count + 1'b1;
		else
		begin
			count <= 16'd1;
			clk_2ms <= ~clk_2ms;
		end
	end
	
	//---------------------------------------//

	reg     [127:0] Data_Buf;   //液晶显示的数据缓存
	reg     [4:0] disp_count;
	reg     [3:0] state;

	parameter   Clear_Lcd		  = 4'b0000, //清屏并光标复位 
	      		Set_Disp_Mode     = 4'b0001, //设置显示模式：8位2行5x7点阵   
	           	Disp_On           = 4'b0010, //显示器开、光标不显示、光标不允许闪烁
	            Shift_Down        = 4'b0011, //文字不动，光标自动右移
	            Write_Addr        = 4'b0100, //写入显示起始地址
	            Write_Data_First  = 4'b0101, //写入第一行显示的数据
	            Write_Data_Second = 4'b0110; //写入第二行显示的数据		
		
	assign  RW = 1'b0;  //RW=0时对LCD模块执行写操作(一直保持写状态）
	assign  LCD_EN = LCD_EN_Sel ? clk_2ms : 1'b0;//通过LCD_EN_Sel信号来控制LCD_EN的开启与关闭
	assign  data_row1="fzy_Digital#^_^/";
	assign  data_row2 = {{4{8'b00100000}},out_Hhlcd,out_Hllcd,{8'b00111010},out_mhlcd,out_mllcd,{8'b00111010},out_shlcd,out_sllcd,{4{8'b00100000}}};//"####HH:MM:SS####"

	always @(posedge clk_2ms or posedge rst)
	begin
		if(rst)
			begin
				state <= Clear_Lcd;  //复位：清屏并光标复位   
				RS <= 1'b1;          //复位：RS=1时为读指令；                       
				DB8 <= 8'b0;         //复位：使DB8总线输出全0
				LCD_EN_Sel <= 1'b0;  //复位：关夜晶使能信号
				disp_count <= 5'b0;
				//---------下面是测试数据------------------------//
					   //位置"0123456789abcdef“
					
			end
		else 
			begin
				case(state)         //初始化LCD模块
					Clear_Lcd:
			        begin
						LCD_EN_Sel <= 1'b1;//开使能
						RS <= 1'b0;//写指令
			            DB8 <= 8'b00000001;  //清屏并光标复位
						state <= Set_Disp_Mode;
			        end
					Set_Disp_Mode:
					begin
						DB8 <= 8'b00111000;   //设置显示模式：8位2行5x8点阵 
						state <= Disp_On;
					end
					Disp_On:
					begin
						DB8 <= 8'b00001100;   //显示器开、光标不显示、光标不允许闪烁 
						state <= Shift_Down;
					end
					Shift_Down:
					begin
						DB8 <= 8'b00000110;    //文字不动，光标自动右移    
						state <= Write_Addr;
					end
			//---------------------------------显示循环------------------------------------//		
					Write_Addr:
					begin
						RS <= 1'b0;//写指令
						DB8 <= 8'b10000000;      //写入第一行显示起始地址：第一行第1个位置    
						Data_Buf <= data_row1;     //将第一行显示的数据赋给Data_First_Buf
					//	DB8 <= Data_First_Buf[127:120];
						state <= Write_Data_First;
					end
					Write_Data_First:  //写第一行数据
					begin
						if(disp_count == 5'd16)    //disp_count等于15时表示第一行数据已写完
						begin
							RS <= 1'b0;//写指令
							DB8 <= 8'b11000000;     //送入写第二行的指令,第2行第1个位置
							disp_count <= 5'b00000; //计数清0
							Data_Buf <= data_row2;//将第2行显示的数据赋给Data_First_Buf
						//	DB8 <= Data_Second_Buf[127:120];
							state <= Write_Data_Second;   //写完第一行进入写第二行状态
						end
						else//没写够16字节
						begin
							RS <= 1'b1;    //RS=1表示写数据
							DB8 <= Data_Buf[127:120];
							Data_Buf <= (Data_Buf << 8);
							disp_count <= disp_count + 1'b1;
							state <= Write_Data_First;
						end
					end
					Write_Data_Second: //写第二行数据
					begin
						if(disp_count == 5'd16)//数据写完了
						begin
							RS <= 1'b0;//写指令
							DB8 <= 8'b10000000;      //写入第一行显示起始地址：第一行第1个位置
							disp_count <= 5'b00000; 
							state <= Write_Addr;   //重新循环
						end
						else//
						begin		
							RS <= 1'b1;
							DB8 <= Data_Buf[127:120];
							Data_Buf <= (Data_Buf << 8);
							disp_count <= disp_count + 1'b1;
							state <= Write_Data_Second; 
						end              
					end
			//--------------------------------------------------------------------------//		
					default:  state <= Clear_Lcd; //若state为其他值，则将state置为Clear_Lcd 
				endcase 
			end
	end

endmodule

