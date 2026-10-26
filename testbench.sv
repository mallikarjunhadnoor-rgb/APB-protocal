`include "uvm_macros.svh"
`include "apb_if.sv"
`include "apb_transaction.sv"
`include "apb_seqs.sv"
//`include "wr_rd_seqs.sv"
`include "apb_seqr.sv"
`include "apb_drv.sv"
`include "apb_mon.sv"
`include "apb_agent.sv"
`include "apb_sb.sv"
`include "apb_env.sv"
`include "apb_test.sv"

import uvm_pkg::*;
module top;

  // Clock & Reset
  bit P_clk;
  bit P_rstn;

  // Clock generation
  initial begin
    P_clk = 0;
    forever #5 P_clk = ~P_clk;
  end

  // Reset generation
  initial begin
    P_rstn = 0;
    #20;
    P_rstn = 1;
  end

  // Interface instance
  apb_if vif(P_clk, P_rstn);

  // DUT instance
  AMBA_APB dut (
    .P_clk    (P_clk),
    .P_rstn    (P_rstn),
    .P_addr   (vif.P_addr),
    .P_selx   (vif.P_selx),
    .P_enable (vif.P_enable),
    .P_write  (vif.P_write),
    .P_wdata  (vif.P_wdata),
    .P_ready  (vif.P_ready),
    .P_rdata  (vif.P_rdata)
  );

  // UVM Configuration
  initial begin
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", vif);
  end

  // Run UVM Test
  initial begin
    run_test("wr_rd_test");
  end
endmodule
