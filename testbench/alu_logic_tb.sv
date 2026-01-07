`timescale 1ns/1ps

module alu_logic_tb;

    parameter ALU_WIDTH = 32;
    logic [ALU_WIDTH-1:0] op1, op2;
    logic [3:0] alu_op;
    logic [ALU_WIDTH-1:0] result;

    alu_logic #(ALU_WIDTH) dut (
        .op1(op1),
        .op2(op2),
        .alu_op(alu_op),
        .result(result)
    );

    task test(
        input [ALU_WIDTH-1:0] a,
        input [ALU_WIDTH-1:0] b,
        input [3:0] op,
        input [ALU_WIDTH-1:0] expected,
        input string label
    );
        begin
            op1 = a;
            op2 = b;
            alu_op = op;
            #1;
            assert(result === expected)
                else $fatal("FAIL: %s | Got: %0d (0x%08h), Expected: %0d (0x%08h)",
                            label, result, result, expected, expected);
            $display("PASS: %s | Result = %0d (0x%08h)", label, result, result);
        end
    endtask

    initial begin
        $display("=== ALU Logic Test Start ===");

        // ---------------- RV32I ----------------
        test(10, 5, 4'b0000, 15,           "ADD");
        test(10, 5, 4'b0001, 5,            "SUB");
        test(8,  1, 4'b0010, 16,           "SLL");
        test(-2, 1, 4'b0011, 1,            "SLT signed (-2 < 1)");
        test(2,  5, 4'b0011, 1,            "SLT signed (2 < 5)");
        test(5,  2, 4'b0100, 0,            "SLTU unsigned (5 < 2)");
        test(2,  5, 4'b0100, 1,            "SLTU unsigned (2 < 5)");
        test(8,  3, 4'b0101, 11,           "XOR");
        test(32'hF000_0000, 4, 4'b0110, 32'h0F000000, "SRL");
        test(-32, 2, 4'b0111, -8,          "SRA");
        test(12, 5, 4'b1000, 13,           "OR");
        test(15, 5, 4'b1001, 5,            "AND");

        // ---------------- RV32M ----------------
        test(6,  7, 4'b1010, 42,           "MUL");
        test(-6, 7, 4'b1010, -42,          "MUL signed");

        test(-6, 7, 4'b1011, 32'hFFFFFFFF, "MULH signed high");
        test(-6, 7, 4'b1100, 32'hFFFFFFFF, "MULHSU high");
        test(6,  7, 4'b1101, 0,            "MULHU high");

        test(20, 5, 4'b1110, 4,            "DIV");
        test(-20, 5, 4'b1110, -4,           "DIV signed");
        test(20, 0, 4'b1110, 32'hFFFFFFFF, "DIV by zero");

        test(20, 6, 4'b1111, 2,            "REM");
        test(-20, 6, 4'b1111, -2,           "REM signed");
        test(20, 0, 4'b1111, 20,            "REM by zero");

        $display("=== ALU Logic Test Complete ===");
        $finish;
    end

endmodule
