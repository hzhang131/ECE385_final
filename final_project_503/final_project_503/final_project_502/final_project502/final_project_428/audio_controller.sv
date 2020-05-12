module audio_controller(
							input logic Clk, Reset,
							input logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK,
							output logic AUD_DACDAT, AUD_XCK, I2C_SCLK, I2C_SDAT
);

enum logic [3:0] { IDL, INI, GETDAT, END } State, Next_state;
logic INIT, INIT_FINISH, data_over, adc_full, AUD_ADCDAT;
logic [31:0] ADCDATA;
logic [15:0] LDATA, RDATA, LDATA_in, RDATA_in, data_out;
logic [19:0] addr_counter;

always_ff @(posedge Clk) begin
	if (Reset)
		State <= IDL;
	else begin
		State <= Next_state;
		LDATA <= LDATA_in;
		RDATA <= RDATA_in;
	end
end

always_comb begin
	INIT = 1'b0;
	Next_state = State;
	LDATA_in = LDATA;
	RDATA_in = RDATA;
	case(State)
		IDL: 	Next_state = INI;
		INI: begin 
			if(INIT_FINISH)
				Next_state = GETDAT;
		end
		GETDAT: begin
			if(data_over)
				Next_state = END;
		end
		END: begin
			if(~data_over)
				Next_state = GETDAT;
		end 
		default:;
	endcase		

	case(State)
		INI: INIT = 1'b1;
		END: begin
			LDATA_in = data_out;
			RDATA_in = data_out; 
		end
		default:;
	endcase
end

always_ff @(posedge data_over) begin
	if(Reset)
		addr_counter <= 6'b0;
	else
		addr_counter <= addr_counter + 3'd4;
end


audioRAM ar(.data_In(4'b0), 
									  .write_address(19'b0), 
									  .read_address(addr_counter), 
									  .we(1'b0), .Clk(Clk), .data_Out(data_out));


audio_interface AUDIO(
					.LDATA(LDATA),
					.RDATA(RDATA),
					.clk(Clk),
					.Reset(Reset),
					.INIT(INIT),
					.INIT_FINISH(INIT_FINISH),
					.adc_full(adc_full),
					.data_over(data_over),
					.AUD_MCLK(AUD_XCK),
					.AUD_BCLK(AUD_BCLK),
					.AUD_ADCDAT(AUD_ADCDAT),
					.AUD_DACDAT(AUD_DACDAT),
					.AUD_ADCLRCK(AUD_ADCLRCK),
					.AUD_DACLRCK(AUD_DACLRCK),
					.I2C_SDAT(I2C_SDAT),
					.I2C_SCLK(I2C_SCLK),
					.ADCDATA(ADCDATA)
);

endmodule
