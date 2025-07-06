
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity big_endian_swap is
    port(
        CLK: in std_logic;
        RST_N: in std_logic;
        ETH_MDC: out std_logic;
        ETH_MDIO: inout std_logic; -- always 0
        ETH_RSTN: out std_logic;
        ETH_CRSDV: inout std_logic;
        ETH_RXERR: in std_logic;
        ETH_RXD: inout std_logic_vector(1 downto 0);
        ETH_TXEN: out std_logic;
        ETH_TXD: out std_logic_vector(1 downto 0);
        ETH_REFCLK: out std_logic;
        ETH_INTN: in std_logic
    );
end big_endian_swap;

-- Can take in either an array or single byte size for endian swap
-- flat or array driven
-- endian swap moves 8 bits or one byte from front to back and vice versa, it is reversable
architecture rtl of big_endian_swap is
signal reset_d1 : std_logic;
signal reset_d2 : std_logic;
signal rst_n : std_logic;

begin
    process 
    begin
        for i in 1 to INPUT_BYTES loop
            ENDIAN_OUTPUT(i*BYTE_SIZE-1 downto (i*BYTE_SIZE-1)-BYTE_SIZE ) <= ENDIAN_INPUT(((INPUT_BYTES-i+1)*BYTE_SIZE-1) downto ((INPUT_BYTES-i+1)*BYTE_SIZE-1)-BYTE_SIZE) ;
            ENDIAN_OUTPUT_ARRAY(i-1, BYTE_SIZE-1 downto 0) <= ENDIAN_INPUT(((INPUT_BYTES-i+1)*BYTE_SIZE-1) downto ((INPUT_BYTES-i+1)*BYTE_SIZE-1)-BYTE_SIZE);
        end loop;

    end process;

    process(clk) 
    begin
        reset_d1 <= RST_N;
        reset_d2 <= reset_d1;
        rst_n <= reset_d1;       
    end process;

    ETH_MDC <= '0'; -- this implementation doesn't use this

end rtl;

