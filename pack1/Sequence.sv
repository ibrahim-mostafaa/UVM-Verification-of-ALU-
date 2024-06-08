//sequence 
 class Base_Sequence extends uvm_sequence;
    // Factory Registration
    `uvm_object_utils(Base_Sequence)

    //Constructor
    function new(string name = "Base_Sequence");
        super.new(name); 
    endfunction 
 endclass: Base_Sequence

// Reset_Sequence
 class Reset_Sequence extends Base_Sequence ;
    // Factory Registration
    `uvm_object_utils(Reset_Sequence)

    //Constructor
    function new(string name = "Reset_Sequence");
        super.new(name); 
    endfunction 

    // Instantiate Seq_Item
    my_seq_item item; 

    //Body task
    task body();
    item = my_seq_item::type_id::create("item");
     start_item(item);
        assert (item.randomize() with {rst_n == 0;}) 
        else   $display("Reset Randomization Failed ..... ");
     finish_item(item);
    $display("Time: ",$time, "     Generate new item:     A = %0d, B = %0d, OP_CODE = %0d, C_IN = %0d",item.A,item.B, item.op_code,item.C_in);
    endtask: body
 endclass: Reset_Sequence

// Test_Sequence
 class Test_Sequence extends Base_Sequence ;
    // Factory Registration
    `uvm_object_utils(Test_Sequence)

    //Constructor
    function new(string name = "Test_Sequence");
        super.new(name); 
    endfunction 

    // Instantiate Seq_Item
    my_seq_item item; 

    //Body task
    task body();
    item = my_seq_item::type_id::create("item");
     start_item(item);
        assert (item.randomize() with {rst_n == 1;}) 
        else   $display("Test Randomization Failed ..... ");
     finish_item(item);
    $display("Time: %0t ",$time, "  Generate new item:   A = %0d, B = %0d, OP_CODE = %0d, C_IN = %0d",item.A,item.B, item.op_code,item.C_in);
    endtask: body
 endclass: Test_Sequence
 
