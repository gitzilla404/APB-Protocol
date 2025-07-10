
    `include "apb.v"

    module APB_Test;
        reg clk;
        reg presetn;
        reg [31:0] paddr;
        reg pselect;
        reg pwrite;
        reg [31:0] pwdata;
        reg penable;
        wire [31:0] prdata;
        wire pready;
        wire pslver;
        wire busy;

        apb apb_inst (
            .clk(clk),
            .presetn(presetn),
            .paddr(paddr),
            .pselect(pselect),
            .pwrite(pwrite),
            .pwdata(pwdata),
            .penable(penable),
            .prdata(prdata),
            .pready(pready),
            .pslver(pslver),
            .busy(busy)
        );

        // Clock generation
        initial clk = 0;
        always #5 clk = ~clk;

        // Test sequence
        initial begin
            // Dump waves for GTKWave
            $dumpfile("apb_test.vcd");
            $dumpvars(0, APB_Test);

            // Initialize signals
            presetn = 0;
            paddr = 0;
            pselect = 0;
            pwrite = 0;
            pwdata = 0;
            penable = 0;

            // Reset
            #12;
            presetn = 1;
            #10;

            // Write to address 0x01
            apb_write(32'h01, 32'hA5A5A5A5);

            // Read from address 0x01
            apb_read(32'h01);

            // Write to address 0x10
            apb_write(32'h10, 32'h12345678);

            // Read from address 0x10
            apb_read(32'h10);

            // Access invalid address (should trigger error)
            apb_read(32'h20);

            // Wait and finish
            #50;
            $finish;
        end

        // APB write task
        task apb_write(input [31:0] addr, input [31:0] data);
        begin
            @(negedge clk);
            // entering setup phase ...
            paddr = addr;
            pwdata = data;
            pwrite = 1;
            pselect = 1;
            penable = 0;
            @(negedge clk);
            // entering access phase for write operation ...
            penable = 1;
            @(negedge clk);
            //entering idle phase after read operation
            pselect = 0;
            penable = 0;
            pwrite = 0;
            pwdata = 0;
        end
        endtask

        // APB read task
        task apb_read(input [31:0] addr);
        begin
            @(negedge clk);
            paddr = addr;
            pwrite = 0;
            pselect = 1;
            penable = 0;
            @(negedge clk);
            penable = 1;
            @(negedge clk);
            pselect = 0;
            penable = 0;
        end
        endtask

    endmodule