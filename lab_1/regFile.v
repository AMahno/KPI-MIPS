module regFile(i_clk, 
               i_raddr1, 
               i_raddr2, 
               i_waddr, 
               i_wdata, 
               i_we,
               o_rdata1,
               o_rdata2 
               );
               
	input           i_clk, i_we;
	input   [4:0]   i_raddr1, i_raddr2, i_waddr;
	input   [31:0]  i_wdata;           
	output reg [31:0]  o_rdata1, o_rdata2;

	reg [31:0] regs[31:0];
	
	always @(posedge i_clk) begin
		if(i_we) begin
			regs[i_waddr] <= i_wdata;
		end

		if(i_raddr1 == 0) o_rdata1 = 0;
		else o_rdata1 <= regs[i_raddr1];
		
		if(i_raddr2 == 0) o_rdata2 = 0;
		else o_rdata2 <= regs[i_raddr2];
	end
  
endmodule