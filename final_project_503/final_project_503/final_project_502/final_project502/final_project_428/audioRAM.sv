 module  audioRAM
(
		input [3:0] data_In,
		input [18:0] write_address, read_address,
		input we, Clk,

		output logic [15:0] data_Out
);

// mem has width of 4 bits and a total of 400 addresses
logic [3:0] mem [0:2099];

initial
begin
	 $readmemh("key.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= {{mem[read_address]},{mem[read_address+1'b1]},{mem[read_address+2'b10]},{mem[read_address+2'b11]}};
end

endmodule