class apb_drv extends uvm_driver#(apb_txn);
  `uvm_component_utils(apb_drv)
  
   virtual apb_if vif;
  
  function new(string name = "apb_drv", uvm_component parent=null);
    super.new(name, parent);
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

  @(posedge vif.P_clk);
  wait(vif.P_rstn == 1);

  forever begin
    seq_item_port.get_next_item(req);

    // -------------------------
    // SETUP phase
    // -------------------------
    @(vif.drv_cb);
    vif.drv_cb.P_selx   <= 1;
    vif.drv_cb.P_enable <= 0;
    vif.drv_cb.P_addr   <= req.P_addr;
    vif.drv_cb.P_write  <= req.P_write;
    vif.drv_cb.P_wdata  <= req.P_wdata;

    // -------------------------
    // ACCESS phase
    // -------------------------
    @(vif.drv_cb);
    vif.drv_cb.P_enable <= 1;

    // wait for ready
    do @(vif.drv_cb); while (!vif.drv_cb.P_ready);

    // -------------------------
    // DEASSERT
    // -------------------------
    @(vif.drv_cb);
    vif.drv_cb.P_selx   <= 0;
    vif.drv_cb.P_enable <= 0;

    seq_item_port.item_done();
  end

endtask
endclass
