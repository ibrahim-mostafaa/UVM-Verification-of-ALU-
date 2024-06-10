//Monitor 
 class my_monitor extends uvm_monitor;
    // Factory Registration
    `uvm_component_utils(my_monitor)  

    //Constructor
    function new(string name = "my_monitor", uvm_component parent);
        super.new(name,parent); 
    endfunction 

    //Instantiation of analysis port
    uvm_analysis_port #(my_seq_item) analysis_port_monitor;

    //Instantiation of virtual interface
    virtual interface intf config_intf; 
    virtual interface intf local_intf; 

    //Instantiation: item
    my_seq_item current_item, next_item; 

    //Instantiation: items queue to hold transactions 
    //my_seq_item items_queue[$]; 

    //phases 
    //build_phase
    function void build_phase (uvm_phase phase); 
    super.build_phase(phase);
    //Display 
    `uvm_info(get_type_name(),"Build Phase",UVM_MEDIUM)

    // get from config_db
    if(!uvm_config_db #(virtual intf)::get(this,"","my_vif",config_intf))
        `uvm_fatal(get_full_name(),"Error!")

    local_intf = config_intf; 

    //Constructor: handle of analysis port
    analysis_port_monitor = new("analysis_port_monitor",this);
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

    current_item = my_seq_item::type_id::create("current_item");
    next_item = my_seq_item::type_id::create("next_item");

    forever begin 

    //wait(local_intf.rst_n);
    @(local_intf.cb); 
        //get inputs of next cycle
    next_item.A = local_intf.cb.A;
    next_item.B = local_intf.cb.B;
    next_item.op_code = local_intf.cb.op_code;
    next_item.C_in = local_intf.cb.C_in;
        // get results of current cycle 
    current_item.rst_n = local_intf.rst_n;
    current_item.Result = local_intf.cb.Result;
    current_item.C_out  = local_intf.cb.C_out;
    current_item.Z_flag = local_intf.cb.Z_flag;
        // write the current cylce values
    analysis_port_monitor.write(current_item);
    // for debuging 
    // $display("Time: %0t ", $time, "Monitor.A = %0d, Monitor.B = %0d, Monitor.op_code = %0d, Monitor.C_in = %0d, Monitor.Result = %0d, Monitor.C_out = %0d, Monitor.Z_flag = %0d ", 
    // current_item.A,current_item.B,current_item.op_code,current_item.C_in,current_item.Result,current_item.C_out,current_item.Z_flag);
        
        // transfer signals to current_item 
    current_item.A <= next_item.A;
    current_item.B <= next_item.B;
    current_item.C_in <= next_item.C_in;
    current_item.op_code <= next_item.op_code;
    end

    endtask: run_phase

 endclass 
