//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-01-08 17:35:06
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-01-24 10:34:16
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: SerialIO_v1_0_S00_AXI
// Project Name:   
// Target Devices:   
// Tool Versions:   
// Description:   
// 
// Dependencies:   
// 
// Revision:  
// Revision 0.01 - File Created
// Additional Comments:  
// 
//////////////////////////////////////////////////////////////////////////////////


	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	if ( S_AXI_ARESETN == 1'b0 )
		begin
			axi_rdata  <= 0;
		end 
	else
		begin    
		  // When there is a valid read address (S_AXI_ARVALID) with 
		  // acceptance of read address by the slave (axi_arready), 
		  // output the read dada 
		  if (slv_reg_rden)
			begin
			  axi_rdata <= reg_data_out;     // register read data
			end   
		end
	end    

	assign SCLK = serial_clk;

	reg serial_clk = 1'b0;
	reg [31:0] clk_cnt = 8'd0;

	// Add user logic here
	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			clk_cnt <= 32'd0; 
			serial_clk <= 1'b0;
		end // if ( S_AXI_ARESETN == 1'b0 )

		else begin
			
			if ( clk_cnt == ( (SERIAL_DIV >> 1) ) ) begin
				serial_clk <= 1'b0;
				clk_cnt <= clk_cnt + 32'd1;
			end // if ( clk_cnt == ( (SERIAL_DIV >> 1)  )
			else if ( clk_cnt >= SERIAL_DIV  ) begin
				serial_clk <= 1'b1;
				clk_cnt <= 32'd0;
			end // else if ( clk_cnt >= SERIAL_DIV - 1 )
			else begin
				serial_clk <= serial_clk;
				clk_cnt <= clk_cnt + 32'd1;
			end // else

		end // else
	end

	reg [3:0] sout_cnt = 4'd0;
	reg [15:0] data_out_reg = 16'b0;

	always @( negedge serial_clk ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			sout_cnt <= 4'd0;
			data_out_reg <= 16'b0;
			SDO <= 1'b0;
			UPDATE_PLUSE <= 1'b0;
		end // if ( S_AXI_ARESETN == 1'b0 )

		else begin
			SDO <= data_out_reg[4'd15-sout_cnt];

			if ( sout_cnt == 4'd15 ) begin

				UPDATE_PLUSE <= 1'b0;
				sout_cnt <= 4'd0;
				data_out_reg <= slv_reg0[15:0];
	
			end // if ( sout_cnt == 4'd15 )

			else if ( sout_cnt == 4'd0 ) begin
				UPDATE_PLUSE <= 1'b1;
				sout_cnt <= sout_cnt + 4'd1;
			end // else if ( sout_cnt == 4'd0 )

			else begin
				UPDATE_PLUSE <= 1'b0;
				sout_cnt <= sout_cnt + 4'd1;
			end // else

		end // else
	end
	

    reg [3:0] sin_cnt = 4'd0;

	reg [15:0] data_shift = 16'b0;

    always @( negedge serial_clk ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			LE <= 1'b0;
			sin_cnt <= 4'd0;
			serial_in_reg  <= 16'b0;
			data_shift <= 16'b0;
			LOAD <= 1'b1;
		end // else

		else begin
			data_shift <= ( data_shift << 1 ) | SDI;
			if ( sin_cnt == 4'd15 ) begin
				sin_cnt <= 4'd0;
				serial_in_reg <= serial_in_reg;

				LE <= 1'b1;
				LOAD <= 1'b0;
			end // if ( sin_cnt == 4'd15 )

			else if ( sin_cnt == 4'd0 ) begin
				sin_cnt <= sin_cnt + 4'd1;
				serial_in_reg <= data_shift;
				LOAD <= 1'b1;
				LE <= 1'b1;
			end // else if ( sin_cnt == 4'd0 )

			else begin
				sin_cnt <= sin_cnt + 4'd1;
				serial_in_reg <= serial_in_reg;
				LOAD <= 1'b1;
				LE <= 1'b0;
			end // else

		end // else
	end // always @( posedge S_AXI_ACLK )


	// User logic ends

	endmodule
