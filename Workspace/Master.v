module Master(
	input            clk,
   input            reset,
	input            start, 
   input      [1:0] slaveSelect,
   input      [7:0] masterDataToSend,
   output reg [7:0] masterDataReceived,
   output           SCLK,
	output reg [0:2] CS,
   output reg       MOSI,
   input            MISO
);
/*
                      Master Model Design

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
  
   integer counter = 0;
   reg flag = 1; // Flag is raised to high when the transmision and recieving process is terminated!   
   reg [7:0] buffer; // Buffer to store a copy of recieved data
   assign SCLK = clk;

always @(negedge SCLK) begin
   if(start)begin
      if(slaveSelect == 2'b00)     // If SlaveSelect = 0
         CS<=3'b011; // Open the connection to the first Slave and close the reset
      else if(slaveSelect == 2'b01) // If SlaveSelect = 1
         CS<=3'b101; // Open the connection to the second Slave and close the reset
      else if(slaveSelect == 2'b10) // If SlaveSelect = 2
         CS<=3'b110; // Open the connection to the third Slave and close the reset
      else // If any wrong number received by the SlaveSelect
         CS<=3'b111; // Close all the connections to all the slaves

      masterDataReceived <= 'bxxxxxxxx; // To initialize the masterDataReceived by unknowns bit
      buffer <= masterDataToSend; // To be shifted bit by bit
      counter <= 1; // Initialize the counter by 1
      flag<=0; // To initialize the flag by 0
   end
end

always @(posedge SCLK or posedge reset) begin // Data Shifting
   if (counter > 8) begin // If all Data have been recived successfully
      flag <=1;         // Tranmission is Terminated so raise the flag!
      CS <= 3'b111;     // Close all the connections between the master and slaves
   end
   if (reset) // If Reset bit is triggered
      buffer <= 0; // Remove the data in the buffer
   else if (!flag) begin // If the flag is not raised yet
      MOSI <= buffer[0]; // Send one bit from the rightmost (LSB) of the buffer to the conected Slave
   end
end


always @(negedge SCLK) begin // Data Sampling

   if(!flag) begin // If the flag is not raised yet
      buffer <= {MISO, buffer[7:1]}; // Shift the buffer one bit right and put the MISO bit in the leftmost bit (MSB)
      masterDataReceived <= {MISO, masterDataReceived[7:1]}; // Shift the masterDataReceived one bit right and put the MISO bit in the rightmost bit
      counter <= counter + 1; // Increament the counter by 1
   end  
end


endmodule