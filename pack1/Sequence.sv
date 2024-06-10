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
    $display("Time: ",$time, "     Generate Reset item:     A = %0d, B = %0d, OP_CODE = %0d, C_IN = %0d",item.A,item.B, item.op_code,item.C_in);
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
      // random test cases 
        assert (item.randomize() with {rst_n == 1;}) 
        else   $display("Test Randomization Failed ..... ");
     finish_item(item);
    $display("Time: %0t ",$time, "  Generate Random Test item:   A = %0d, B = %0d, OP_CODE = %0d, C_IN = %0d",item.A,item.B, item.op_code,item.C_in);
    endtask: body
 endclass: Test_Sequence
 
// Direct_Sequence
 class Direct_Sequence extends Base_Sequence ;
    // Factory Registration
    `uvm_object_utils(Direct_Sequence)

   typedef struct {
      bit [7:0] A;
      bit [7:0] B;
   }  Combination_t;
   //Array of structs to hold combinatons of directed test cases
   Combination_t Combinations []; 

    //Constructor
    function new(string name = "Direct_Sequence");
        super.new(name);  
        Combinations = new[2]; 
        Combinations[0] = '{8'b0,8'b0}; 
        Combinations[1] = '{8'b0,8'b11111111}; 
        Combinations[2] = '{8'b11111111,8'b0}; 
        Combinations[3] = '{8'b11111111,8'b11111111}; 
      
    endfunction 

    // Instantiate Seq_Item
    my_seq_item item; 

    //Body task
    task body();
    // rand_i randomizes choice of array elements
    int rand_i = $urandom_range(0,Combinations.size()-1);
    //int rand_i = $urandom % Combinations.size();    
    Combination_t curr_compination = Combinations [rand_i]; 

   //pattern randomizes the combination between random and directed 
   // 3 cases: [0] A directed, B random --- [1] A random, B directed  ----- [2] A directed, B directed
    int pattern = $urandom_range(0,2);  
    //int pattern = $urandom % 3;   
    item = my_seq_item::type_id::create("item");
     
   // Randomize the directed test cases, and start item
   start_item(item);
   case (pattern) 
   0: begin 
      // A directed, B random
        assert (item.randomize() with {
         rst_n == 1;
         A == curr_compination.A;
         //B random
         }) 
        else   $display("Directed Test Failed (A directed, B random)..... ");
   end 
   1: begin 
      // A random, B directed
        assert (item.randomize() with {
         rst_n == 1;
         //A random
         B == curr_compination.B;
         }) 
        else   $display("Directed Test Failed (A random, B directed)..... ");
   end 
   2: begin 
      // A directed, B directed
        assert (item.randomize() with {
         rst_n == 1;
         A == curr_compination.A;
         B == curr_compination.B;
         }) 
        else   $display("Directed Test Failed (A directed, B directed)..... ");
   end
   endcase 
   finish_item(item);

    $display("Time: %0t ",$time, "  Generate Directed Test item:   A = %0d, B = %0d, OP_CODE = %0d, C_IN = %0d",item.A,item.B, item.op_code,item.C_in);
    endtask: body
 endclass: Direct_Sequence