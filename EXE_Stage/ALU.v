module ALU(
    input [31:0] Val1, Val2,
    input [3:0] EXE_CMD,
    input c, 
    output reg [31:0] alu_result,
    output [31:0] Status_Bits
);
    reg c_out;
    reg v_out;
    wire z_out; 
    wire n_out; 

    wire [31:0] c_in_extended = {{31{1'b0}}, c};
    wire [31:0] not_c_in_extended = {{31{1'b0}}, ~c};

    assign Status_Bits[31:28] = { n_out, z_out, c_out, v_out};
    assign Status_Bits[27:0]  = 28'b0;
    
    reg [32:0] temp_result;

    always @(*) begin
        c_out = 0;
        v_out = 0;
        case(EXE_CMD)
            4'b0010 : begin // ADD
                temp_result = {1'b0, Val1} + {1'b0, Val2};
                alu_result = temp_result[31:0];
                c_out = temp_result[32]; 
                v_out = (Val1[31] == Val2[31]) && (alu_result[31] != Val1[31]); 
            end

            4'b0011 : begin // ADC, Add with Carry
                temp_result = {1'b0, Val1} + {1'b0, Val2} + c_in_extended;
                alu_result = temp_result[31:0];
                c_out = temp_result[32];
                v_out = (Val1[31] == Val2[31]) && (alu_result[31] != Val1[31]);
            end

            4'b0100 : begin // SUB
                temp_result = {1'b0, Val1} - {1'b0, Val2};
                alu_result = temp_result[31:0];
                c_out = ~temp_result[32];
                v_out = (Val1[31] != Val2[31]) && (alu_result[31] != Val1[31]);
            end

            4'b0101 : begin // SBC
                temp_result = {1'b0, Val1} - {1'b0, Val2} - not_c_in_extended;
                alu_result = temp_result[31:0];
                c_out = ~temp_result[32];
                v_out = (Val1[31] != Val2[31]) && (alu_result[31] != Val1[31]);
            end

            4'b0110 : begin // AND or TST
                alu_result = Val1 & Val2;
                c_out = 0; 
                v_out = 0;
            end

            4'b0111 : begin // ORR
                alu_result = Val1 | Val2;
                c_out = 0;
                v_out = 0; 
            end

            4'b1000 : begin // EOR
                alu_result = Val1 ^ Val2;
                c_out = 0;
                v_out = 0;
            end

            4'b0001 : begin // MOV
                alu_result = Val2;
                c_out = 0;
                v_out = 0;
            end

            4'b1001 : begin // MVN
                alu_result = ~Val2;
                c_out = 0;
                v_out = 0;
            end

            default : begin
                alu_result = 32'd10;
                c_out = 0;
                v_out = 0;
            end
        endcase
    end

 
    assign z_out = (alu_result == 32'd0) ? 1'b1 : 1'b0;
    assign n_out = alu_result[31];

  
endmodule