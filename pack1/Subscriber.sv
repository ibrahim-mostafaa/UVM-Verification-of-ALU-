//Subscriber 
 class my_subscirber extends uvm_subscriber #(my_seq_item);
    // Factory Registration
    `uvm_component_utils(my_subscirber)

    // Coverage definition: 
    covergroup Design_signals;
        //option.per_instance=1;
        reset_case:coverpoint item.rst_n;
        carry_input_case:coverpoint item.C_in iff (item.rst_n); // sample only if rst_n is deasserted 
        op_code_case:coverpoint item.op_code iff (item.rst_n) {
            bins Addition ={4'b0000};
            bins Subtraction ={4'b0001};
            bins Multiplication ={4'b0010};
            bins Division ={4'b0011};
            bins AND ={4'b0100};
            bins XOR ={4'b0101};
        }
        input_A_case: coverpoint item.A iff (item.rst_n) {
            bins A_all_ones={8'b11111111};
            bins A_all_zeros={8'b0};
            bins random_data=default;
        }
        input_B_case: coverpoint item.B iff (item.rst_n) {
            bins B_all_ones={8'b11111111};
            bins B_all_zeros={8'b0};
            bins random_data=default;
        }
        //Cross Coverage
        cross op_code_case, input_A_case;
        cross op_code_case, input_B_case;
        cross input_A_case, input_B_case;
    endgroup

    //Constructor
    function new(string name = "my_subscriber", uvm_component parent);
        super.new(name,parent); 
        Design_signals = new();
    endfunction 

    // // Instantiation: analysis imp
    // uvm_analysis_imp #(my_seq_item,my_subscirber) analysis_export_subscriber;
    //Instantiation: item
    my_seq_item item; 

    //phases 
    //build_phase
    function void build_phase (uvm_phase phase); 
    super.build_phase(phase);
    //Display 
    `uvm_info(get_type_name(),"Build Phase",UVM_MEDIUM)
        // Constructor: analysis imp
    // analysis_export_subscriber = new("analysis_export_subscriber",this);

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
    endtask: run_phase


    //override pure virtual function void
    function void write(my_seq_item t); 
    //item = my_seq_item::type_id::create("item");
    $cast(item,t);
    Design_signals.sample();
    $display("Final Coverage --------------------> %0.2f%%",Design_signals.get_coverage());
    endfunction: write
 endclass 
