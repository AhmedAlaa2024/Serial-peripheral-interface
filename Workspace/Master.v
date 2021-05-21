module Master(
	clk, reset,
	start, slaveSelect, masterDataToSend, masterDataReceived,
	SCLK, CS, MOSI, MISO
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
   // Configurations
     input            reset;
     input            start;
     input      [1:0] slaveSelect;
     input            clk;

   // TX MOSI Operations
     input      [7:0] masterDataToSend;

   // RX MISO Operations
     output reg [7:0] masterDataReceived;

   // Output Interface
     output reg [2:0] CS;
     output           SCLK;
     output reg       MOSI;

   // Input Interface
     input            MISO;

     integer counter = 0;
     reg flag    = 0; // Flag is raised when the transmision and recieving process is being executed!

   // Buffer to store a copy of recieved data
     reg        [7:0] buffer;

always @(posedge start ) begin
   // Setup Configurations
   case (slaveSelect)
	1: CS<=3'b110;
	2: CS<=3'b101;
	3: CS<=3'b011;
	default: CS<=3'b111;
   endcase

   buffer <= masterDataToSend; //to be shifted one by one
   counter <= 0;
   flag <= 1; // the 
   masterDataReceived <= 8'bxxxxxxxx;
end


always @(posedge clk) begin // Data Shifting
   
   if (flag) begin
	MOSI <= buffer[0];
   end
end

always @(negedge clk or posedge reset) begin

   if (reset)
   buffer <= 0;
   else begin
      if (counter > 7)
	      flag <= 0;
      if(flag) begin
         buffer <= {MISO,buffer[7:1]};
         masterDataReceived <= {MISO,buffer[7:1]};
         counter <= counter + 1;
      end  
   end
end
endmodule