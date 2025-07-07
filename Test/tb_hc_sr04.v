`timescale 1ns / 1ps

module hc_sr04_tb;

  // Inputs
  reg clk;
  reg rst;
  reg en;
  reg echo;

  // Wires
  wire measure;
  wire trig;
  wire [1:0] state;
  wire ready;
  wire [21:0] distanceRAW;

  // DUT
  refresher250ms refresher (
    .clk(clk),
    .en(en),
    .measure(measure)
  );

  hc_sr04 uut (
    .clk(clk),
    .rst(rst),
    .measure(measure),
    .state(state),
    .ready(ready),
    .echo(echo),
    .trig(trig),
    .distanceRAW(distanceRAW)
  );

  // Clock generation (100 MHz)
  always #5 clk = ~clk;

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, hc_sr04_tb);

    clk = 0;
    rst = 1;
    en = 0;
    echo = 0;

    #100;
    rst = 0;
    en = 1;

    // -----------------------------
    // CASE 1: echo = 1ms (17cm)
    // -----------------------------
    wait(measure == 1);
    #10;
    wait(trig == 1);
    $display("\n[CASE 1] 1ms ECHO → Expect ~17cm");
    echo = 1;
    #1000000;  // 1ms
    echo = 0;

    #100000;  // wait measurement finalize
    $display("Measured distanceRAW = %d", distanceRAW);
    $display("Expected distance_cm ≈ 17cm");

    // -----------------------------
    // CASE 2: echo = 1.47ms (25cm)
    // -----------------------------
    wait(measure == 1);
    #10;
    wait(trig == 1);
    $display("\n[CASE 2] 1.47ms ECHO → Expect ~25cm");
    echo = 1;
    #1470000;  // 1.47ms
    echo = 0;

    #100000;
    $display("Measured distanceRAW = %d", distanceRAW);
    $display("Expected distance_cm ≈ 25cm");

    // -----------------------------
    // CASE 3: echo = 2.94ms (50cm)
    // -----------------------------
    wait(measure == 1);
    #10;
    wait(trig == 1);
    $display("\n[CASE 3] 2.94ms ECHO → Expect ~50cm");
    echo = 1;
    #2940000;  // 2.94ms
    echo = 0;

    #100000;
    $display("Measured distanceRAW = %d", distanceRAW);
    $display("Expected distance_cm ≈ 50cm");

    $finish;
  end

endmodule
