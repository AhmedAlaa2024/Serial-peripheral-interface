module Slave(
	input reset, 
	input [7:0] slaveDataToSend, 
	output reg [7:0] slaveDataReceived,
	input SCLK,
	input CS, MOSI,
	output reg MISO
	
	
);


reg [7:0] Reg_Data; //internal Register within the slave



always @(negedge CS) begin //the start of the transmission
	
	slaveDataReceived<= 'bxxxxxxxx; //inisialize it with dont care for debuging
	Reg_Data <= slaveDataToSend;
	
end
 
always@(posedge CS) //end of transmission
	MISO<= 1'bz; 


always @(posedge SCLK or posedge reset) begin //Data Shifting -- Async reset
	
	if (reset) begin
		Reg_Data <= 0; //reset the register
		MISO<= 1'bz;
	end
	else if(!CS ) begin //shifting
		MISO <= Reg_Data[0];

	end

end




always @(negedge SCLK) begin //Data Sampling

	if(!CS) begin	
		Reg_Data <= {MOSI, Reg_Data[7:1]};
		slaveDataReceived <= {MOSI, slaveDataReceived[7:1]};
		end

end





endmodule
