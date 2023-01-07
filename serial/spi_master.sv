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
    localparam CLOCK_RATIO = SYSCLK_FREQ_MHZ/SCLK_FREQ_KHZ;

    logic sclk_c, sclk_r;

    always_ff@(posedge i_sys_clk) begin 

    end 

    always_comb begin 

    end 


    //MOSI State Machine
    enum logic [2:0] {
        WAIT_MOSI_REQ  ,
        WRITE_START_BIT,
        WRITE_DATA   
    } mosi_state_c, mosi_state_r;

    logic [MOSI_CNT_WIDTH-1:0] mosi_index_c, mosi_index_r;
    logic cs_n_c, cs_n_r;
    logic mosi_ack_c, mosi_ack_r;
    always_ff@(posedge i_sys_clk) begin 
        mosi_state_r  <= mosi_state_c;
        mosi_index_r  <= mosi_index_c;
        mosi_ack_r    <= mosi_ack_c;
        cs_n_r        <= cs_n_c;
    end 

    always_comb begin 
        mosi_state_c  = WAIT_MOSI_REQ;
        mosi_index_c  = 
        mosi_ack_c    = 0;
        cs_n_c        = 1;
        case(mosi_state_r)
            WAIT_MOSI_REQ : begin 

            end 
            WRITE_START_BIT : begin 

            end 
            WRITE_DATA : begin 

            end 
        endcase 
    end 

    //MISO State Machine


endmodule













