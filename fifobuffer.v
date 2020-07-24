`timescale 1 s / 1 s
module fifobuffer #(parameter Num_of_bits=8, Length=8)
    (
        input reset,
        input clock,
        input read_enable,
        input write_enable,
        input [(Num_of_bits-1):0] fifo_in,
        output reg [(Num_of_bits-1):0] fifo_out,
        output empty,
        output full,
        output reg [3:0] fifo_counter 
    );
    
  	reg [2:0] read_ptr, write_ptr;
    
    reg[(Num_of_bits-1):0] fifo_mem[(Length-1):0];
    
    assign empty = (fifo_counter == 0);
  	assign full = (fifo_counter == Length);
  
  
     // Writing Module
  always @(posedge clock)
      begin    
         if (!full && write_enable)
          begin
            fifo_mem[ write_ptr ] <= fifo_in;                               
            $display("Writing data: %d at %t",fifo_in,$time);                         
          end                            
      end
    

    
    // Reading Module
  always @( posedge clock or negedge reset)
    begin
        if( ~reset )
            fifo_out <= 0;
        else
            begin
              if ( !empty && read_enable )
                begin
                  fifo_out <= fifo_mem[read_ptr];                                       
                  $display("Reading data: %d at %t",fifo_mem[read_ptr],$time);          
                end                                                               
            end
    end
    
   
    
    // Read/Write Pointers
  always@(posedge clock or negedge reset)
    begin
        if( ~reset )
        begin
            write_ptr <= 0;
            read_ptr <= 0;
        end
        else
        begin
            if( !full && write_enable )
                write_ptr <= write_ptr + 1;         
                
            if( !empty && read_enable )
                read_ptr <= read_ptr + 1;          
        end    
    end    
  
  
  
      //To Handle Fifo Counter
  always @(posedge clock or negedge reset)
    begin
        if (~reset)
            fifo_counter <= 0;
        else if( (!full && write_enable) && ( !empty && read_enable ) ) 
            fifo_counter <= fifo_counter;               
        else if (!full && write_enable)  
            fifo_counter <= fifo_counter + 1;             
        else if (!empty && read_enable)  
            fifo_counter <= fifo_counter - 1;                                          
    end
  
  
       
endmodule
