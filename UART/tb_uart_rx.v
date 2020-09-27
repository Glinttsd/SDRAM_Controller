`timescale 1ns/1ns

module tb_uart_rx;

reg				sclk;
reg				s_rst_n;
reg				rs232_tx;

wire				po_flag;
wire		[7:0]	rx_data;

reg		[7:0]	mem_a[3:0];
initial begin
	sclk = 		1;
	s_rst_n	<= 	0;
	rs232_tx	<=	1;
	#100
	s_rst_n	<=	1;
	#100
	tx_byte();
end

always #5	sclk	=	~sclk;

initial $readmemh("./tx_data.txt",mem_a); // input tx_data from txt to mem_a

task	tx_byte();
	integer	i;
	for(i=0; i<4; i=i+1)begin
		tx_bit(mem_a[i]);
	end
endtask

task	tx_bit(
		input	[7:0]	data
		);
	integer	i;
	for(i=0; i<10; i=i+1)begin
		case(i)
			0:	rs232_tx	<=	1'b0;
			1:	rs232_tx	<=	data[0];
			2:	rs232_tx	<=	data[1];
			3:	rs232_tx	<=	data[2];
			4:	rs232_tx	<=	data[3];
			5:	rs232_tx	<=	data[4];
			6:	rs232_tx	<=	data[5];
			7:	rs232_tx	<=	data[6];
			8:	rs232_tx	<=	data[7];
			9:	rs232_tx	<=	1'b1;
		endcase
		#560; // one clock cycle
	end

endtask

uart_rx		uart_rx_inst(
	.sclk			(sclk			),
	.s_rst_n		(s_rst_n		),
	.rs232_rx		(rs232_tx		),
	.rx_data		(rx_data		),
	.po_flag		(po_flag		)
);
endmodule
