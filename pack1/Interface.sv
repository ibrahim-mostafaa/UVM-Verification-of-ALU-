//Interface
interface intf(input logic clk);

  // ALU signals
    logic rst_n;
    logic[7:0] A, B;
    logic[3:0] op_code;
    bit C_in;
    logic[15:0] Result;
    bit C_out, Z_flag;

//clocking block
clocking cb @(posedge clk);
default input #0 output negedge; 
//output rst_n;
output A,B; 
output op_code; 
output C_in; 
input Result;
input C_out,Z_flag; 
endclocking 

endinterface //intf
