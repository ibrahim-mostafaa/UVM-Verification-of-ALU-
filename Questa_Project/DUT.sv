module DUT (
    input  logic         clk,
    input  logic         rst_n,
    input  logic [7:0]   A,
    input  logic [7:0]   B,
    input  logic [2:0]   op_code,
    input  logic         C_in,
    output logic [15:0]  Result,
    output logic         C_out,
    output logic         Z_flag
);

    // Internal signals
    logic [15:0] Temp;
    logic        C_out_t, Z_flag_t;

    // ALU logic
    always_ff @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            Result <= 0;
            C_out <= 0;
            Z_flag <= 1;
        end else begin 
            Result <= Temp;
            C_out <= C_out_t;
            Z_flag <= Z_flag_t;  
        end
    end

    always_comb begin
        // Default values to prevent latches
        Temp = 0;
        C_out_t = 0;
        Z_flag_t = 0;

        case (op_code) 
            3'b000: Temp = A + B + C_in;
            3'b001: Temp = A - B;
            3'b010: Temp = A * B;
            3'b011: if (B != 0) Temp = A / B; // Handle division by zero
            3'b100: Temp = A & B;
            3'b101: Temp = A ^ B;
            default: Temp = 0; // Default case to handle unspecified op_codes
        endcase
        
        // Assigning C_out_t 
        C_out_t = Temp[8];
        
        // Assigning Z_flag_t
        Z_flag_t = (Temp == 0) ? 1 : 0;
    end
endmodule
