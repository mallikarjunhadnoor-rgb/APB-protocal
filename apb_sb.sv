class apb_sb extends uvm_component;

  `uvm_component_utils(apb_sb)

  uvm_analysis_imp #(apb_txn, apb_sb) imp;

  bit [31:0] mem [32];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    imp = new("imp", this);
  endfunction

  function void write(apb_txn tr);
    if (tr.P_write) begin
      mem[tr.P_addr[4:0]] = tr.P_wdata;
      
      `uvm_info("APB_SB",
    $sformatf("WRITE: addr=%0d data=%0d",
      tr.P_addr, tr.P_wdata),
    UVM_NONE)
    end
    else begin
      if (mem[tr.P_addr[4:0]] != tr.P_rdata)
        `uvm_error("APB_SB", "Read data mismatch")
      else
        `uvm_info("APB_SB", "Matched Successfully", UVM_NONE)
    end
  endfunction

endclass
