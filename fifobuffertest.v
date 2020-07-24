`timescale 1 s / 1 s

module fifobuffertest;
    parameter NUM_BITS = 32;
    parameter DEPTH = 8; 
    
    reg rst_n;
    reg clk;
    reg rd_en;
    reg wr_en;
    reg [(NUM_BITS-1):0] fifo_in;
    
    
    wire [(NUM_BITS-1):0] fifo_out;
    wire empty;
    wire full;
    wire [3:0] fifo_counter;    
    
    reg [(NUM_BITS-1):0] tempdata;
    

    fifobuffer #(NUM_BITS,DEPTH) DUT(rst_n,clk,rd_en,wr_en,fifo_in,fifo_out,empty,full,fifo_counter);
    initial
        begin
            $dumpfile("fifobuffer.vcd");
            $dumpvars(0,fifobuffertest);
        end


     initial begin
        
        clk = 0;
        rst_n = 1;
        rd_en = 0;
        wr_en = 0;
        tempdata = 0;
        fifo_in = {NUM_BITS{1'bx}};
        #1 rst_n = 0;
        #1 rst_n = 1;
    end
    
    
    always
    #5 clk = ~clk;
    
    
    initial begin       
        $display("Start test: at:%t",$time);     
        transfer(1);
        transfer(2);
        transfer(3);
        transfer(4);
        transfer(5);
        read(tempdata);
        read(tempdata);        
        read(tempdata);
        read(tempdata);        
        read(tempdata);
        read(tempdata); // This pop should fail...
       
        transfer(6);
        transfer(7);                
        read(tempdata);
        read(tempdata);
    #200 $finish; 
       
    end  


    task transfer;
        input[(NUM_BITS-1):0] data;        
        if( full )
         $display("Cannot transfer <%d>:Fifo Buffer is Full at time %t",data,$time);
        else
            begin        
                fifo_in = data;
                wr_en = 1;
                @(posedge clk);
                    #1 wr_en = 0;
            end    
    endtask
    
    task read;
        output [(NUM_BITS-1):0] data;    
        if( empty )
                $display("Cannot Read further: Buffer Empty at time %t",$time);
            else
                begin    
                    rd_en = 1;
                    @(posedge clk);   
                    #1 rd_en = 0;
                    data = fifo_out;    
                end
    endtask


endmodule
