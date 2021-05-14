module Slave(
	input reset,SCLK, CS, MOSI, MISO,

	input [7:0] slaveDataToSend, slaveDataReceived
	
);

integer data_count =0;


always @(posedge SCLK or posedge reset) begin //Data Shifting
	


end


always @(negedge SCLK) begin //Data Sampling


	
end





endmodule