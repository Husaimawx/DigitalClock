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
	
	input clk,rst,cset;//50Mhz时钟，复位按钮，调整开关(SW[1])  
	input h,m,s;//小时、分钟、秒调整按钮 KEY[0] KEY[1] KEY[2]	
	output wire led1,led2,led3,led4,led5,led6,led7,led8;//整点报时灯 LEDG[0]~LEDG[7]
	input EN_DECORDER;//模式选择开关SW[17]
	
	input H_SET,M_SET,S_SET,EN;//倒计时设置按钮SW[6] SW[7] SW[8] 倒计时开关SW[9]
	output wire out_k;//倒计时指示灯
	
	input CLOCK_A,CLOCK_B,CLOCK_C,CLOCK_D;//闹钟置数开关SW[5] SW[4] SW[3] SW[2]
	output wire[6:0] out_Hhz;//闹钟输出小时高位
	output wire[6:0] out_Hlz;//闹钟输出小时低位
	output wire[6:0] out_mhz;//闹钟输出分钟高位
	output wire[6:0] out_mlz;//闹钟输出分钟低位
	output wire[6:0] out_mhb;//倒计时输出分高位
	output wire[6:0] out_mlb;//倒计时输出分低位
	output wire[6:0] out_shb;//倒计时输出秒高位
	output wire[6:0] out_slb;//倒计时输出秒高位
	output wire en;//闹钟报时灯LEDG[8]
	output reg speaker;//闹钟铃声
	
	output LCD_EN,RS,RW,LCD_ON;//LCD输出端
	output [7:0]DB8;//LCD数据端
			
	wire clk_1;//一秒计时器
	wire clk_2;//两秒计时器
	wire rst;//复位按钮 SW[0]
	wire count_1;//60秒进位时钟
	wire count_2;//60分钟进位时钟
	wire rst_1;//24小时进位时钟
	
	wire[3:0] out_Hh;//计数器输出中间变量
	wire[3:0] out_Hl;
	wire[3:0] out_mh;
	wire[3:0] out_ml;
	wire[3:0] out_sh;
	wire[3:0] out_sl;
	
	wire[3:0] Mh;//闹钟分钟高位
	wire[3:0] Ml;//闹钟分钟低位
	wire[3:0] Hh;//闹钟小时高位
	wire[3:0] Hl;//闹钟小时低位
	
	wire[3:0] H_h;//秒表小时高位
	wire[3:0] H_l;//秒表小时低位
	wire[3:0] M_h;//秒表分钟高位
	wire[3:0] M_l;//秒表分钟低位
	wire[3:0] S_h;//秒表秒高位
	wire[3:0] S_l;//秒表秒低位
		
	wire[7:0] out_Hhlcd;//LCD输出小时高位
	wire[7:0] out_Hllcd;//LCD输出小时低位
	wire[7:0] out_mhlcd;//LCD输出分钟高位
	wire[7:0] out_mllcd;//LCD输出分钟低位
	wire[7:0] out_shlcd;//LCD输出秒高位
	wire[7:0] out_sllcd;//LCD输出秒低位
	
	wire [3:0]decorderview_0;//数码管总输出
	wire [3:0]decorderview_1;
	wire [3:0]decorderview_2;
	wire [3:0]decorderview_3;
	wire [3:0]decorderview_4;
	wire [3:0]decorderview_5;
	wire [3:0]decorderview_6;
	wire [3:0]decorderview_7;
	
	wire clk_s;//秒
	wire clk_m;//分
	wire clk_h;//时
	
	wire zhengdian;//整点报时使能
	wire EN_DECORDER;
	
	assign clk_s = (clk_1) | (cset & !s);  //用户时钟秒 
	assign clk_m = (count_1) | (cset & !m);//用户时钟分
	assign clk_h = (count_2) | (cset & !h);//用户时钟小时
	assign zhengdian = ((out_sh==5)&(out_mh==5)&(out_ml==9))|((out_sl==0)&(out_sh==0)&(out_mh==0)&(out_ml==0));//整点报时
	
	s_1 clk_s1(.clk(clk),.out_1(clk_1),.cset(cset));//50MHZ分频器

	//计时器主程序模块
	m_60 second(.clk/*输入时钟*/(clk_s),
				.rst/*清零*/(rst),
				.ql/*低位输出*/(out_sl),
				.qh/*高位输出*/(out_sh),
				.count/*进位输出作为下一个时钟*/(count_1));//60秒计数器
	m_60 minute(.clk(clk_m),.rst(rst),.ql(out_ml),.qh(out_mh),.count(count_2));//60分钟计数器
	m_24 hour(.clk(clk_h),.rst(rst),.ql(out_Hl),.qh(out_Hh),.count(rst_1));//24小时计数器
	
	//整点报时模块
	clk_s2 clk_s2(.clk(clk_1),.clk_2(clk_2));//2分频器
	LED_1 LED_1(.clk(clk),.clk_2(clk_2),.en(zhengdian),.led1(led1),.led2(led2),.led3(led3),.led4(led4),.led5(led5),.led6(led6),.led7(led7));

	
	//闹钟模块
	clock clock_user(.clk_1(clk_1),.en(en),//闹钟用时钟和闹钟显示灯
					 .out_Hh(out_Hh),.out_Hl(out_Hl),.out_mh(out_mh),.out_ml(out_ml),//接收当前时刻数值
					 .A(CLOCK_A),.B(CLOCK_B),.C(CLOCK_C),.D(CLOCK_D),//闹钟设置按钮
					 .Hh(Hh),.Hl(Hl),.Mh(Mh),.Ml(Ml));//闹钟设置寄存器及清零
	
	//蜂鸣器模块		
	always
	begin
	    if(en==1)
		  speaker <= clk_1; //产生方波信号
		else	
		  speaker <= 0;	
	end
	
	//倒计时模块
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
	
					
	//输出数码管译码器HEX[0]~HEX[3}
	decorder decorder_0(.a(decorderview_0),.Y(out_slb));
	decorder decorder_1(.a(decorderview_1),.Y(out_shb));
	decorder decorder_2(.a(decorderview_2),.Y(out_mlb));
	decorder decorder_3(.a(decorderview_3),.Y(out_mhb));
	decorder decorder_4(.a(decorderview_4),.Y(out_mlz));
	decorder decorder_5(.a(decorderview_5),.Y(out_mhz));
	decorder decorder_6(.a(decorderview_6),.Y(out_Hlz));
	decorder decorder_7(.a(decorderview_7),.Y(out_Hhz));
	
	//ASCii码翻译器
	LcdWord LcdWordhh(.X(out_Hh),.Y(out_Hhlcd));
	LcdWord LcdWordhl(.X(out_Hl),.Y(out_Hllcd));
	LcdWord LcdWordmh(.X(out_mh),.Y(out_mhlcd));
	LcdWord LcdWordml(.X(out_ml),.Y(out_mllcd));
	LcdWord LcdWordsh(.X(out_sh),.Y(out_shlcd));
	LcdWord LcdWordsl(.X(out_sl),.Y(out_sllcd));
	
	//LCD显示模块
	LCD1602 Lcd1602(.clk(clk),.rst(rst),.LCD_EN(LCD_EN),.RS(RS),.RW(RW),.DB8(DB8),.LCD_ON(LCD_ON),
					.out_Hhlcd(out_Hhlcd),.out_Hllcd(out_Hllcd),
					.out_mhlcd(out_mhlcd),.out_mllcd(out_mllcd),
					.out_shlcd(out_shlcd),.out_sllcd(out_sllcd));
	
endmodule