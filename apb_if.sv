interface apb_if(input bit P_clk, input bit P_rstn);
	// APB Signals
	logic [31:0] P_addr;
	logic P_selx;
	logic P_enable;
	logic P_write;
	logic [31:0] P_wdata;
	logic P_ready;
	logic [31:0] P_rdata;
  
	//--------------------------------------------------
	// Clocking block for DRIVER
	//--------------------------------------------------
	clocking drv_cb @(posedge P_clk);
		default input #1 output #1;
		output P_addr;
		output P_selx;
		output P_enable;
		output P_write;
		output P_wdata;
		input P_ready;
		input P_rdata;
	endclocking
  	
//--------------------------------------------------
// Clocking block for MONITOR
//--------------------------------------------------
	clocking mon_cb @(posedge P_clk);
		default input #1;
			input P_addr;
			input P_selx;
			input P_enable;
			input P_write;
			input P_wdata;
			input P_ready;
			input P_rdata;
	endclocking
  
//--------------------------------------------------
// Modports
//--------------------------------------------------
		modport DRIVER (clocking drv_cb, input P_rstn);
		modport MONITOR (clocking mon_cb, input P_rstn);
endinterface
