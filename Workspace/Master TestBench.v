module Master_TB();
//inputs
reg clk,reset,start,MISO;
reg[1:0] slaveSelect;
reg [7:0]masterDataToSend;
//ouput

wire [7:0]masterDataReceived;
reg [7:0] ExpectedSlaveDataToReceive;
wire SCLK;
wire [0:2] CS;
wire MOSI;
//
integer index,failures,i;
localparam PERIOD = 6;
localparam TESTCASECOUNT = 4;

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



Master m(
clk,
reset,
start,
slaveSelect,
masterDataToSend,
masterDataReceived,
SCLK,
CS,
MOSI,
MISO
);

initial begin
slaveSelect=1;
index=0;
ExpectedSlaveDataToReceive=0;
clk=0;
failures=0;
reset=1;
start=0;

#(PERIOD) reset=0;

for(index=1; index<=TESTCASECOUNT; index=index+1) begin


$display("Running test set %d", index);
masterDataToSend = testcase_MasterDataToSend[index]; 


start=1;
i=0;
#(PERIOD)

start=0;
#(PERIOD*9)

if(masterDataReceived==testcase_SlaveDataToSend[index])
	$display("Received Successfully");
else begin
	$display("Receiving Failed : (Expected: %b, Received: %b)",testcase_SlaveDataToSend[index],masterDataReceived);
        failures=failures+1;
end

if (ExpectedSlaveDataToReceive == testcase_MasterDataToSend[index])
	$display("Sent Successfully");
else begin
	$display("Sending Failed : (Expected: %b, Send: %b)",masterDataToSend,ExpectedSlaveDataToReceive);
        failures=failures+1;
      end
end
if(failures) $display("FAILURE: %d out of %d testcases have failed", failures, TESTCASECOUNT);
	else $display("SUCCESS: All %d testcases have been successful", TESTCASECOUNT); 

end
always @(posedge clk) begin
    if(!m.flag) 
begin
	MISO <= testcase_SlaveDataToSend[index][i];
	        i<=i+1;
    end
end
always @(negedge clk) begin
     
   if(!m.flag) 
        ExpectedSlaveDataToReceive <= {MOSI,ExpectedSlaveDataToReceive[7:1]};

  end

always
#(PERIOD/2) clk=~clk;
endmodule