module AMBA_APB (
	input P_clk,
	input P_rstn,
	input [31:0] P_addr,
	input P_selx,
	input P_enable,
	input P_write,
	input [31:0] P_wdata,
	output reg P_ready,
	output reg [31:0] P_rdata
);
	// Memory (32 locations)
	reg [31:0] mem [31:0];
  
	// FSM states
	parameter IDLE = 2'b00;
	parameter SETUP = 2'b01;
	parameter ACCESS = 2'b10;
  
	reg [1:0] present_state, next_state;
  
	// Internal control
	reg busy;
  
	//--------------------------------------------------
			// State Register
	//--------------------------------------------------
  
	always @(posedge P_clk) begin
		if (!P_rstn)
			present_state <= IDLE;
		else
			present_state <= next_state;
	end
  
	//--------------------------------------------------
	// Next State Logic
	//--------------------------------------------------
  
	always @(*) begin
		next_state = present_state;
      
		case (present_state)
				IDLE: begin
						if (P_selx && !P_enable)
							next_state = SETUP;
					  end
          
				SETUP: begin
						if (P_selx && P_enable)
							next_state = ACCESS;
						else
							next_state = IDLE;
						end
          
				ACCESS: begin
						// Stay in ACCESS if not ready
						if (P_selx && P_enable && !P_ready)
							next_state = ACCESS;
                  
						// Back-to-back transfer
						else if (P_selx && !P_enable)
							next_state = SETUP;
                  
						else
							next_state = IDLE;
						end
		endcase
	end
  
//--------------------------------------------------
// Output + Transfer Logic
//--------------------------------------------------
	always @(posedge P_clk) begin
		if (!P_rstn) begin
				P_ready <= 0;
				P_rdata <= 0;
				busy <= 0;
		end
      
		else begin
		// Default
				P_ready <= 0;
          
          
				case (present_state)
					
                  //--------------------------------------------------
				  // SETUP: latch request
				  //--------------------------------------------------
					SETUP: begin
								if (P_selx && !P_enable)
									busy <= 1;
							end
                  
				//--------------------------------------------------
				// ACCESS: perform transfer
				//--------------------------------------------------
				ACCESS: begin
					// Perform operation
					if (P_write)
						mem[P_addr[4:0]] <= P_wdata;
					else
						P_rdata <= mem[P_addr[4:0]];
                  
                  
						P_ready <= 1; // transfer complete
						busy <= 0; // ready for next transfer
				end
			endcase
		end
	end
endmodule
