module full_half_add_1bit(
                          i_a     ,  
                          i_b     ,   
                          i_cin   ,  
                          o_sum   ,  
                          o_carry    
                          )       ;


input  i_a, i_b, i_cin            ;    
output o_sum, o_carry             ;
wire   w_sum1, w_carry1, w_carry2 ;

half_adder h1(                       
              .h_a(i_a)           ,   
              .h_b(i_b)           ,
              .h_sum(w_sum1)      ,	
              .h_carry(w_carry1)    
              )                   ;
half_adder h2(                       
              .h_a(w_sum1)        ,
              .h_b(i_cin)         ,
              .h_sum(o_sum)       ,	
              .h_carry(w_carry2)
              )                   ;

assign o_carry = w_carry1 | w_carry2;
  
endmodule 


module half_adder(
	            h_a,	
	            h_b,	
               	h_sum,	
	            h_carry    
);


input  h_a	   ;
input  h_b	   ;
output h_sum	;
output h_carry	;
  

assign h_sum   =  h_a ^ h_b;	
assign h_carry =  h_a & h_b;	
  
endmodule 