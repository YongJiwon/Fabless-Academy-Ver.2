`timescale 1ns / 1ps

module I2C_Salve #(
    parameter logic [6:0] SLAVE_ADDR = 7'h42
)(
    input  wire       clk,
    input  wire       reset_n,
    output logic [7:0] data_out,
    output logic       data_valid,
    inout  wire        sda,
    input  wire        scl
);
    typedef enum logic [4:0] {
        ST_IDLE,       // Idle bus state: wait for START condition
        ST_ADDR_LOW,   // Address phase: wait while SCL is low
        ST_ADDR_HIGH,  // Address phase: sample address/write bit while SCL is high
        ST_ADDR_ACK_L, // Address ACK phase: drive ACK low while SCL is low
        ST_ADDR_ACK_H, // Address ACK phase: hold ACK while SCL is high
        ST_DATA_LOW,   // Data phase: release SDA while SCL is low
        ST_DATA_HIGH,  // Data phase: sample write data while SCL is high
        ST_DATA_ACK_L, // Data ACK phase: drive ACK low while SCL is low
        ST_DATA_ACK_H, // Data ACK phase: hold ACK while SCL is high
        ST_WAIT_STOP   // Wait for STOP condition and make data_valid pulse
    } state_t;

    state_t state;

    logic [2:0] scl_sync;
    logic [2:0] sda_sync;
    logic [7:0] addr_byte;
    logic [7:0] data_byte;
    logic [2:0] bit_cnt;
    logic       sda_drive_low;
    logic       addr_match;
    logic       write_bit_ok;
    logic       data_ready;

    assign sda = sda_drive_low ? 1'b0 : 1'bz; // Open-drain SDA: drive only 0 or high-Z

    wire scl_rise = (scl_sync[2:1] == 2'b01);
    wire scl_fall = (scl_sync[2:1] == 2'b10);
    wire start_condition = (scl_sync[2] && (sda_sync[2:1] == 2'b10));
    wire stop_condition  = (scl_sync[2] && (sda_sync[2:1] == 2'b01));

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            scl_sync <= 3'b111;
            sda_sync <= 3'b111;
        end else begin
            scl_sync <= {scl_sync[1:0], scl};
            sda_sync <= {sda_sync[1:0], sda};
        end
    end

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state         <= ST_IDLE;
            data_out      <= 8'h00;
            data_valid    <= 1'b0;
            addr_byte     <= 8'h00;
            data_byte     <= 8'h00;
            bit_cnt       <= 3'd7;
            sda_drive_low <= 1'b0;
            addr_match    <= 1'b0;
            write_bit_ok  <= 1'b0;
            data_ready    <= 1'b0;
        end else begin
            data_valid <= 1'b0;

            if (start_condition) begin
                state         <= ST_ADDR_LOW;
                addr_byte     <= 8'h00;
                data_byte     <= 8'h00;
                bit_cnt       <= 3'd7;
                sda_drive_low <= 1'b0;
                addr_match    <= 1'b0;
                write_bit_ok  <= 1'b0;
                data_ready    <= 1'b0;
            end else begin
                case (state)
                    ST_IDLE: begin
                        sda_drive_low <= 1'b0;
                    end

                    ST_ADDR_LOW: begin
                        if (scl_rise) begin
                            addr_byte[bit_cnt] <= sda_sync[2];
                            if (bit_cnt == 3'd0) begin
                                addr_match   <= (addr_byte[7:1] == SLAVE_ADDR);
                                write_bit_ok <= (sda_sync[2] == 1'b0);
                                bit_cnt      <= 3'd7;
                                state        <= ST_ADDR_ACK_L;
                            end else begin
                                state <= ST_ADDR_HIGH;
                            end
                        end
                    end

                    ST_ADDR_HIGH: begin
                        if (scl_fall) begin
                            bit_cnt <= bit_cnt - 1'b1;
                            state   <= ST_ADDR_LOW;
                        end
                    end

                    ST_ADDR_ACK_L: begin
                        if (scl_fall) begin
                            sda_drive_low <= addr_match && write_bit_ok;
                            state         <= ST_ADDR_ACK_H;
                        end
                    end

                    ST_ADDR_ACK_H: begin
                        if (scl_rise) begin
                            state <= (addr_match && write_bit_ok) ? ST_DATA_LOW : ST_WAIT_STOP;
                        end
                    end

                    ST_DATA_LOW: begin
                        if (scl_fall) begin
                            sda_drive_low <= 1'b0;
                        end
                        if (scl_rise) begin
                            data_byte[bit_cnt] <= sda_sync[2];
                            if (bit_cnt == 3'd0) begin
                                data_out   <= {data_byte[7:1], sda_sync[2]};
                                data_ready <= 1'b1;
                                bit_cnt    <= 3'd7;
                                state      <= ST_DATA_ACK_L;
                            end else begin
                                state <= ST_DATA_HIGH;
                            end
                        end
                    end

                    ST_DATA_HIGH: begin
                        if (scl_fall) begin
                            bit_cnt <= bit_cnt - 1'b1;
                            state   <= ST_DATA_LOW;
                        end
                    end

                    ST_DATA_ACK_L: begin
                        if (scl_fall) begin
                            sda_drive_low <= 1'b1;
                            state         <= ST_DATA_ACK_H;
                        end
                    end

                    ST_DATA_ACK_H: begin
                        if (scl_rise) begin
                            state <= ST_WAIT_STOP;
                        end
                    end

                    ST_WAIT_STOP: begin
                        if (scl_fall) begin
                            sda_drive_low <= 1'b0;
                        end
                        if (stop_condition) begin
                            sda_drive_low <= 1'b0;
                            if (data_ready) begin
                                data_valid <= 1'b1;
                                data_ready <= 1'b0;
                            end
                            state <= ST_IDLE;
                        end
                    end

                    default: state <= ST_IDLE;
                endcase
            end
        end
    end
endmodule

