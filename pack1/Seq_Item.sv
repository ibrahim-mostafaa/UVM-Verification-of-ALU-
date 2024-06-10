//sequence item 
 class my_seq_item extends uvm_sequence_item ;
    // Factory Registration
    `uvm_object_utils(my_seq_item)

    //Constructor
    function new(string name = "my_seq_item");
        super.new(name); 
    endfunction 

    //seq_item_signals 
    // Random Variables 
    rand logic rst_n;
    rand logic [7:0] A,B;
    rand logic [2:0] op_code;
    rand logic C_in;

    // Non-Random Variables
    logic [15:0] Result;
    logic C_out,Z_flag;
    
    //Constraints
    constraint c1 { 
       op_code inside {[3'b000:3'b101]} ;
    }

 endclass: my_seq_item
