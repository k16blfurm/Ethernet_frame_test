library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ethernet_package_pkg.all;

entity ethernet_header_gen is
    generic(
        SOURCE_MAC : std_logic_vector(47 downto 0) := x"he86a64e7e830";
        DEST_MAC : std_logic_vector(47 downto 0) := x"he86a64e7e830";
        PACKET_PAYLOAD_BYTES : std_logic_vector(47 downto 0) := 128
    );
    port(
        output_header : out type is ethernet_header
    );
end ethernet_header_gen;

architecture rtl of ethernet_header_gen is

component  big_endian_swap is
    generic(
        BYTE_SIZE : integer := 8;
        INPUT_BYTES : integer := 4
    );
    port(
        ENDIAN_INPUT: in std_logic_vector(BYTE_SIZE*INPUT_BYTES downto 0);
        ENDIAN_OUTPUT: in std_logic_vector(BYTE_SIZE*INPUT_BYTES downto 0);
        ENDIAN_OUTPUT_ARRAY : out type is array (INPUT_BYTES-1 downto 0 ) of std_logic_vector(BYTE_SIZE-1 downto 0)
    );
end component;


begin
        big_endian_swap_1 : big_endian_swap
        generic map(
            BYTE_SIZE <= 8,
            INPUT_BYTES <= 6
        );
        port map(
            ENDIAN_INPUT <= SOURCE_MAC,
            ENDIAN_OUTPUT <= open,
            ENDIAN_OUTPUT_ARRAY <= ethernet_header(mac_source)
        );


        big_endian_swap_1 : big_endian_swap
        generic map(
            BYTE_SIZE <= 8,
            INPUT_BYTES <= 6
        );
        port map(
            ENDIAN_INPUT <= DEST_MAC,
            ENDIAN_OUTPUT <= open,
            ENDIAN_OUTPUT_ARRAY <= ethernet_header(mac_destination)
        );


        big_endian_swap_1 : big_endian_swap
        generic map(
            BYTE_SIZE <= 8,
            INPUT_BYTES <= 6
        );
        port map(
            ENDIAN_INPUT <= PACKET_PAYLOAD_BYTES,
            ENDIAN_OUTPUT <= open,
            ENDIAN_OUTPUT_ARRAY <= ethernet_header(ethernet_type_length)
        );




end rtl;


