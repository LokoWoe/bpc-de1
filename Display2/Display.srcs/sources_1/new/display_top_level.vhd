library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top is
    port (
        CLK100MHZ : in    std_logic;                     
        SW        : in    std_logic_vector(15 downto 0); 
        CA        : out   std_logic;                     
        CB        : out   std_logic;                     
        CC        : out   std_logic;                     
        CD        : out   std_logic;                     
        CE        : out   std_logic;                     
        CF        : out   std_logic;                     
        CG        : out   std_logic;                     
        DP        : out   std_logic;                     
        AN        : out   std_logic_vector(7 downto 0);  
        BTNC      : in    std_logic;
        BTNU      : in    std_logic; 
        BTND      : in    std_logic                                            
    );
end entity top;

architecture behavioral of top is
    
    
    signal freq_counter : integer range 0 to 8 := 0;
    
    signal frequency: integer;
    
    signal frequency_1000 : integer;
    signal frequency_100 : integer;    
    signal frequency_10 : integer;
    signal frequency_1 : integer;
    
       component driver is
        port (
            clk     : in    std_logic;
            rst     : in    std_logic;
            data0   : in    integer range 0 to 9;
            data1   : in    integer range 0 to 9;
            data2   : in    integer range 0 to 9;
            data3   : in    integer range 0 to 9;
            dp_vect : in    std_logic_vector(3 downto 0);
            dp      : out   std_logic;
            seg     : out   std_logic_vector(6 downto 0);
            dig     : out   std_logic_vector(3 downto 0)
        );
    end component;

begin
    frekvence : process (frequency) is
    begin
    case freq_counter is 
        when 0 =>
            frequency <= 100;
        when 1 =>
            frequency <= 200;
        when 2 =>
            frequency <= 300;
        when 3 =>
            frequency <= 500;
        when 4 =>
            frequency <= 800;
        when 5 =>
            frequency <= 1000;
        when 6 =>
            frequency <= 2000;
        when 7 =>
            frequency <= 5000;
        when 8 =>
            frequency <= 8000;
        when others =>
            frequency <= 0;   
    end case;
    end process;
    
    frequency_1000  <= frequency / 1000;
    frequency_100   <= (frequency mod 1000) / 100;
    frequency_10    <= (frequency mod 100) / 10;
    frequency_1     <= (frequency mod 10);
    
    process is
    begin
        
        if (BTNU = '1') then
            if (freq_counter < 8) then
                freq_counter <= freq_counter + 1;
            end if;
        end if;
        
        if (BTND = '1') then
            if (freq_counter > 0) then
                freq_counter <= freq_counter - 1;
            end if;
        end if;
    end process;
    
    driver_seg : component driver
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            
            data3 => frequency_1000,   
            data2 => frequency_100,
            data1 => frequency_10,
            data0 => frequency_1,
            
            dp_vect => "0111",
            dp      => DP,

            seg(6) => CA,
            seg(5) => CB,
            seg(4) => CC,
            seg(3) => CD,
            seg(2) => CE,
            seg(1) => CF,
            seg(0) => CG,

            dig(3 downto 0) => AN(3 downto 0)
        );

    AN(7 downto 4) <= b"1111";

end architecture behavioral;