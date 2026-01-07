`timescale 1ns/1ps

module top_tb;

    logic clk;
    logic reset;
    logic [31:0] alu_result_out;
    logic MemRW;
    logic reg_write_en;
    logic [31:0] data_mem_out;

    top uut (
        .clk(clk),
        .reset(reset),
        .alu_result_out(alu_result_out),
        .MemRW(MemRW),
        .reg_write_en(reg_write_en),
        .data_mem_out(data_mem_out)
    );

    initial clk = 0;
    always #5 clk = ~clk;  

    initial begin
        $display("==== TOP MODULE PIPELINED TESTBENCH STARTED ====");

        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        reset = 1;
        #10;
        reset = 0;

        repeat (36) begin
            @(posedge clk);
            $display("[Time: %0t ns]", $time);
            $display("IF Stage   : PC = %h | Inst = %h", uut.pc_IF, uut.inst_IF);
            $display("ID Stage   : PC = %h | Inst = %h", uut.pc_ID, uut.inst_ID);
            $display("EX Stage   : ALUIn1 = %h | ALUIn2 = %h | Result = %h", uut.alu_in1, uut.alu_in2, uut.alu_result_EX);
            $display("MEM Stage  : Addr = %h | DataW = %h | MemRW = %b", uut.alu_result_MEM, uut.reg_data2_MEM, uut.MemRW);
            $display("WB Stage   : Rd = %d | WriteData = %h | RegWrite = %b", uut.rd_WB, uut.write_data, uut.reg_write_en);
            $display("Flush = %b | PCSel = %b", uut.IF_flush, uut.pc_src_ID); // ? NEW
            $display("-----------------------------------------------------------------");
        end

        $display("==== TEST COMPLETE ====");
        $finish;
    end

endmodule