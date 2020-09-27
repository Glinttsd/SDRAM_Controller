`define SIM

module uart_tx(
	input				sclk		,
	input				s_rst_n	,
	output	reg			rs232_tx	,
	input				tx_trig	,
	input		[7:0]	tx_data
);

reg	[7:0]		tx_data_r	;
reg			tx_flag	;
reg	[12:0]	baud_cnt	;
reg			bit_flag	;
reg	[3:0]		bit_cnt	;

`ifndef	SIM
localparam	BAUD_END	=	5207			;
`else
localparam	BAUD_END	=	56				;
`endif
localparam	BAUD_M		=	BAUD_END/2 - 1	;
localparam	BIT_END		=	8				;

//main
always @(posedge sclk or negedge s_rst_n)begin // set tx_data_r
	if(s_rst_n == 1'b0)
		tx_data_r	<=	'd0;
	else if(tx_trig == 1'b1 && tx_flag == 1'b0)
		tx_data_r	<=	tx_data;
end

always @(posedge sclk or negedge s_rst_n)begin // set tx_flag
	if(s_rst_n == 1'b0)
		tx_flag <= 1'b0;
	else if(tx_trig == 1'b1)
		tx_flag <= 1'b1;
	else if(bit_cnt == BIT_END && bit_flag == 1'b1)
		tx_flag <= 1'b0;
end

always @(posedge sclk or negedge s_rst_n)begin // set baud_cnt
	if(s_rst_n == 1'b0)
		baud_cnt <= 'd0;
	else if(baud_cnt == BAUD_END)
		baud_cnt <= 'd0;
	else if(tx_flag == 1'b1)
		baud_cnt <= baud_cnt + 1'b1;
	else	
		baud_cnt <= 'd0;
end

always @(posedge sclk or negedge s_rst_n)begin // set bit_flag
	if(s_rst_n == 1'b0)
		bit_flag <= 1'b0;
	else if(baud_cnt == BAUD_END)
		bit_flag <= 1'b1;
	else
		bit_flag <= 1'b0;
end

always @(posedge sclk or negedge s_rst_n)begin // set bit_cnt
	if(s_rst_n == 1'b0)
		bit_cnt <= 1'b0;
	else if(bit_flag == 1'b1 && bit_cnt == BIT_END)
		bit_cnt <= 1'b0;
	else if(bit_flag == 1'b1)
		bit_cnt <= bit_cnt + 1'b1;
end

always @(posedge sclk or negedge s_rst_n)begin // set rs232_tx
	if(s_rst_n == 1'b0)
		rs232_tx <= 1'b1;
	else if(tx_flag == 1'b1)
		case(bit_cnt)
			0:		rs232_tx <= 1'b0;
			1:		rs232_tx <= tx_data_r[0];
			2:		rs232_tx <= tx_data_r[1];
			3:		rs232_tx <= tx_data_r[2];
			4:		rs232_tx <= tx_data_r[3];
			5:		rs232_tx <= tx_data_r[4];
			6:		rs232_tx <= tx_data_r[5];
			7:		rs232_tx <= tx_data_r[6];
			8:		rs232_tx <= tx_data_r[7];
			default:	rs232_tx <= 1'b1;
		endcase
	else	
		rs232_tx <= 1'b1;
	
end








endmodule
