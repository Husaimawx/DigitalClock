module setclock(cset,h,m,s,inHh,inHl,inmh,inml,insh,insl,Hh,Hl,mh,ml,sh,sl);
	input cset;
	input h,m,s;
	input[3:0] inHh;
	input[3:0] inHl;
	input[3:0] inmh;
	input[3:0] inml;
	input[3:0] insh;
	input[3:0] insl;
	output[3:0] Hh;
	output[3:0] Hl;
	output[3:0] mh;
	output[3:0] ml;
	output[3:0] sh;
	output[3:0] sl;
	reg[3:0] Hh;
	reg[3:0] Hl;
	reg[3:0] mh;
	reg[3:0] ml;
	reg[3:0] sh;
	reg[3:0] sl;
	
 /*always@(posedge cset)	
	begin
	  Hh<=inHh;
	  Hl<=inHl;
	  mh<=inmh;
	  ml<=inml;
	  sh<=insh;
	  sl<=insl;
	end*/

	
 always@(posedge h)
	begin
		if(h)
			begin
				if(Hl==9)
					begin
						Hl<=0;
						Hh<=Hh+1;
					end
				else if(Hh==2&&Hl==3)
					begin
						Hl<=0;
						Hh<=0;
					end
				else
					Hl<=Hl+1;
			end
		else
			begin
			end
	end
	
 always@(posedge m)
	begin
		if(m)
			begin
				if(ml==9)
				begin
					ml<=0;
					if(mh==5)
						mh<=0;
					else
						mh<=mh+1;
				end
				else 
					ml<=ml+1;	
			end
		else
			begin
			end
	end
	
 always@(posedge s)
	begin
		if(s)
			begin
				if(sl==9)
				begin
					sl<=0;
					if(sh==5)
						sh<=0;
					else
						sh<=sh+1;
				end
				else 
					sl<=sl+1;
			end
		else 
			begin
			end
	end
	
endmodule