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
    rand logic [3:0] op_code;
    rand bit C_in;

    // Non-Random Variables
    logic [15:0] Result;
    bit C_out,Z_flag;
    

   
    constraint c1 { 
       op_code inside {[4'b0000:4'b0101]} ;
       A > B ; 
      //op_code == 1 ;
    }

 endclass 
