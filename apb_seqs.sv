class apb_write_seqs extends uvm_sequence#(apb_txn);
  `uvm_object_utils(apb_write_seqs)
    
  function new(string name="apb_write_seqs");
    super.new(name); 
  endfunction
  
  task body();
    apb_txn tr;
    
    tr = apb_txn::type_id::create("tr");
    
    start_item(tr);
    
    assert(tr.randomize() with {P_write==1; P_addr inside {[0:10]}; P_wdata inside {[1:100]};});
     
    finish_item(tr);
    
  endtask
  
endclass


class apb_wr_rd_seq extends uvm_sequence #(apb_txn);
  `uvm_object_utils(apb_wr_rd_seq)

  function new(string name="apb_wr_rd_seq");
    super.new(name);
  endfunction

  task body();

    apb_txn req;

    //----------------------------------
    // WRITE
    //----------------------------------
    req = apb_txn::type_id::create("req");
    
    start_item(req);
    assert(req.randomize() with {
      P_write == 1;
      P_addr  == 10;
      P_wdata == 55;
    });
    finish_item(req);

    //----------------------------------
    // READ (same address)
    //----------------------------------
    req = apb_txn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      P_write == 0;
      P_addr  == 10;
    });
    finish_item(req);

  endtask
endclass
