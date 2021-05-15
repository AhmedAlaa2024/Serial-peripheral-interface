module Slave(
	input reset,SCLK, CS, MOSI, 
	input [7:0] slaveDataToSend, 
	output reg MISO,
	output [7:0] slaveDataReceived
	
);
reg [7:0] Reg_Data;
integer data_count =0;

reg finished = 0;

always @(negedge CS) begin
	//the start of the transmission
	data_count =0;
	finished = 0;
	Reg_Data = slaveDataToSend;
end

always @(posedge SCLK or posedge reset) begin //Data Shifting
	
if (reset)
	Reg_Data <= 0; //reset the register



if(data_count > 8)
	finished = 1; //must be a blocking assignment

if (!CS && !finished ) begin
	//shifting
	MISO <= Reg_Data[0];
	Reg_Data <= {MOSI, Reg_Data[7:1]};
	data_count = data_count +1;

end

end




always @(negedge SCLK) begin //Data Sampling


	
end





endmodule