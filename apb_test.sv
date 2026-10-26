class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)
  
  apb_env env;
  
  function new(string name = "apb_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    env = apb_env::type_id::create("env",this);
    
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  
endclass

class wtest extends apb_test;
  `uvm_component_utils(wtest)
  
  apb_write_seqs wseqs;
  
  function new(string name="wtest", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);  
    `uvm_info("wtest","Write Testcase started....",UVM_NONE)
    
    wseqs = apb_write_seqs::type_id::create("wseqs");  
    wseqs.start(env.agt.seqr);   
    #100
    phase.drop_objection(this);
    
  endtask
endclass

class wr_rd_test extends apb_test;
  `uvm_component_utils(wr_rd_test)

  apb_wr_rd_seq seq;

  function new(string name="wr_rd_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("TEST","Write-Read Test Started", UVM_NONE)

    seq = apb_wr_rd_seq::type_id::create("seq");
    seq.start(env.agt.seqr);
    #100;
    phase.drop_objection(this);
  endtask
endclass
