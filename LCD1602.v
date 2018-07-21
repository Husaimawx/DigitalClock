module LCD1602(clk,rst,LCD_EN,RS,RW,DB8,LCD_ON,/*,data_row1*/out_Hhlcd,out_Hllcd,out_mhlcd,out_mllcd,out_shlcd,out_sllcd);
	/*input[127:0] data_row1,data_row2;*///��һ�к͵ڶ�����������
	input[7:0] out_Hhlcd,out_Hllcd,out_mhlcd,out_mllcd,out_shlcd,out_sllcd;
	input   clk,rst;        //rstΪȫ�ָ�λ�źţ��ߵ�ƽ��Ч��
	output  LCD_EN,LCD_ON;//LCD_ENΪLCDģ���ʹ���źţ��½��ش�����
	output  RS;//RS=0ʱΪдָ�RS=1ʱΪд����
	output  RW;//RW=0ʱ��LCDģ��ִ��д������RW=1ʱ��LCDģ��ִ�ж�����
	output reg [7:0] DB8; //8λָ�����������
	reg     RS,LCD_EN_Sel;
	wire[127:0] data_row1,data_row2;
	assign  LCD_ON = 1'b1;
	
	//------------------------------------//
	//����ʱ��50MHz  �������2ms
	//division50MHz_2ms.v
	reg [15:0]count;
	reg clk_2ms;//2ms���ʱ��
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

	reg     [127:0] Data_Buf;   //Һ����ʾ�����ݻ���
	reg     [4:0] disp_count;
	reg     [3:0] state;

	parameter   Clear_Lcd		  = 4'b0000, //��������긴λ 
	      		Set_Disp_Mode     = 4'b0001, //������ʾģʽ��8λ2��5x7����   
	           	Disp_On           = 4'b0010, //��ʾ��������겻��ʾ����겻������˸
	            Shift_Down        = 4'b0011, //���ֲ���������Զ�����
	            Write_Addr        = 4'b0100, //д����ʾ��ʼ��ַ
	            Write_Data_First  = 4'b0101, //д���һ����ʾ������
	            Write_Data_Second = 4'b0110; //д��ڶ�����ʾ������		
		
	assign  RW = 1'b0;  //RW=0ʱ��LCDģ��ִ��д����(һֱ����д״̬��
	assign  LCD_EN = LCD_EN_Sel ? clk_2ms : 1'b0;//ͨ��LCD_EN_Sel�ź�������LCD_EN�Ŀ�����ر�
	assign  data_row1="fzy_Digital#^_^/";
	assign  data_row2 = {{4{8'b00100000}},out_Hhlcd,out_Hllcd,{8'b00111010},out_mhlcd,out_mllcd,{8'b00111010},out_shlcd,out_sllcd,{4{8'b00100000}}};//"####HH:MM:SS####"

	always @(posedge clk_2ms or posedge rst)
	begin
		if(rst)
			begin
				state <= Clear_Lcd;  //��λ����������긴λ   
				RS <= 1'b1;          //��λ��RS=1ʱΪ��ָ�                       
				DB8 <= 8'b0;         //��λ��ʹDB8�������ȫ0
				LCD_EN_Sel <= 1'b0;  //��λ����ҹ��ʹ���ź�
				disp_count <= 5'b0;
				//---------�����ǲ�������------------------------//
					   //λ��"0123456789abcdef��
					
			end
		else 
			begin
				case(state)         //��ʼ��LCDģ��
					Clear_Lcd:
			        begin
						LCD_EN_Sel <= 1'b1;//��ʹ��
						RS <= 1'b0;//дָ��
			            DB8 <= 8'b00000001;  //��������긴λ
						state <= Set_Disp_Mode;
			        end
					Set_Disp_Mode:
					begin
						DB8 <= 8'b00111000;   //������ʾģʽ��8λ2��5x8���� 
						state <= Disp_On;
					end
					Disp_On:
					begin
						DB8 <= 8'b00001100;   //��ʾ��������겻��ʾ����겻������˸ 
						state <= Shift_Down;
					end
					Shift_Down:
					begin
						DB8 <= 8'b00000110;    //���ֲ���������Զ�����    
						state <= Write_Addr;
					end
			//---------------------------------��ʾѭ��------------------------------------//		
					Write_Addr:
					begin
						RS <= 1'b0;//дָ��
						DB8 <= 8'b10000000;      //д���һ����ʾ��ʼ��ַ����һ�е�1��λ��    
						Data_Buf <= data_row1;     //����һ����ʾ�����ݸ���Data_First_Buf
					//	DB8 <= Data_First_Buf[127:120];
						state <= Write_Data_First;
					end
					Write_Data_First:  //д��һ������
					begin
						if(disp_count == 5'd16)    //disp_count����15ʱ��ʾ��һ��������д��
						begin
							RS <= 1'b0;//дָ��
							DB8 <= 8'b11000000;     //����д�ڶ��е�ָ��,��2�е�1��λ��
							disp_count <= 5'b00000; //������0
							Data_Buf <= data_row2;//����2����ʾ�����ݸ���Data_First_Buf
						//	DB8 <= Data_Second_Buf[127:120];
							state <= Write_Data_Second;   //д���һ�н���д�ڶ���״̬
						end
						else//ûд��16�ֽ�
						begin
							RS <= 1'b1;    //RS=1��ʾд����
							DB8 <= Data_Buf[127:120];
							Data_Buf <= (Data_Buf << 8);
							disp_count <= disp_count + 1'b1;
							state <= Write_Data_First;
						end
					end
					Write_Data_Second: //д�ڶ�������
					begin
						if(disp_count == 5'd16)//����д����
						begin
							RS <= 1'b0;//дָ��
							DB8 <= 8'b10000000;      //д���һ����ʾ��ʼ��ַ����һ�е�1��λ��
							disp_count <= 5'b00000; 
							state <= Write_Addr;   //����ѭ��
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
					default:  state <= Clear_Lcd; //��stateΪ����ֵ����state��ΪClear_Lcd 
				endcase 
			end
	end

endmodule

