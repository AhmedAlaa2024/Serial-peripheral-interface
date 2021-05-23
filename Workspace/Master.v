module Master(
	 input clk,
     input  reset,
	input   start, 
   input [1:0] slaveSelect
   , input   [7:0] masterDataToSend,
    output reg [7:0] masterDataReceived,
    output  SCLK,
	output reg [2:0] CS,
     output reg MOSI,

   // Input Interface
     input   MISO
);
/*
					 -------------------------------------
       		       		       o|reset				    CS|
					|start				      |
	      ---------------		|slaveSelect			      |
	     |MicroController|--------> |				      |		  -----
	      ---------------		|> clk				SCLK <|--------> |Slave|
					|				      |		  -----
					|masterDataToSend		  MOSI|
					|masterDataReceived		  MISO|
					 -------------------------------------
*/
  
   integer counter = 1;
   reg flag=0; // Flag is raised when the transmision and recieving process is being executed!

   // Buffer to store a copy of recieved data
   reg [7:0] buffer;


assign SCLK = clk;
assign flag = (counter < 9) ? 1: 0;

always @(posedge start ) begin
   // Setup Configurations
   
   if(slaveSelect == 2'b00)
   	CS<=3'b110;
   else if(slaveSelect == 2'b01) 
   	CS<=3'b101;
   else if(slaveSelect == 2'b10) 
	CS<=3'b011;
   else
      CS<=3'b111;

   masterDataReceived <= 'bxxxxxxxx;
   buffer <= masterDataToSend; //to be shifted one by one
   counter <= 1;
   //flag=1;
   
end





always @(posedge SCLK or posedge reset) begin // Data Shifting

if (reset)
  	 buffer <= 0;
else if (flag) begin
	MOSI <= buffer[0];

end
end



always @(negedge SCLK) begin 
   
   
   if (counter > 7) begin
	CS <= 3'b111; //anothor idea is to control the SCLK
   end

   if(flag) begin

      buffer <= {MISO, buffer[7:1]};
      masterDataReceived <= {MISO, masterDataReceived[7:1]};
      counter <= counter + 1;

      end  


   end


endmodule
