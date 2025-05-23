`include "full_half_add_1bit.v"
`timescale 1ns/1ns

module full_half_add_1bit_tb  ;
   reg a, b, cin              ;  
   wire sum, carry	         ;  
   reg new_sum, new_carry     ;  

full_half_add_1bit dut(
                       .i_a(a)           ,		
                       .i_b(b)           ,		
                       .i_cin(cin)       ,      
                       .o_sum(sum)       ,		 
                       .o_carry(carry)	         
                       );

initial begin 
   $dumpfile("full_half_add_1bit_tb.vcd");
   $dumpvars(0, full_half_add_1bit_tb);
   repeat(100)
      begin
         stimulus();                                
      end
      $finish;
end
  
task stimulus     ;    
   reg A, B, Cin  ;    

   begin 
   A   = $random;   
   B   = $random;   
   Cin = $random;   

    
   a   = A;          
   b   = B;          
   cin = Cin;          
    
   {new_carry, new_sum} = A + B + Cin;#1; 
   
   end
    
endtask     
  
endmodule         