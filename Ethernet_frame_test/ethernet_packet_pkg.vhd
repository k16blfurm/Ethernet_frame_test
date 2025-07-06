-- making package for ethernet header
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ethernet_header_package is

        type ethernet_header is record 
            ethernet_type_length : type is array (1 downto 0 ) of std_logic_vector(7 downto 0);
            mac_source : type is array (5 downto 0 ) of std_logic_vector(7 downto 0);
            mac_destination : type is array (5 downto 0 ) of std_logic_vector(7 downto 0);
        end record ethernet_header;

end package ethernet_header_package;
