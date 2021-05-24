# Entity: Slave_TB
## Diagram
![Diagram](Slave TestBench.svg "Diagram")
## Description

## Generics and ports
### Table 1.1 Generics
### Table 1.2 Ports
## Signals, constants and types
### Signals
| Name                        | Type       | Description |
| --------------------------- | ---------- | ----------- |
| reset                       | reg        |             |
| SCLK                        | reg        |             |
| CS                          | reg        |             |
| MOSI                        | reg        |             |
| MISO                        | wire       |             |
| slaveDataToSend             | reg [7:0]  |             |
| ExpectedMasterDataToReceive | reg [7:0]  |             |
| slaveDataReceived           | wire [7:0] |             |
| index                       | integer    |             |
| failures                    | integer    |             |
| i                           | integer    |             |
| testcase_MasterDataToSend   | wire [7:0] |             |
| testcase_SlaveDataToSend    | wire [7:0] |             |
### Constants
| Name          | Type | Value | Description |
| ------------- | ---- | ----- | ----------- |
| PERIOD        |      | 6     |             |
| TESTCASECOUNT |      | 4     |             |
## Processes
- **unnamed**: ***( @(posedge SCLK) )***

- **unnamed**: ***( @(negedge SCLK) )***

- **unnamed**: ***(  )***

## Instantiations
- **s**: Slave

