class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  
  apb_seqr seqr;
  apb_drv drv;
  apb_mon mon;
  
  function new(string name = "apb_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    seqr = apb_seqr::type_id::create("seqr",this);
    drv  = apb_drv::type_id::create("drv",this);
    mon  = apb_mon::type_id::create("mon",this);
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

  
endclass
