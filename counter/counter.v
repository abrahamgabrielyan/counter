module counter #(parameter                WIDTH = 1,
                 parameter  [WIDTH - 1:0] MAX = 0,
                 parameter  [WIDTH - 1:0] MIN = 0)
(
                 input                    clk,
                 input                    rst,
                 input                    en,
                 input                    set,
                 input      [3 : 0]       din,
                 input      [3 : 0]       step,
                 input                    up_down,
                 output reg [WIDTH - 1:0] count,
                 output reg               finish
);

always@(*)
begin
    if(up_down) begin
        if(count >= MAX) begin
            finish <= 1'b1;
        end else begin
            finish <= 1'b0;
        end
    end else if (count <= MIN) begin
        finish <= 1'b1;
    end else if (count > MAX) begin
        finish <= 1'b0;
    end
end //end of always block

always@ (posedge clk)
begin
    if(rst) begin
        count <= {(WIDTH){1'b0}};
    end else if (en) begin
        if(set) begin
            count <= din;
        end else begin
            if(up_down) begin
                if(count < MAX) begin
                    count <= count + step;
                end
            end else begin
                if(count > MIN) begin
                    count <= count - step;
                end
            end
        end
    end
end //end of always block
endmodule //counter
