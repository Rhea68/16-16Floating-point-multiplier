module bfloat16_multiplier
(output logic[15:0]product, 
output logic ready, 
input logic[15:0] a, b, 
input logic clock, nreset);

logic sign_a,sign_b,sign_p;
logic [7:0]exp_a,exp_b,exp_p;
logic [6:0]man_a,man_b;
logic [15:0]man_p;

enum {waiting,running}state;

 always_ff@(posedge clock, negedge nreset)
  begin
   if (!nreset)
       state<=waiting;
   else 
       case(state)
	   waiting:state<=running;
	   running:state<=waiting;
	   endcase
   end 

 always_comb
  begin
    ready='0;
    product=16'b0;
 
 case(state)

 waiting:
      begin 
      sign_a=1'b0;
      sign_b=1'b0;
      sign_p=1'b0;          
      exp_a=8'b0;
      exp_b=8'b0;
      exp_p=8'b0;
      man_a=7'b0;
      man_b=7'b0;
      man_p=16'b0;
      end
    
running:
     begin 
    sign_a=a[15];
    sign_b=b[15];
    sign_p='0;
    exp_a=a[14:7];
    exp_b=b[14:7];
    exp_p=8'b0;
    man_a=a[6:0];
    man_b=b[6:0];
    man_p=16'b0;
   
      ready='1;
      if((exp_a==8'b1&man_a!=='0)|(exp_b==8'b1&man_b!=='0))  
        product=16'b1111111111000000;
          else if((exp_a== 8'b0 && man_a==7'b0)||(exp_b== 8'b0 && man_b==7'b0))  
             product=16'b0;
                else if ((sign_a==1'b0&&exp_a== 8'b1&&man_a==7'b0)|(sign_b==1'b0&& exp_b== 8'b1&&man_b==7'b0))  
                   product=16'b0111111110000000;
                      else if ((sign_a==1'b1&&exp_a== 8'b1&&man_a==7'b0)|(sign_b==1'b1&& exp_b== 8'b1&&man_b==7'b0))  
                           product=16'b1111111110000000;
                              else 
				 begin
                                sign_p=sign_a^sign_b;
                                exp_p=exp_a+exp_b-127;
                                man_p=({1'b1,man_a}*{1'b1,man_b});
                                   
                                  if (man_p[15]==1)
                                    begin
                                     exp_p=exp_p+1;
                                     man_p=man_p<<1;
	                                end
                                  else 
	   
                                      man_p=man_p<<2;
	                             end      
                                  product={sign_p, exp_p, man_p[15:9]};
                                 
       end	  
        
    endcase
  end


endmodule