// code for apb protocol

// working :> 3 state 

module apb (
    input wire clk,           // clock signal 
    input wire presetn,       // active low reset 
    input wire [31:0] paddr,  // address bus 
    input wire pselect,       // slave select 
    input wire pwrite,        // write signal 
    input wire [31:0] pwdata, // write data 
    input wire penable,       // access phase indicator

    output reg [31:0] prdata, // data read 
    output reg pready,        // ready signal 
    output reg pslver,        // error signal 
    output reg busy           // busy signal
);

    // memory block
    reg [31:0] memory [31:0];

    // states
    localparam IDLE = 3'b000,
               SETUP = 3'b001,
               ACCESS = 3'b010;

    reg [2:0] curr_state, next_state;

    // state transition logic (sequential)
    always @(posedge clk or negedge presetn) begin 
        if (!presetn) begin
            curr_state <= IDLE;
            next_state <= IDLE;
            prdata <= 0;
            pready <= 0;
            pslver <= 0;
            busy <= 0;
        end
        else begin
            curr_state <= next_state;

            case (curr_state)
                IDLE: begin
                    if (pselect == 1 && penable == 0)
                        next_state <= SETUP;
                    else
                        next_state <= IDLE;
                end

                SETUP: begin
                    if (penable == 1 && pselect == 1)
                        next_state <= ACCESS;
                    else
                        next_state <= IDLE;
                end

                ACCESS: begin
                    if (pselect == 1 && penable == 1)
                        next_state <= SETUP;
                    else if (pselect == 0 && penable == 1)
                        next_state <= SETUP;
                    else
                        next_state <= IDLE;
                end

                default: next_state <= IDLE;
            endcase
        end
    end

    // data transfer and output control logic (combinational)
    always @(*) begin 
        if(pready==0) busy = 0;
        else busy =1;
        case (curr_state)
            IDLE: begin
                pslver <= 0;
                // busy <= 0;
                pready <= 0;
            end

            SETUP: begin
                pslver <= 0;
                // busy <= 0;
                pready <= 0;
            end

            ACCESS: begin
                pready <= 1;
                // busy <= 1;

                if (paddr > 32'h1F) begin
                    pslver <= 1;
                    busy <= 0;
                    prdata <= 32'hDEAD_BEEF;
                end 
                else begin
                    pslver <= 0;
                    if (pwrite == 1 && pselect == 1 && pready == 1)
                        memory[paddr] <= pwdata;
                    else if (pwrite == 0 && pselect == 1 && pready == 1)
                        prdata <= memory[paddr];
                end
            end
        endcase
    end

endmodule
