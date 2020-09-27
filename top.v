module top(
	input				sclk			,
	input				s_rst_n		,
	input				rs232_rx		,
	output	wire			rs232_tx 
);

wire		[7:0]		rx_data			;
wire					tx_trig			;

// main
uart_rx		uart_rx_inst(
	.sclk			(sclk		)		,
	.s_rst_n		(s_rst_n	)		,
	.rs232_rx		(rs232_rx	)		, // UART output(PC)/input(FPGA)
	.rx_data		(rx_data	)		, // store rx_data(from serial to parallel)	
	.po_flag		(tx_trig	)		  // flag to finish receiving a frame of data
);

uart_tx		uart_tx_inst(
	.sclk			(sclk		)		,
	.s_rst_n		(s_rst_n	)		,
	.rs232_tx		(rs232_tx	)		,
	.tx_trig		(tx_trig	)		,
	.tx_data		(rx_data	)
);

endmodule