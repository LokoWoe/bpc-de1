library ieee;
    use ieee.std_logic_1164.all;

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
        BTNC      : in    std_logic                      
    );
end entity top;

architecture behavioral of top is
    component driver is
        port (
            clk     : in    std_logic;
            rst     : in    std_logic;
            data0   : in    std_logic_vector(3 downto 0);
            data1   : in    std_logic_vector(3 downto 0);
            data2   : in    std_logic_vector(3 downto 0);
            data3   : in    std_logic_vector(3 downto 0);
            dp_vect : in    std_logic_vector(3 downto 0);
            dp      : out   std_logic;
            seg     : out   std_logic_vector(6 downto 0);
            dig     : out   std_logic_vector(3 downto 0)
        );
    end component;

begin


    driver_seg : component driver
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            data3(3) => SW(15),
            data3(2) => SW(14),
            data3(1) => SW(13),
            data3(0) => SW(12),

            data2(3) => SW(11),
            data2(2) => SW(10),
            data2(1) => SW(9),
            data2(0) => SW(8),

            data1(3) => SW(7),
            data1(2) => SW(6),
            data1(1) => SW(5),
            data1(0) => SW(4),

            data0(3) => SW(3),
            data0(2) => SW(2),
            data0(1) => SW(1),
            data0(0) => SW(0),

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