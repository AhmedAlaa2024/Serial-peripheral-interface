module Slave_TB();

reg reset,SCLK, CS, MOSI;
wire MISO;
reg [7:0] slaveDataToSend;
wire [7:0] slaveDataReceived;
wire [7:0] ExpectedMasterDataToSend;
wire [7:0] ExpectedMasterDataToReceive;

integer index;

Slave s(
	reset,SCLK, CS, MOSI, MISO,
	slaveDataToSend, 
	slaveDataReceived
	
);

assign ExpectedMasterDataToSend=8'b01010011;
assign ExpectedMasterDataToReceive=8'b00001001;

initial begin
index=0;
slaveDataToSend=8'b00001001;
SCLK=0;
reset=0;
#1 reset=1;
CS=0;
#8 CS=1;


if(slaveDataReceived==ExpectedMasterDataToSend)
$display("Received Successfully");
else
$display("Receiving Failed");

if (ExpectedMasterDataToReceive==slaveDataToSend)
$display("Sent Successfully");
else
$display("Sending Failed");

end

always(!CS && negedge SCLK)begin
MISO <= ExpectedMasterDataToSend[index];
index<=index+1;
end

always begin
#(1/2) SCLK=~SCLK;
end
endmodule