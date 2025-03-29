library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
    Port (
        nRST        : in  std_logic;                     -- Reset assíncrono ativo baixo
        XTAL_IN     : in  std_logic;                     -- Clock de entrada (cristal de 24 MHz)

        LCD_CLK     : out std_logic;                     -- Clock de pixel para o LCD
        LCD_HSYNC   : out std_logic;                     -- Sincronismo horizontal
        LCD_VSYNC   : out std_logic;                     -- Sincronismo vertical
        LCD_DEN     : out std_logic;                     -- Enable de display
        LCD_R       : out std_logic_vector(4 downto 0);  -- Componente vermelha (5 bits)
        LCD_G       : out std_logic_vector(5 downto 0);  -- Componente verde (6 bits)
        LCD_B       : out std_logic_vector(4 downto 0)   -- Componente azul (5 bits)

        
    );
end TOP;

architecture Behavioral of TOP is

    -- Declaração dos sinais internos
    signal CLK_SYS : std_logic;                       -- Clock do sistema (200 MHz)
    signal CLK_PIX : std_logic;                       -- Clock de pixel (33 MHz)

    -- Componente PLL (deve ser gerado pelo software da Gowin ou ferramenta equivalente)
    component Gowin_rPLL
        port (
            clkout  : out std_logic;                  -- Saída do clock principal (CLK_SYS)
            clkoutd : out std_logic;                  -- Saída do clock de pixel (CLK_PIX)
            clkin   : in  std_logic                   -- Entrada do clock (XTAL_IN)
        );
    end component;

    -- Componente VGA driver
    component lcd_demo
        port (
            nRst            :   in      std_logic;
            PixelClk        :   in      std_logic;
            LCD_R           :   out     std_logic_vector(4 downto 0);
            LCD_G           :   out     std_logic_vector(5 downto 0);
            LCD_B           :   out     std_logic_vector(4 downto 0);
            LCD_VSYNC       :   out     std_logic;
            LCD_HSYNC       :   out     std_logic;
            LCD_DE          :   out     std_logic
        );
    end component;

begin

    -- Instanciação do PLL
    chip_pll : Gowin_rPLL
    port map (
        clkout  => CLK_SYS,                           -- Saída do clock do sistema (200 MHz)
        clkoutd => CLK_PIX,                          -- Saída do clock de pixel (33 MHz)
        clkin   => XTAL_IN                           -- Clock de entrada (24 MHz)
    );

    -- Instanciação do driver VGA
    lcd_inst : lcd_demo
    port map (
        nRst      => nRST,                           -- Reset assíncrono
        PixelClk  => CLK_PIX,                        -- Clock de pixel
        LCD_DE    => LCD_DEN,                        -- Enable de display
        LCD_HSYNC => LCD_HSYNC,                      -- Sincronismo horizontal
        LCD_VSYNC => LCD_VSYNC,                      -- Sincronismo vertical
        LCD_B     => LCD_B,                          -- Componente azul
        LCD_G     => LCD_G,                          -- Componente verde
        LCD_R     => LCD_R                           -- Componente vermelha
    );

    -- Atribuição do clock de pixel para o LCD
    LCD_CLK <= CLK_PIX;

end Behavioral;