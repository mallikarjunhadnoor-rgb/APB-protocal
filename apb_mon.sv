class apb_mon extends uvm_monitor;
  `uvm_component_utils(apb_mon)

  virtual apb_if vif;
  uvm_analysis_port #(apb_txn) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

      if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
       `uvm_fatal("DRV", "Failed to get vif")
  endfunction
    
  function void connect_phase(uvm_phase phase);
       super.connect_phase(phase);
      this.vif = vif;
   endfunction


 task run_phase(uvm_phase phase);

  bit prev_ready = 0;

  forever begin
    @(vif.mon_cb);

    if (vif.mon_cb.P_selx && vif.mon_cb.P_enable) begin

      // detect rising edge of P_ready
      if (vif.mon_cb.P_ready && !prev_ready) begin

        apb_txn tr = apb_txn::type_id::create("tr");

        tr.P_addr  = vif.mon_cb.P_addr;
        tr.P_write = vif.mon_cb.P_write;

        if (vif.mon_cb.P_write)
          tr.P_wdata = vif.mon_cb.P_wdata;
        else
          tr.P_rdata = vif.mon_cb.P_rdata;

        `uvm_info("MON", "TRANSFER CAPTURED (ONCE)", UVM_NONE)

        ap.write(tr);
      end

      prev_ready = vif.mon_cb.P_ready;
    end
    else begin
      prev_ready = 0; // reset between transfers
    end
  end

endtask
endclass
