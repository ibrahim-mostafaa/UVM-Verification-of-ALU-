//Driver 
 class my_driver extends uvm_driver #(my_seq_item);
    // Factory Registration
    `uvm_component_utils(my_driver)

    //Constructor
    function new(string name = "my_driver", uvm_component parent);
        super.new(name,parent); 
    endfunction 

    //Instantiation of virtual interface
    virtual interface intf config_intf; 
    virtual interface intf local_intf;

    //Instanitation: seq_item_driv
    my_seq_item seq_item_driv; 

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
    endfunction

    //connect_phase
    function void connect_phase (uvm_phase phase); 
    super.connect_phase(phase);
    //Display 
    `uvm_info(get_type_name(),"Connect Phase",UVM_MEDIUM)
    endfunction

    //run_phase
    task run_phase (uvm_phase phase); 
    super.run_phase(phase);
    //Display 
    `uvm_info(get_type_name(),"Run Phase",UVM_MEDIUM)

    //Receive transactions for sequencer 
    forever begin 
    seq_item_driv = my_seq_item::type_id::create("seq_item_driv");
    seq_item_port.get_next_item(seq_item_driv);
    drive(seq_item_driv); 
    seq_item_port.item_done();
    $display("**********************Driver After****************************");
    $display("Time: ",$time, "      driver.A = %0d, driver.B = %0d, driver.op_code = %0d, driver.C_in = %0d",
    seq_item_driv.A,seq_item_driv.B, seq_item_driv.op_code,seq_item_driv.C_in);
    end 
    endtask: run_phase

    task drive (my_seq_item seq_item_driv);
    // Asynch reset 
    local_intf.rst_n <= seq_item_driv.rst_n; 
    //$display("Time: %0t", $time, "  driver.rst_n = ", seq_item_driv.rst_n);
    @(local_intf.cb) begin
    local_intf.cb.A <= seq_item_driv.A; 
    local_intf.cb.B <= seq_item_driv.B; 
    local_intf.cb.op_code <= seq_item_driv.op_code; 
    local_intf.cb.C_in <= seq_item_driv.C_in; 
    end
    $display("Driver Port Done"); 
    endtask 

 endclass 
