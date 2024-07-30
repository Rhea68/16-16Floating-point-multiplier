module test_bfloat16_multiplier;
logic[15:0]product; 
logic ready; 
logic[15:0]a, b; 
logic clock, nreset;
shortreal reala, realb, realproduct;
logic[31:0]ra,rb;


bfloat16_multiplier a1 (.*);

initial 
begin
  nreset = '1;
  clock = '0;
  #5ns nreset = '1;
  #5ns nreset = '0;
  #5ns nreset = '1;
  forever #5ns clock = ~clock;

end 

initial
begin
@(posedge ready);
reala=1.0;
ra=$shortrealtobits(reala);
realb=3.0;
rb=$shortrealtobits(realb);
a=ra[31:16];
b=rb[31:16];
@(posedge ready);
@(posedge clock);
realproduct=$bitstoshortreal({product, {16{1'b0}}});
$display("Test 2 %f\n", realproduct);
end
endmodule
