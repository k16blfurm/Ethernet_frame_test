library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
    generic(
        byte_width : natural := 8;
        fifo_depth : integer := 10
    );
    port(
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
end fifo;

architecture rtl of fifo is
    type fifo_storage is array (0 to fifo_depth-1) of std_logic_vector(byte_width-1 downto 0);
    signal fifo_data : fifo_storage := (others => (others => '0'));

    signal read_index : integer range 0 to fifo_depth-1 := 0;
    signal write_index : integer range 0 to fifo_depth-1 := 0;
   
    signal fifo_count : integer range -1 to fifo_depth-1 := 0;

    signal full : std_logic;
    signal empty : std_logic;

begin

fifo_process : process (clk) is
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

 
        
rd_data <= fifo_data(read_index);

full <= '1' when fifo_count = fifo_depth else '0';
full <= '1' when fifo_count = 0 else '0';

out_full <= full;
out_empty <= empty;



end rtl;