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


integer data_count =0;

reg finished = 0;

always @(negedge CS) begin //the start of the transmission
	
	slaveDataReceived= 'bxxxxxxxx; //inisialize it with dont care for debuging
	Reg_Data = slaveDataToSend;

end



always @(posedge SCLK or posedge reset) begin //Data Shifting
	
if (reset)
	Reg_Data <= 0; //reset the register

else if(!CS && !finished ) begin //shifting

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