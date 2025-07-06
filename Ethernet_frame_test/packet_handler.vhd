library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity packet_handler is
     generic(
        mii_width : integer := 2;
        byte_width : natural := 8;
        fifo_depth : integer := 10
    );
    port(
        reset: in std_logic;
        clk: in std_logic;

        -- Will not use axi till it's implemented
        s_axis_tdata : in std_logic_vector(7 downto 0);
        s_axis_tvalid : in std_logic;
        s_axis_tready : out std_logic;

        -- transmit the frame out
        tx_en : out std_logic;
        txd : out std_logic_vector(mii_width-1 downto 0);
    );
end packet_handler;

architecture rtl of packet_handler is
    signal source_mac : std_logic_vector(47 downto 0) := x"deadbeefdead";
    signal destination_mac : std_logic_vector(47 downto 0) := x"deadbeefdead";
    -- these are hardcoded
    signal packet_byte_size : integer := 2; 

    -- signals for packet_handler
    signal wr_en : std_logic;
    signal wr_data : std_logic_vector(byte_width-1 downto 0);
    signal  out_full :  std_logic;
    signal rd_en :  std_logic;
    signal rd_data :  std_logic_vector(byte_width-1 downto 0);
    signal out_empty :  std_logic;

    --crc signals
    signal crcIn : std_logic_vector(31 downto 0);
    signal data_crc : std_logic_vector(7 downto 0);
    signal crcOut : std_logic_vector(31 downto 0);

    --type ethernet_header is array (0 to fifo_depth-1) of std_logic_vector(byte_width-1 downto 0);
    type ethernet_header is record
        subtype eth_type_length is array (1 downto 0) of std_logic_vector(7 downto 0);
        subtype mac_source is array (5 downto 0) of std_logic_vector(7 downto 0);
        subtype mac_destination is array (5 downto 0) of std_logic_vector(7 downto 0);        
    end record ethernet_header;

    component fifo port(
        reset: in std_logic;
        clk: in std_logic;

        -- write side
        wr_en : in std_logic;
        wr_data : in std_logic_vector(byte_width-1 downto 0);
        out_full : out std_logic;

        -- read side

        rd_en : in std_logic;
        rd_data : out std_logic_vector(byte_width-1 downto 0);
        out_empty : out std_logic
    );
    end component;

    component crc port(
        crcIn: in std_logic_vector(31 downto 0);
        data: in std_logic_vector(7 downto 0);
        crcOut: out std_logic_vector(31 downto 0)
    );
    end component;

    

fifo_packets : fifo port map (
    reset => reset,
    clk => clk,
    wr_en => wr_en,
    wr_data => wr_data,
    out_full => out_full,
    rd_en => rd_en,
    rd_data => rd_data,
    out_empty => out_empty
);

crc32 : crc port map(
    crcIn => crcIn,
    data => data_crc,
    crcOut => crcOut
);

ethernet_frame : process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                fifo_count  <= 0;
                write_index <= 0;
                read_index  <= 0;
            else 
                -- can only write or read at a single time
                if(wr_en = '1' and rd_en = '0') then
                    fifo_count <= fifo_count + 1;
                elsif(wr_en = '0' and rd_en = '1') then
                    fifo_count <= fifo_count - 1;
                end if;

                -- write index handler 
                if(wr_en = '1' and full = '0') then
                    write_index <= 0;
                else 
                    write_index <= write_index + 1;
                end if;

                if (rd_en = '0' and empty = '0') then
                    read_index <= 0;
                else 
                    read_index <= read_index + 1;
                end if;

                if wr_en = '1' then
                    fifo_data(write_index) <= wr_data;
                end if;
            end if;
            end if;
        end process fifo_process;

 
-- send out data on bus for tx of ethernet
txd <= tx_data;



end rtl;
