`timescale 1 ns / 100 ps

module test();

localparam                 TOTAL_TESTS         = 7;
localparam                 WIDTH               = 8;
localparam [WIDTH - 1:0]   MAX                 = 100;
localparam [WIDTH - 1:0]   MIN                 = 10;

wire       [WIDTH - 1 : 0] count;
reg                        clk;
reg                        rst;
reg                        en;
reg                        set;
reg        [3 : 0]         din;
reg        [3 : 0]         step;
reg                        up_down;
reg        [WIDTH - 1 : 0] temp_up_down;
reg        [WIDTH - 1 : 0] expected;
wire                       finish;

integer                    passed_tests_count;
integer                    failed_tests_count;
integer                    skipped_tests_count;
realtime                   start_capture;
realtime                   end_capture;
realtime                   all_tests_end;

initial
begin
    clk <= 1'b1;
    passed_tests_count <= 0;
    failed_tests_count <= 0;
    skipped_tests_count <= 0;
end

always
begin
    #1 clk = ~clk;
end

task check_work_with_en;
begin
    @(posedge clk);
    start_capture = $realtime;
    $display("\nTest check_work_with_en started. (Testing if counter is enabled with 'en').");

    rst = 1'b1;
    repeat(20)@(posedge clk);
    rst = 1'b0;

    en = 1'b1;
    set = 1'b0;
    din = 4'd10;
    step = 4'd1;
    up_down = 1'b1;

    repeat(20)@(posedge clk);
    if(count == 0)
    begin
        $display("Test check_work_with_en FAILED.");
        failed_tests_count = failed_tests_count + 1;
    end else begin
        $display("Test check_work_with_en PASSED.");
        passed_tests_count = passed_tests_count + 1;
    end

    $display("Test check_work_with_en ended.");
    end_capture = $realtime;
    $display("Time elapsed for this test: %t", end_capture - start_capture);
end
endtask //check_work_with_en

task check_work_without_en;
begin
    @(posedge clk);
    start_capture = $realtime;
    $display("\nTest check_work_without_en started. (Testing if counter is disabled without 'en').");

    rst = 1'b1;
    repeat(20)@(posedge clk);
    rst = 1'b0;

    en = 1'b0;
    set = 1'b0;
    din = 4'd10;
    step = 4'd1;
    up_down = 1'b1;

    repeat(20)@(posedge clk);

    if(count == 0)
    begin
        $display("Test check_work_without_en PASSED.");
        passed_tests_count = passed_tests_count + 1;
    end else begin
        $display("Test check_work_without_en FAILED.");
        failed_tests_count = failed_tests_count + 1;
    end

    $display("Test check_work_without_en ended.");
    end_capture = $realtime;
    $display("Time elapsed for this test: %t", end_capture - start_capture);
end
endtask //check_work_without_en

task check_set;
begin
    @(posedge clk);
    start_capture = $realtime;
    $display("\nTest check_set started. (Testing if counter set to 'din' with enabled 'set').");

    rst = 1'b1;
    repeat(20)@(posedge clk);
    rst = 1'b0;

    en = 1'b1;
    set = 1'b1;
    din = 4'd10;
    step = 4'd1;
    up_down = 1'b1;

    repeat(20)@(posedge clk);
    if(count == din)
    begin
        $display("Test check_set PASSED.");
        passed_tests_count = passed_tests_count + 1;
    end else begin
        $display("Test check_set FAILED.");
        failed_tests_count = failed_tests_count + 1;
    end

    $display("Test check_set ended.");
    end_capture = $realtime;
    $display("Time elapsed for this test: %t", end_capture - start_capture);
end
endtask //check_set

task check_not_set;
begin
    @(posedge clk);
    start_capture = $realtime;
    $display("\nTest check_not_set started. (Testing if counter isn't set to 'din' with disabled 'set').");

    rst = 1'b1;
    repeat(20)@(posedge clk);
    rst = 1'b0;

    en = 1'b1;
    set = 1'b0;
    din = 4'd10;
    step = 4'd1;
    up_down = 1'b1;

    repeat(20)@(posedge clk);
    if(count == din)
    begin
        $display("Test check_not_set FAILED.");
        failed_tests_count = failed_tests_count + 1;
    end else begin
        $display("Test check_not_set PASSED.");
        passed_tests_count = passed_tests_count + 1;
    end

    $display("Test check_not_set ended.");
    end_capture = $realtime;
    $display("Time elapsed for this test: %t", end_capture - start_capture);
end
endtask //check_not_set

task check_up_down;
begin
    @(posedge clk);
    start_capture = $realtime;
    $display("\nTest check_up_down started. (Testing if counter rises with amount of 'step').");

    rst = 1'b1;
    repeat(20)@(posedge clk);
    rst = 1'b0;

    en = 1'b1;
    set = 1'b0;
    din = 4'd10;
    step = 4'd1;
    up_down = 1'b1;

    repeat(18)@(posedge clk);
    temp_up_down = count;

    repeat(1)@(posedge clk);
    expected = temp_up_down + step;
    if(count == expected)
    begin
        $display("Test check_up_down PASSED.");
        passed_tests_count = passed_tests_count + 1;
    end else begin
        $display("Test check_up_down FAILED.");
        failed_tests_count = failed_tests_count + 1;
    end

    $display("Test check_up_down ended.");
    end_capture = $realtime;
    $display("Time elapsed for this test: %t", end_capture - start_capture);
end
endtask //check_up_down

task check_not_up_down;
begin
    @(posedge clk);
    start_capture = $realtime;
    $display("\nTest check_not_up_down started. (Testing if counter falls with amount of 'step').");

    rst = 1'b0;
    repeat(20)@(posedge clk);
    rst = 1'b0;

    en = 1'b1;
    set = 1'b0;
    din = 4'd10;
    step = 4'd1;
    up_down = 1'b0;

    repeat(18)@(posedge clk);
    temp_up_down = count;

    repeat(1)@(posedge clk);
    expected = temp_up_down - step;
    if(count == expected)
    begin
        $display("Test check_not_up_down PASSED.");
        passed_tests_count = passed_tests_count + 1;
    end else begin
        $display("Test check_not_up_down FAILED.");
        failed_tests_count = failed_tests_count + 1;
    end

    $display("Test check_not_up_down ended.");
    end_capture = $realtime;
    $display("Time elapsed for this test: %t", end_capture - start_capture);
end
endtask //check_not_up_down

task check_finish_works_properly;
begin
    @(posedge clk);
    start_capture = $realtime;
    $display("\nTest check_finish_works_properly started. (Testing if 'finish' is '1' when MIN or MAX reached).");

    rst = 1'b1;
    repeat(20)@(posedge clk);
    rst = 1'b0;

    en = 1'b1;
    set = 1'b0;
    din = 4'd10;
    step = 4'd1;
    up_down = 1'b1;

    repeat(101)@(posedge clk);
    if((count == MAX || count == MIN) && finish)
    begin
        $display("Test check_finish_works_properly PASSED.");
        passed_tests_count = passed_tests_count + 1;
    end else begin
        $display("Test check_finish_works_properly FAILED.");
        failed_tests_count = failed_tests_count + 1;
    end

    $display("Test check_finish_works_properly ended.");
    end_capture = $realtime;
    $display("Time elapsed for this test: %t", end_capture - start_capture);
end
endtask //check_finish_works_properly

initial
    begin
        $dumpvars;
        $timeformat(-9, 3, " ns", 10);
        $display("");
        $display("Starting tests...");
        check_work_with_en;
        check_work_without_en;
        check_set;
        check_not_set;
        check_up_down;
        check_not_up_down;
        check_finish_works_properly;

        if(passed_tests_count + failed_tests_count != TOTAL_TESTS)
        begin
            skipped_tests_count = TOTAL_TESTS - (passed_tests_count + failed_tests_count);
        end

        all_tests_end = $realtime;

        $display("");
        $display("TOTAL TESTS: %0d, PASSED: %0d, FAILED: %0d, SKIPPED: %0d.",
                    TOTAL_TESTS, passed_tests_count, failed_tests_count, skipped_tests_count);
        $display("Time elapsed for all tests: %0t", all_tests_end);
        $display("");

        #80 up_down = ~up_down;
        #1000 $finish;
    end //end of initial block

//instantiation of module 'counter'
counter #(.WIDTH(WIDTH),
          .MAX(MAX),
          .MIN(MIN))
         counter
         (.clk(clk),
          .rst(rst),
          .en(en),
          .set(set),
          .din(din),
          .step(step),
          .up_down(up_down),
          .count(count),
          .finish(finish));

endmodule //test
