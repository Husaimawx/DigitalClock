module fzyDigital(
	clk,cset,
	h,m,s,
	out_Hhz,out_Hlz,out_mhz,out_mlz,
	out_mhb,out_mlb,out_shb,out_slb,
	rst,
	led1,led2,led3,led4,led5,led6,led7,led8,
	en,
	CLOCK_A,CLOCK_B,CLOCK_C,CLOCK_D,
	LCD_EN,RS,RW,DB8,LCD_ON,
	H_SET,M_SET,S_SET,EN,
	out_k,EN_DECORDER,
	speaker
	);
	
	input clk,rst,cset;//50Mhzʱ�ӣ���λ��ť����������(SW[1])  
	input h,m,s;//Сʱ�����ӡ��������ť KEY[0] KEY[1] KEY[2]	
	output wire led1,led2,led3,led4,led5,led6,led7,led8;//���㱨ʱ�� LEDG[0]~LEDG[7]
	input EN_DECORDER;//ģʽѡ�񿪹�SW[17]
	
	input H_SET,M_SET,S_SET,EN;//����ʱ���ð�ťSW[6] SW[7] SW[8] ����ʱ����SW[9]
	output wire out_k;//����ʱָʾ��
	
	input CLOCK_A,CLOCK_B,CLOCK_C,CLOCK_D;//������������SW[5] SW[4] SW[3] SW[2]
	output wire[6:0] out_Hhz;//�������Сʱ��λ
	output wire[6:0] out_Hlz;//�������Сʱ��λ
	output wire[6:0] out_mhz;//����������Ӹ�λ
	output wire[6:0] out_mlz;//����������ӵ�λ
	output wire[6:0] out_mhb;//����ʱ����ָ�λ
	output wire[6:0] out_mlb;//����ʱ����ֵ�λ
	output wire[6:0] out_shb;//����ʱ������λ
	output wire[6:0] out_slb;//����ʱ������λ
	output wire en;//���ӱ�ʱ��LEDG[8]
	output reg speaker;//��������
	
	output LCD_EN,RS,RW,LCD_ON;//LCD�����
	output [7:0]DB8;//LCD���ݶ�
			
	wire clk_1;//һ���ʱ��
	wire clk_2;//�����ʱ��
	wire rst;//��λ��ť SW[0]
	wire count_1;//60���λʱ��
	wire count_2;//60���ӽ�λʱ��
	wire rst_1;//24Сʱ��λʱ��
	
	wire[3:0] out_Hh;//����������м����
	wire[3:0] out_Hl;
	wire[3:0] out_mh;
	wire[3:0] out_ml;
	wire[3:0] out_sh;
	wire[3:0] out_sl;
	
	wire[3:0] Mh;//���ӷ��Ӹ�λ
	wire[3:0] Ml;//���ӷ��ӵ�λ
	wire[3:0] Hh;//����Сʱ��λ
	wire[3:0] Hl;//����Сʱ��λ
	
	wire[3:0] H_h;//���Сʱ��λ
	wire[3:0] H_l;//���Сʱ��λ
	wire[3:0] M_h;//�����Ӹ�λ
	wire[3:0] M_l;//�����ӵ�λ
	wire[3:0] S_h;//������λ
	wire[3:0] S_l;//������λ
		
	wire[7:0] out_Hhlcd;//LCD���Сʱ��λ
	wire[7:0] out_Hllcd;//LCD���Сʱ��λ
	wire[7:0] out_mhlcd;//LCD������Ӹ�λ
	wire[7:0] out_mllcd;//LCD������ӵ�λ
	wire[7:0] out_shlcd;//LCD������λ
	wire[7:0] out_sllcd;//LCD������λ
	
	wire [3:0]decorderview_0;//����������
	wire [3:0]decorderview_1;
	wire [3:0]decorderview_2;
	wire [3:0]decorderview_3;
	wire [3:0]decorderview_4;
	wire [3:0]decorderview_5;
	wire [3:0]decorderview_6;
	wire [3:0]decorderview_7;
	
	wire clk_s;//��
	wire clk_m;//��
	wire clk_h;//ʱ
	
	wire zhengdian;//���㱨ʱʹ��
	wire EN_DECORDER;
	
	assign clk_s = (clk_1) | (cset & !s);  //�û�ʱ���� 
	assign clk_m = (count_1) | (cset & !m);//�û�ʱ�ӷ�
	assign clk_h = (count_2) | (cset & !h);//�û�ʱ��Сʱ
	assign zhengdian = ((out_sh==5)&(out_mh==5)&(out_ml==9))|((out_sl==0)&(out_sh==0)&(out_mh==0)&(out_ml==0));//���㱨ʱ
	
	s_1 clk_s1(.clk(clk),.out_1(clk_1),.cset(cset));//50MHZ��Ƶ��

	//��ʱ��������ģ��
	m_60 second(.clk/*����ʱ��*/(clk_s),
				.rst/*����*/(rst),
				.ql/*��λ���*/(out_sl),
				.qh/*��λ���*/(out_sh),
				.count/*��λ�����Ϊ��һ��ʱ��*/(count_1));//60�������
	m_60 minute(.clk(clk_m),.rst(rst),.ql(out_ml),.qh(out_mh),.count(count_2));//60���Ӽ�����
	m_24 hour(.clk(clk_h),.rst(rst),.ql(out_Hl),.qh(out_Hh),.count(rst_1));//24Сʱ������
	
	//���㱨ʱģ��
	clk_s2 clk_s2(.clk(clk_1),.clk_2(clk_2));//2��Ƶ��
	LED_1 LED_1(.clk(clk),.clk_2(clk_2),.en(zhengdian),.led1(led1),.led2(led2),.led3(led3),.led4(led4),.led5(led5),.led6(led6),.led7(led7));

	
	//����ģ��
	clock clock_user(.clk_1(clk_1),.en(en),//������ʱ�Ӻ�������ʾ��
					 .out_Hh(out_Hh),.out_Hl(out_Hl),.out_mh(out_mh),.out_ml(out_ml),//���յ�ǰʱ����ֵ
					 .A(CLOCK_A),.B(CLOCK_B),.C(CLOCK_C),.D(CLOCK_D),//�������ð�ť
					 .Hh(Hh),.Hl(Hl),.Mh(Mh),.Ml(Ml));//�������üĴ���������
	
	//������ģ��		
	always
	begin
	    if(en==1)
		  speaker <= clk_1; //���������ź�
		else	
		  speaker <= 0;	
	end
	
	//����ʱģ��
	backclock bcak_user(.clr(rst),.clk(clk_1),.H_SET(H_SET),.M_SET(M_SET),.S_SET(S_SET),.EN(EN),
						.H_h(H_h),.H_l(H_l),.M_h(M_h),.M_l(M_l),.S_h(S_h),.S_l(S_l),.out(out_k));
	
	assign 	decorderview_0=EN_DECORDER?0:S_l;
	assign  decorderview_1=EN_DECORDER?0:S_h;
	assign  decorderview_2=EN_DECORDER?Ml:M_l;
	assign  decorderview_3=EN_DECORDER?Mh:M_h;
	assign  decorderview_4=EN_DECORDER?Hl:H_l;
	assign  decorderview_5=EN_DECORDER?Hh:H_h;
	assign  decorderview_6=EN_DECORDER?0:0;
	assign  decorderview_7=EN_DECORDER?0:0;	
	
					
	//��������������HEX[0]~HEX[3}
	decorder decorder_0(.a(decorderview_0),.Y(out_slb));
	decorder decorder_1(.a(decorderview_1),.Y(out_shb));
	decorder decorder_2(.a(decorderview_2),.Y(out_mlb));
	decorder decorder_3(.a(decorderview_3),.Y(out_mhb));
	decorder decorder_4(.a(decorderview_4),.Y(out_mlz));
	decorder decorder_5(.a(decorderview_5),.Y(out_mhz));
	decorder decorder_6(.a(decorderview_6),.Y(out_Hlz));
	decorder decorder_7(.a(decorderview_7),.Y(out_Hhz));
	
	//ASCii�뷭����
	LcdWord LcdWordhh(.X(out_Hh),.Y(out_Hhlcd));
	LcdWord LcdWordhl(.X(out_Hl),.Y(out_Hllcd));
	LcdWord LcdWordmh(.X(out_mh),.Y(out_mhlcd));
	LcdWord LcdWordml(.X(out_ml),.Y(out_mllcd));
	LcdWord LcdWordsh(.X(out_sh),.Y(out_shlcd));
	LcdWord LcdWordsl(.X(out_sl),.Y(out_sllcd));
	
	//LCD��ʾģ��
	LCD1602 Lcd1602(.clk(clk),.rst(rst),.LCD_EN(LCD_EN),.RS(RS),.RW(RW),.DB8(DB8),.LCD_ON(LCD_ON),
					.out_Hhlcd(out_Hhlcd),.out_Hllcd(out_Hllcd),
					.out_mhlcd(out_mhlcd),.out_mllcd(out_mllcd),
					.out_shlcd(out_shlcd),.out_sllcd(out_sllcd));
	
endmodule