module signExtend(i_data, o_data, unsign);
	input   [15:0]  i_data;
	output  [31:0]  o_data;
	input unsign;
	
	assign o_data =  !unsign ? {{16{1'b0}}, i_data} : {{16{i_data[15]}}, i_data};
endmodule