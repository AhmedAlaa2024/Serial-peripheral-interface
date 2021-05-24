module Slave(
	input reset, 
	input [7:0] slaveDataToSend, 
	output reg [7:0] slaveDataReceived,
	input SCLK,
	input CS, MOSI,
	output reg MISO
	
	
);

//I don't have access to MOSI //ONLY The MASTER can Do That (At the ).

reg [7:0] Reg_Data;
reg finished = 0; //in case i wanted to implement it in the future


always @(negedge CS) begin //the start of the transmission
	
	slaveDataReceived<= 'bxxxxxxxx; //inisialize it with dont care for debuging
	Reg_Data <= slaveDataToSend;
	MISO<= 1'bz;
end
 
always@(posedge CS) MISO<= 1'bz;

always @(posedge SCLK or posedge reset) begin //Data Shifting
	
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
