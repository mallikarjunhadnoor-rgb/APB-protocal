class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  apb_agent agt;
  apb_sb sb;
  
  function new(string name = "apb_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    agt = apb_agent::type_id::create("agt",this);
    sb = apb_sb::type_id::create("sb",this);
  endfunction
  
   function void connect_phase(uvm_phase phase);
    agt.mon.ap.connect(sb.imp);
  endfunction
endclass
