library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top is
    port (
        CLK100MHZ : in    std_logic;
        SW        : in    std_logic_vector(8 downto 0);                 
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
    
    signal UP : std_logic;
    
    signal DOWN : std_logic;
    
    signal sig_en_2ms : STD_LOGIC;
    
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
            data0   : in    integer;
            data1   : in    integer;
            data2   : in    integer;
            data3   : in    integer;
            dp_vect : in    std_logic_vector(3 downto 0);
            dp      : out   std_logic;
            seg     : out   std_logic_vector(6 downto 0);
            dig     : out   std_logic_vector(3 downto 0)
        );
    end component;
    
    component debounce is
            Port ( 
                clk      : in STD_LOGIC;
                rst      : in STD_LOGIC;
                en       : in STD_LOGIC;
                bouncey  : in STD_LOGIC;
                clean    : out STD_LOGIC);
    end component debounce;
    
    component clock_enable is
            generic (
                PERIOD : integer
                    );
            Port ( clk : in STD_LOGIC;
                   rst : in STD_LOGIC;
                   pulse : out STD_LOGIC);
        end component clock_enable;

begin
    frekvence : process (frequency) is
    begin
    if (SW(8) = '1') then
            frequency <= 8000;
        elsif (SW(7) = '1') then
            frequency <= 5000;
        elsif (SW(6) = '1') then
            frequency <= 2000;
        elsif (SW(5) = '1') then
            frequency <= 1000;
        elsif (SW(4) = '1') then
            frequency <= 800;
        elsif (SW(3) = '1') then
            frequency <= 500;
        elsif (SW(2) = '1') then
            frequency <= 300;
        elsif (SW(1) = '1') then
            frequency <= 200;
        elsif (SW(0) = '1') then
            frequency <= 100;
        else 
            frequency <= 0;
        end if;   
    end process;
    
    frequency_1000  <= frequency / 1000;
    frequency_100   <= (frequency mod 1000) / 100;
    frequency_10    <= (frequency mod 100) / 10;
    frequency_1     <= (frequency mod 10);
    
    bounce : clock_enable
        generic map(
                    PERIOD => 200_000)
       
        port map(
                    clk => CLK100MHZ,
                    rst => BTNC,
                    pulse => sig_en_2ms);
    
    driver_seg : component driver
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            
            data3 => frequency_1000,   
            data2 => frequency_100,
            data1 => frequency_10,
            data0 => frequency_1,
            
            dp_vect => "1111",
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
    
    debouncerUP : debounce
        port map(
                    clk => CLK100MHZ,
                    rst => BTNC,
                    bouncey => BTNU,
                    en => sig_en_2ms,
                    clean => UP);
                    
    debouncerDOWN : debounce
        port map(
                    clk => CLK100MHZ,
                    rst => BTNC,
                    bouncey => BTND,
                    en => sig_en_2ms,
                    clean => DOWN);
    
    AN(7 downto 4) <= b"1111";

end architecture behavioral;