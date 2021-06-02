module Slave_TB();

reg reset,SCLK, CS, MOSI;
wire MISO;
reg [7:0] slaveDataToSend;
reg [7:0] ExpectedMasterDataToReceive;
wire [7:0] slaveDataReceived;

integer index,failures,i;
localparam PERIOD = 6;
localparam TESTCASECOUNT = 4;
Slave s(
	reset,
	slaveDataToSend , slaveDataReceived,
	SCLK, CS, MOSI, MISO
	
);

wire [7:0] testcase_MasterDataToSend [1:TESTCASECOUNT];
wire [7:0] testcase_SlaveDataToSend [1:TESTCASECOUNT];

assign testcase_MasterDataToSend[1]=8'b01010011;
assign testcase_SlaveDataToSend[1]=8'b00001001;

assign testcase_MasterDataToSend[2]=8'b00111100;
assign testcase_SlaveDataToSend[2]=8'b10011000;


assign testcase_MasterDataToSend[3]=8'b01010101;
assign testcase_SlaveDataToSend[3]=8'b11111111;


assign testcase_MasterDataToSend[4]=8'b01011111;
assign testcase_SlaveDataToSend[4]=8'b10011000;



initial begin
index=0;
CS=1;
SCLK=0;
failures=0;
reset=1;
#(PERIOD) reset=0;

for(index = 1; index <= TESTCASECOUNT; index=index+1) begin
		$display("Running test set %d", index);
slaveDataToSend = testcase_SlaveDataToSend[index];
ExpectedMasterDataToReceive=8'bxxxxxxxx;
#(PERIOD) 
CS<=0; 
i=0;
#(PERIOD*9)
CS=1;

if(slaveDataReceived==testcase_MasterDataToSend[index])
	$display("Received Successfully : (Expected: %b, Received: %b)",testcase_MasterDataToSend[index],slaveDataReceived);
else begin
	$display("Receiving Failed : (Expected: %b, Received: %b)",testcase_MasterDataToSend[index],slaveDataReceived);
        failures=failures+1;
      end

if (ExpectedMasterDataToReceive == testcase_SlaveDataToSend[index])
	$display("Sent Successfully : (Expected: %b, Send: %b)",slaveDataToSend,ExpectedMasterDataToReceive);
else begin
	$display("Sending Failed : (Expected: %b, Send: %b)",slaveDataToSend,ExpectedMasterDataToReceive);
        failures=failures+1;
      end
end
if(failures) $display("FAILURE: %d out of %d testcases have failed", failures, TESTCASECOUNT);
	else $display("SUCCESS: All %d testcases have been successful", TESTCASECOUNT); 
end


always @(posedge SCLK) begin
if(!CS) begin
	MOSI <= testcase_MasterDataToSend[index][i];
	i<=i+1;
    end
end

always @(negedge SCLK) begin
if(!CS)
        ExpectedMasterDataToReceive <= {MISO,ExpectedMasterDataToReceive[7:1]};
  end
always
#(PERIOD/2) SCLK=~SCLK;

endmodule
