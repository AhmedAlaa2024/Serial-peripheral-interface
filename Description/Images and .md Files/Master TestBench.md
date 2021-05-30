# Entity: Master_TB
## Diagram
![Diagram](Master TestBench.svg "Diagram")
## Description

## Generics and ports
### Table 1.1 Generics
### Table 1.2 Ports
## Signals, constants and types
### Signals
| Name                       | Type       | Description |
| -------------------------- | ---------- | ----------- |
| clk                        | reg        |             |
| reset                      | reg        |             |
| start                      | reg        |             |
| MISO                       | reg        |             |
| slaveSelect                | reg[1:0]   |             |
| masterDataToSend           | reg [7:0]  |             |
| masterDataReceived         | wire [7:0] |             |
| ExpectedSlaveDataToReceive | reg [7:0]  |             |
| SCLK                       | wire       |             |
| CS                         | wire [0:2] |             |
| MOSI                       | wire       |             |
| index                      | integer    |             |
| failures                   | integer    |             |
| i                          | integer    |             |
| testcase_MasterDataToSend  | wire [7:0] |             |
| testcase_SlaveDataToSend   | wire [7:0] |             |
### Constants
| Name          | Type | Value | Description |
| ------------- | ---- | ----- | ----------- |
| PERIOD        |      | 6     |             |
| TESTCASECOUNT |      | 4     |             |
## Processes
- **unnamed**: ***( @(posedge clk) )***

- **unnamed**: ***( @(negedge clk) )***

- **unnamed**: ***(  )***

## Instantiations
- **m**: Master

