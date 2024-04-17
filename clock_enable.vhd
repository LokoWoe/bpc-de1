library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all; 
use ieee.math_real.all; 

entity clock_enable is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btn_inc : in STD_LOGIC;
           btn_dec : in STD_LOGIC;
           pulse : out STD_LOGIC);
end entity clock_enable;

architecture Behavioral of clock_enable is
    
     signal period : std_logic_vector(27 downto 0) := "0101111101011110000100000000"; 
     signal sig_count : std_logic_vector(27 downto 0) := (others => '0');
     signal pulse_toggle : std_logic := '0'; 
   
begin

    p_clk_enable : process (clk) is
    begin
    
        if (rising_edge(clk)) then                 
            if (rst = '1') then                   
                sig_count <= (others => '0');    
                pulse     <= '0';   
                pulse_toggle <= '0';               

            elsif (btn_inc = '1') then
                period <= period + 25000000;
            elsif (btn_dec = '1') then
                period <= period - 25000000;
            
            else
                if (sig_count = (PERIOD - 1)) then
                sig_count <= (others => '0');     
                pulse <= pulse_toggle;
                pulse_toggle <= not pulse_toggle; 
                     
            else
                sig_count <= sig_count + 1;        
                pulse <= pulse_toggle;
            end if;                                
        end if;
    end if;
    end process p_clk_enable;

end Behavioral;
