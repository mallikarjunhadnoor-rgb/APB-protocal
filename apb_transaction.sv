class apb_txn extends uvm_sequence_item;

  rand bit        P_write;
  rand bit [31:0] P_addr;
  rand bit [31:0] P_wdata;

       bit [31:0] P_rdata;

  `uvm_object_utils(apb_txn)

  function new(string name="apb_txn");
    super.new(name);
  endfunction

endclass
