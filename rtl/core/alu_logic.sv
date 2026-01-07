
module alu_logic #(
    parameter ALU_WIDTH = 32
)(
    input  logic [ALU_WIDTH-1:0] op1,
    input  logic [ALU_WIDTH-1:0] op2,
    input  logic [3:0] alu_op,  // ALU operation code
    output logic [ALU_WIDTH-1:0] result
);

    // --------------------- Precompute multiplication results ---------------------
    logic signed [63:0] mul_ss;   // signed * signed
    logic signed [63:0] mul_su;   // signed * unsigned
    logic [63:0]        mul_uu;   // unsigned * unsigned

    always_comb begin
        // Default result
        result = 32'd0;

        // Precompute multiplications
        mul_ss = $signed(op1) * $signed(op2);
        mul_su = $signed(op1) * $unsigned(op2);
        mul_uu = op1 * op2;

        // --------------------- ALU Operation Selection ---------------------
        case (alu_op)
            // ---------------- RV32I ----------------
            4'b0000: result = op1 + op2;                              // ADD / ADDI / AUIPC / LUI
            4'b0001: result = op1 - op2;                              // SUB / Branch comparison
            4'b0010: result = op1 << op2[4:0];                        // SLL
            4'b0011: result = ($signed(op1) < $signed(op2)) ? 1 : 0; // SLT / SLTI
            4'b0100: result = (op1 < op2) ? 1 : 0;                    // SLTU / SLTIU
            4'b0101: result = op1 ^ op2;                              // XOR / XORI
            4'b0110: result = op1 >> op2[4:0];                        // SRL / SRLI
            4'b0111: result = $signed(op1) >>> op2[4:0];              // SRA / SRAI
            4'b1000: result = op1 | op2;                              // OR / ORI
            4'b1001: result = op1 & op2;                              // AND / ANDI

            // ---------------- RV32M ----------------
            4'b1010: result = mul_ss[31:0];   // MUL (low 32 bits)
            4'b1011: result = mul_ss[63:32];  // MULH (signed*signed high 32 bits)
            4'b1100: result = mul_su[63:32];  // MULHSU (signed*unsigned high 32 bits)
            4'b1101: result = mul_uu[63:32];  // MULHU (unsigned*unsigned high 32 bits)
            4'b1110: result = (op2 == 0) ? 32'hFFFFFFFF : $signed(op1) / $signed(op2); // DIV
            4'b1111: result = (op2 == 0) ? op1 : $signed(op1) % $signed(op2);          // REM

            default: result = 32'd0;
        endcase
    end
endmodule
