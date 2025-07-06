library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity big_endian_swap is
    generic(
        BYTE_SIZE : integer := 8;
        INPUT_BYTES : integer := 4
    );
    port(
        ENDIAN_INPUT: in std_logic_vector(BYTE_SIZE*INPUT_BYTES downto 0);
        ENDIAN_OUTPUT: in std_logic_vector(BYTE_SIZE*INPUT_BYTES downto 0);
        ENDIAN_OUTPUT_ARRAY : out type is array (INPUT_BYTES-1 downto 0 ) of std_logic_vector(BYTE_SIZE-1 downto 0)
    );
end big_endian_swap;

-- Can take in either an array or single byte size for endian swap
-- flat or array driven
-- endian swap moves 8 bits or one byte from front to back and vice versa, it is reversable
architecture rtl of big_endian_swap is

begin
    process 
    begin
        for i in 1 to INPUT_BYTES loop
            ENDIAN_OUTPUT(i*BYTE_SIZE-1 downto (i*BYTE_SIZE-1)-BYTE_SIZE ) <= ENDIAN_INPUT(((INPUT_BYTES-i+1)*BYTE_SIZE-1) downto ((INPUT_BYTES-i+1)*BYTE_SIZE-1)-BYTE_SIZE) ;
            ENDIAN_OUTPUT_ARRAY(i-1, BYTE_SIZE-1 downto 0) <= ENDIAN_INPUT(((INPUT_BYTES-i+1)*BYTE_SIZE-1) downto ((INPUT_BYTES-i+1)*BYTE_SIZE-1)-BYTE_SIZE);
        end loop;

    end process;



end rtl;

