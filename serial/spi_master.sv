/******************************************************************************
Filename: spi_master.sv
Author: Dan Pikul
Date: 2023-01-06
Description: 

    SPI master module, capable of controlling a single slave peripheral. 

*******************************************************************************/

module spi_master#(
    parameter  SYSCLK_FREQ_MHZ = 100.0,
    parameter  SCLK_FREQ_MHZ   = 1.0  ,
    parameter  MAX_XFER_SIZE   = 32   ,
    localparam XFER_CNT_WIDTH  = $clog2(MAX_XFER_SIZE)
    )(
    //System Clock
    input  i_sys_clk,
    //PISO Interface
    input [MAX_XFER_SIZE -1:0] i_piso_data     ,
    input [XFER_CNT_WIDTH-1:0] i_piso_xfer_size,
    input                      i_piso_req      ,
    output                     o_piso_ack      ,
    //SIPO Interface
    output [MAX_XFER_SIZE -1:0] o_sipo_data,
    output                      o_sipo_rdy ,
    //SPI PHY Interface
    output o_slave_sclk,
    output o_slave_mosi,
    output o_slave_cs_n,
    input  i_slave_miso
    );


    //Slave Clock Driver
    localparam CLOCK_RATIO = $ceil(SYSCLK_FREQ_MHZ/SCLK_FREQ_KHZ);

    logic sclk_c, sclk_r;

    logic [$clog2(CLOCK_RATIO)-1:0] sclk_cnt_c, sclk_cnt_r;

    always_ff@(posedge i_sys_clk) begin 
        sclk_r     <= sclk_c;
        sclk_cnt_r <= sclk_cnt_c;
    end 

    always_comb begin 
        sclk_c     = sclk_cnt_r >= (CLOCK_RATIO >> 1);
        sclk_cnt_c = 0;
        if(~o_slave_cs_n) begin 
            sclk_cnt_c = sclk_cnt_r + 1;
            if(sclk_cnt_r == CLOCK_RATIO) begin 
                sclk_cnt_c == 0;
            end 
        end 
    end 


    //SPI Driver
    enum logic [2:0] {
        WAIT_XFER_REQ  ,
        WRITE_START_BIT,
        WRITE_DATA     
    } state_c, state_r;

    logic [MAX_XFER_SIZE-1:0] piso_buff_c, piso_buff_r,
                              sipo_buff_c, sipo_buff_r;
    logic [XFER_CNT_WIDTH-1:0] xfer_cnt_c, xfer_cnt_r;

    logic piso_ack_c, piso_ack_r;
    logic xfer_done_c, xfer_done_r;

    logic mosi_c, mosi_r;
    logic cs_n_c, cs_n_r;

    always_ff@(posedge i_sys_clk) begin 
        state_r     <= state_c;
        xfer_cnt_r  <= xfer_cnt_c;
        piso_ack_r  <= piso_ack_c;
        mosi_r      <= mosi_c;
        cs_n_r      <= cs_n_c;
        piso_buff_r <= piso_buff_c;
        sipo_buff_r <= sipo_buff_c;
        xfer_done_r <= xfer_done_c;
    end 

    always_comb begin 
        state_c     = WAIT_MOSI_REQ;
        xfer_cnt_c  = xfer_cnt_r;
        piso_ack_c  = 0;
        mosi_c      = mosi_r;
        cs_n_c      = 1;
        piso_buff_c = piso_buff_r;
        sipo_buff_c = sipo_buff_r;
        case(mosi_state_r)
            WAIT_XFER_REQ : begin 
                if(i_piso_req) begin 
                    state_c = WRITE_START_BIT;
                    cs_n_c  = 0;

                end 
            end 
            WRITE_START_BIT : begin 

            end 
            WRITE_DATA : begin 

            end 
        endcase 
    end 

    //Output Assignments
    assign o_piso_ack = piso_ack_r;

endmodule













