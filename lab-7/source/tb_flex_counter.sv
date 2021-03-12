// $Id: $
// File name:   tb_flex_counter.sv
// Version:     1.0  Initial Design Entry
// Description: Test Bench for Flex Counter

`timescale 1ns / 100ps

module tb_flex_counter();

  // Define local parameters used by the test bench
  localparam  CLK_PERIOD    = 2.5;
  localparam  FF_SETUP_TIME = 0.190;
  localparam  FF_HOLD_TIME  = 0.100;
  localparam  CHECK_DELAY   = (CLK_PERIOD - FF_SETUP_TIME); // Check right before the setup time starts
  localparam  INACTIVE_VALUE     = 1'b0;
  localparam  RESET_OUTPUT_VALUE = INACTIVE_VALUE;
  localparam  NUM_CNT_BITS = 4;
  
  // Declare DUT portmap signals
  reg tb_clk;
  reg tb_n_rst;
  reg tb_clear;
  reg tb_count_enable;
  reg [NUM_CNT_BITS-1:0] tb_rollover_val;
  reg [NUM_CNT_BITS-1:0] tb_count_out;
  reg tb_rollover_flag;
  
  // Declare test bench signals
  logic [2:0] tb_test_num;
  string tb_test_case;
  integer tb_stream_test_num;
  
  // Task for standard DUT reset procedure
  task reset_dut;
  begin
    // Activate the reset
    tb_n_rst = 1'b0;

    // Maintain the reset for more than one cycle
    @(posedge tb_clk);
    @(posedge tb_clk);

    // Wait until safely away from rising edge of the clock before releasing
    @(negedge tb_clk);
    tb_n_rst = 1'b1;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    @(negedge tb_clk);
    @(negedge tb_clk);
  end
  endtask

  // Task to cleanly and consistently check DUT output values
  task check_output;
    input logic  expected_out;
    input string check_tag;
    input logic  expected_flag;
  begin
    if(expected_out == tb_count_out) begin // Check passed
      $info("Correct count_out output %s test case", tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect count_out output %s test case", tb_test_case);
    end    
    if(expected_flag == tb_rollover_flag) begin // Check passed
      $info("Correct rollover_flag output %s test case", tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect rollover_flag output %s test case", tb_test_case);
    end

  end
  endtask

  // Task to safely operate clear
  task clear;
  begin
    @(posedge tb_clk);
    tb_clear = 1'b1;
    @(posedge tb_clk);
    tb_clear = 1'b0;
  end
  endtask

  // Clock generation block
  always
  begin
    // Start with clock low to avoid false rising edge events at t=0
    tb_clk = 1'b0;
    // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
  end
  
  // DUT Port map
  flex_counter DUT(.clk(tb_clk), .n_rst(tb_n_rst), .clear(tb_clear), .count_enable(tb_count_enable), .rollover_val(tb_rollover_val), .count_out(tb_count_out), .rollover_flag(tb_rollover_flag));  
  // Test bench main process
  initial
  begin
    // Initialize all of the test inputs
    tb_n_rst  = 1'b1;              // Initialize to be inactive
    tb_clear = 1'b0;
    tb_count_enable = 1'b0;
    tb_test_num = 0;               // Initialize test case counter
    tb_test_case = "Test bench initializaton";
    // Wait some time before starting first test case
    #(0.1);
    
    // ************************************************************************
    // Test Case 1: Power-on Reset of the DUT
    // ************************************************************************
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Power on Reset";
    // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
    // Wait some time before applying test case stimulus
    #(0.1);
    // Apply test case initial stimulus
    tb_n_rst  = 1'b0;    // Activate reset
    
    // Wait for a bit before checking for correct functionality
    #(CLK_PERIOD * 0.5);

    // Check that internal state was correctly reset
    check_output( RESET_OUTPUT_VALUE,
                  "after reset applied", 1'b0);
    
    // Check that the reset value is maintained during a clock cycle
    #(CLK_PERIOD);
    check_output( RESET_OUTPUT_VALUE, 
                  "after clock cycle while in reset", 1'b0);
    
    // Release the reset away from a clock edge
    @(posedge tb_clk);
    #(2 * FF_HOLD_TIME);
    tb_n_rst  = 1'b1;   // Deactivate the chip reset
    #0.1;
    // Check that internal state was correctly keep after reset release
    check_output( RESET_OUTPUT_VALUE, 
                  "after reset was released", 1'b0);

    // ************************************************************************
    // Test Case 2: Rollover to 3
    // ************************************************************************    
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Rollover to 3";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    reset_dut();
    clear();

    // Assign test case stimulus
    tb_clear = 1'b0;
    tb_rollover_val = 3;
    tb_count_enable = 1'b1;

    // Wait for DUT to process stimulus before checking results
    @(posedge tb_clk);
    @(posedge tb_clk);
    @(posedge tb_clk);
    // Check results
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(3,
                  "after processing delay", 1'b0);

    // ************************************************************************
    // Test Case 3: Continuous Count
    // ************************************************************************  
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continuous Count";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    reset_dut();
    clear();

    // Assign test case stimulus
    tb_clear = 1'b0;
    tb_rollover_val = 3;
    tb_count_enable = 1'b1;

    // Wait for DUT to process stimulus before checking results
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(3,
                  "after processing delay", 1'b0);
    
    // ************************************************************************    
    // Test Case 4: Discontinuous Count
    // ************************************************************************
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Discontinous Count";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    clear();

    // Assign test case stimulus
    tb_clear = 1'b0;
    tb_rollover_val = 2;
    tb_count_enable = 1'b1;

    // Wait for DUT to process stimulus before checking results
    @(posedge tb_clk); 
    tb_count_enable = 1'b0;
    @(posedge tb_clk); 
    @(posedge tb_clk); 

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(1'b1,
                  "after processing delay", 1'b0);

    // ************************************************************************
    // Test Case 5: Count/Clear Priority
    // ************************************************************************
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Count/Clear Priority";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    reset_dut();
    clear();

    // Assign test case stimulus
    tb_clear = 1'b0;
    tb_rollover_val = 3;
    tb_count_enable = 1'b1;

    // Wait for DUT to process stimulus before checking results
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    tb_clear = 1'b1;
    @(posedge tb_clk); 
    @(posedge tb_clk); 

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(1'b0,
                  "after processing delay", 1'b0);
    end

endmodule
