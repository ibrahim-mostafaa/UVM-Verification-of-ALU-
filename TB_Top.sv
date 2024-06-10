//Testbench
`include "uvm_pkg.sv"
`include "pack1.sv"
`include "Interface.sv"
`include "DUT.sv"

module TB_Top;
import uvm_pkg::*;
import pack1::*; 

// Generate clk
bit clk; 
initial begin
    clk = 1 ;
    forever #10 clk = ~clk; 
end

//instantiate interfrace 
intf alu_intf(clk); 

//instantiate dut 
DUT dut (
    .clk(clk), 
    .rst_n(rst_n), 
    .A(alu_intf.A), 
    .B(alu_intf.B), 
    .C_in(alu_intf.C_in),
    .op_code(alu_intf.op_code), 
    .Result(alu_intf.Result), 
    .C_out(C_out), 
    .Z_flag(Z_flag)
);

//run test
initial begin
    uvm_config_db #(virtual intf)::set(null,"uvm_test_top","my_vif",alu_intf); // my_vif = alu_intf , it now points to it. 
    run_test("my_test"); 
end
endmodule
