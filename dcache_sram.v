module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    write_hit_i,
    tag_o,
    data_o,
    hit_o
);


// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;
input              write_hit_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;

// Memory
reg      [24:0]    tag [0:15][0:1];    
reg      [255:0]   data[0:15][0:1];
reg                use_next [0:15];
integer            i, j;

reg   [24:0]    tag_o;
reg   [255:0]   data_o;
reg             hit_o;

wire             hit_0;
wire             hit_1;
assign hit_0 = (tag_i[22:0] == tag[addr_i][0][22:0]) && tag[addr_i][0][24];
assign hit_1 = (tag_i[22:0] == tag[addr_i][1][22:0]) && tag[addr_i][1][24];

// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            use_next[i] <= 1'b0;
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        if (hit_0 || hit_1) begin
            if (hit_0) begin
                tag[addr_i][0]=tag_i;
                data[addr_i][0]=data_i;   

            end
            else if (hit_1) begin
                tag[addr_i][1]=tag_i;
                data[addr_i][1]=data_i;

            end
        end
        else begin
            if (use_next[addr_i]==1'b0) begin
                tag[addr_i][0]=tag_i;
                data[addr_i][0]=data_i;
                use_next[addr_i]=1'b1;

            end
            else if (use_next[addr_i]==1'b1) begin //use_rec[addr_i][1]==1'b0
                tag[addr_i][1]=tag_i;
                data[addr_i][1]=data_i;
                use_next[addr_i]=1'b0;

            end
        end

    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?
always@(*) begin
    if (enable_i) begin
        if (hit_0) begin
            hit_o<=1'b1;
            data_o<=data[addr_i][0];
            tag_o<=tag[addr_i][0];
            use_next[addr_i]=1'b1;
        end
        else if (hit_1) begin
            hit_o<=1'b1;
            data_o<=data[addr_i][1];
            tag_o<=tag[addr_i][1];
            use_next[addr_i]=1'b0;
        end
        else begin
            hit_o<=1'b0;
            // data_o=256'b0;
            //data_o<=data_i;
            if (use_next[addr_i]==1'b1) begin
                tag_o<=tag[addr_i][1];
                if (data[addr_i][1]==0) begin
                    data_o<=data_i;
                end
                else begin
                    data_o<=data[addr_i][1];
                end
            end
            else begin
                tag_o<=tag[addr_i][0];
                if (data[addr_i][0]==0) begin
                    data_o<=data_i;
                end
                else begin
                    data_o<=data[addr_i][0];
                end
            end
        end
    end
    
    else begin
        hit_o<=1'b0;
        // data_o=256'b0;
        data_o<=data_i;
        tag_o<=tag_i;
    end
    
end

endmodule

// assign hit_o = (enable_i && (((tag_i[22:0] == tag[addr_i][0][22:0]) && tag_i[24]) || ((tag_i[22:0] == tag[addr_i][1][22:0]) && tag_i[24])))
// assign hit = ((CPU_tag == sram_tag) && sram_valid);