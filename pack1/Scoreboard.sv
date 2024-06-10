//Scoreboard 
 class my_scoreboard extends uvm_scoreboard;
    // Factory Registration
    `uvm_component_utils(my_scoreboard)

    //Constructor
    function new(string name = "my_scoreboard", uvm_component parent);
        super.new(name,parent); 
    endfunction 

    // Instantiation: analysis imp
    uvm_analysis_imp #(my_seq_item,my_scoreboard) analysis_export_scoreboard;

    //Instantiation: items queue to hold transactions 
    my_seq_item items_queue[$]; 
    my_seq_item item_t; 

    //phases 
    //build_phase
    function void build_phase (uvm_phase phase); 
    super.build_phase(phase);
    //Display 
    `uvm_info(get_type_name(),"Build Phase",UVM_MEDIUM)

    // Constructor: analysis imp
    analysis_export_scoreboard = new("analysis_export_scoreboard",this);
    endfunction: build_phase

    //connect_phase
    function void connect_phase (uvm_phase phase); 
    super.connect_phase(phase);
    //Display 
    `uvm_info(get_type_name(),"Connect Phase",UVM_MEDIUM)
    endfunction: connect_phase

    //run_phase
    task run_phase (uvm_phase phase); 
    super.run_phase(phase);
    //Display 
    `uvm_info(get_type_name(),"Run Phase",UVM_MEDIUM)

        forever begin
            item_t = my_seq_item::type_id::create("item");
            wait (items_queue.size);  
            item_t =  items_queue.pop_front();
            compare(item_t);
            end
    endtask: run_phase

    function void write(my_seq_item item); 
    items_queue.push_back(item); 
    endfunction: write

    function void compare(my_seq_item item) ;
    logic [15:0] Result_t;
    logic C_out_t, Z_flag_t;
    if(!item.rst_n) begin 
        Result_t = 0;
        $display("Time: %0t", $time, "    Reset Asserted, SB.rst_n = ", item.rst_n);
        if(!(Result_t == item.Result))
            `uvm_error(get_type_name(), $sformatf("Reset failure!! the actual result= %d while the expected reuslt= %d",item.Result,Result_t))  
        else $display("Result Reset Scuccessfully");
    end

    else begin 
    case(item.op_code)  
    3'b000:  Result_t = item.A + item.B + item.C_in; 
    3'b001: Result_t = item.A - item.B;  
    3'b010: Result_t = item.A * item.B;  
    3'b011: Result_t = item.A / item.B;  
    3'b100: Result_t = item.A & item.B; 
    3'b101: Result_t = item.A ^ item.B;  
    endcase

    C_out_t = Result_t[8];
    
    if(Result_t==0) begin 
        Z_flag_t= 1;
        C_out_t = 0;  
    end
    else  Z_flag_t = 0; 

    $display("Time: %0t", $time, "   item.rst_n = %0d,item.A = %0d, item.B = %0d, item.op_code = %0d, item.Result = %0d", item.rst_n,item.A, item.B, item.op_code, item.Result);
        if(!((Result_t == item.Result)&&(C_out_t == item.C_out)&&(Z_flag_t==item.Z_flag)))
            `uvm_error(get_type_name(), $sformatf("failure!! the actual result= %0d while the expected reuslt= %0d  |||||  actual C_out = %0b while expected C_out = %0b |||||  actual Z_flag = %0b while expected Z_flag = %0b "
            ,item.Result,Result_t,item.C_out,C_out_t, item.Z_flag,Z_flag_t))  
        else $display("No Errors/ Mismatch found"); 
    end
    endfunction:compare 

 endclass 
   