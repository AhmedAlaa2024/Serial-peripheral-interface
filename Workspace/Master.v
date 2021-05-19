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
     reg        [7:0] transmision_buffer;

   // RX MISO Operations
     output reg  [7:0] masterDataReceived;
     reg        [7:0] receiving_buffer;

   // Output Interface
     output reg [2:0] CS;
     output           SCLK;
     output reg       MOSI;

   // Input Interface
     input            MISO;

integer Transmision_counter = 0;
integer Receiving_counter   = 0;
integer Transmision_flag    = 0; // Flag is raised when the transmision process is finished!
integer Receiving_flag      = 0; // Flag is raised when the recieving process is finished!

   // Buffer to store a copy of recieved data
     reg        [7:0] buffer;

always @(posedge clk) begin // Data Shifting
   transmision_buffer <= masterDataToSend;

   case (slaveSelect)
	1: CS<=3'b110;
	2: CS<=3'b101;
	3: CS<=3'b011;
	default: CS<=3'b111;
   endcase

   if (Transmision_counter > 7)
	Transmision_flag <= 1;

   if (!Transmision_flag && start) begin
	MOSI <= masterDataToSend[0];
	transmision_buffer <= {MOSI, transmision_buffer[7:1]};
	Transmision_counter <= Transmision_counter + 1;
   end
end

always @(negedge clk or posedge reset) begin
   receiving_buffer <= masterDataReceived;

   case (slaveSelect)
   1: CS<=3'b110;
   2: CS<=3'b101;
   3: CS<=3'b011;
   default: CS<=3'b111;
   endcase

   if (reset)
   receiving_buffer <= 0;

   if(Receiving_counter > 7)
   Receiving_flag <= 1;

   if(!Receiving_flag) begin
   receiving_buffer <= {receiving_buffer[6:0],MISO};
   Receiving_counter <= Receiving_counter + 1;
   end

   masterDataReceived <= receiving_buffer;
end
endmodule
