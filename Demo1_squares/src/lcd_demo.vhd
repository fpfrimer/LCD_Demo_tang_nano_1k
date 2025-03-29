-- O código imprime três quadrados de cores diferentes em um monitor LCD. A resolução utilizada é
-- 800 x 600 pixels a uma taxa de atualização de 72 Hz. Essas configurações são ideais para
-- o kit de10 Lite, pois é necessário um sinal de clock de 50 MHz, já presente na placa.
-- Para outras configurações é necessário utilizar pll.
-- Referências: https://martin.hinner.info/vga/timing.html, 
--              https://embarcados.com.br/controlador-vga-parte-1/
--              https://www.youtube.com/watch?v=WK5FT5RD1sU

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lcd_demo is
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
end entity;

architecture rtl of lcd_demo is

    constant H_ACTIVE_VIDEO    :   integer := 1024;
    constant H_FRONT_PORCH     :   integer := H_ACTIVE_VIDEO + 40;
    constant H_SYNC            :   integer := H_FRONT_PORCH + 104;
    constant H_BACK_PORCH      :   integer := H_SYNC + 144;
    constant H_PIXELS          :   integer := 1312;


    constant V_ACTIVE_VIDEO    :   integer := 600;
    constant V_FRONT_PORCH     :   integer := V_ACTIVE_VIDEO + 3;
    constant V_SYNC            :   integer := V_FRONT_PORCH + 10;
    constant V_BACK_PORCH      :   integer := V_SYNC + 11;
    constant V_PIXELS          :   integer := 624;

    -- Cores
    constant red               :   std_logic_vector(15 downto 0) := "1111100000000000";
    constant green             :   std_logic_vector(15 downto 0) := "0000011111100000";
    constant blue              :   std_logic_vector(15 downto 0) := "0000000000011111";
    

    -- Procedimento para incrementar contadores verticais e horizontais
    procedure incrementa(
        signal      contador     :   inout  integer;
        constant    max          :   in     integer;
        constant    habilita     :   in     boolean;
        variable    estouro      :   out    boolean) is
    begin
        estouro := false;
        if habilita then
            if contador = max - 1 then
                estouro := true;
                contador <= 0;
            else
                contador <= contador + 1;
            end if;
        end if;
    end procedure;
	 
	-- Procedimento para imprimir um quadrado na tela
	procedure quadrado(
        constant enable  :   in  boolean;   -- Habilita o quadrado
        constant h, v    :   in  integer;   -- Posição atual da varredura
        constant x, y    :   in  integer;   -- Coordenadas no Quadrado     
        constant w       :   in  integer;   -- Lado do quadrado
        constant color   :   in  std_logic_vector(15 downto 0); -- Cor
        variable draw    :   inout std_logic_vector(15 downto 0)) is    -- Indica quando imprimir a cor do quadrado
    begin
        --draw_out := draw_in;
        if enable then
            if (v >= y - w/2 and v < y + w/2) and (h >= x - w/2 and h < x + w/2) then
                draw := color;
            end if;            
            
        end if;
    end procedure;

    
    
    -- Sinais
    signal horizontal   :   integer range 0 to H_PIXELS := 0;    -- 800 x 600 72Hz
    signal vertical     :   integer range 0 to V_PIXELS := 0;     -- 800 x 600 72Hz
    signal active       :   boolean;
	
    
begin

    PIXEL_PROC : process(PixelClk, nRst)
        variable controle   :   boolean;
    begin
        if nRst = '0' then
            horizontal <= 0;
            vertical <= 0;        
        elsif rising_edge(PixelClk) then
            LCD_HSYNC <= '1';
            LCD_VSYNC <= '1';
            active <= false;           
            if horizontal >= H_FRONT_PORCH and horizontal < H_SYNC then
                LCD_HSYNC <= '0';
            end if;
            if vertical >= V_FRONT_PORCH and vertical < V_SYNC then
                LCD_VSYNC <= '0';
            end if;
            if horizontal < H_ACTIVE_VIDEO and vertical <= V_ACTIVE_VIDEO then
                active <= true;
            end if;
            incrementa(horizontal, H_PIXELS, true, controle);
            incrementa(vertical, V_PIXELS, controle, controle);
        end if;        
    end process;

    LCD_DE <= '1' when active else '0';
    
    process(PixelClk)
        variable draw : std_logic_vector(15 downto 0);
    begin

        if rising_edge(PixelClk) then
            draw := (others => '0');
            quadrado(active, horizontal, vertical, H_ACTIVE_VIDEO/2-50, V_ACTIVE_VIDEO/2-25, 60, red, draw);
            quadrado(active, horizontal, vertical, H_ACTIVE_VIDEO/2, V_ACTIVE_VIDEO/2, 60, green, draw);
            quadrado(active, horizontal, vertical, H_ACTIVE_VIDEO/2+50, V_ACTIVE_VIDEO/2+25, 60, blue, draw);

            if horizontal = 0 or horizontal = 1024-1 or vertical = 0 or vertical = 600-1 then
                draw := (others => '1');
            end if;
            
            -- 15, 14, 13, 12, 11       10, 9, 8, 7, 6, 5       4, 3, 2, 1, 0
            LCD_R <= draw(15 downto 11); -- red
            LCD_G <= draw(10 downto 5);  -- green
            LCD_B <= draw(4 downto 0);  -- blue
        end if;
    end process;
    
    
end architecture;