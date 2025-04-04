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

    -- Função para converter char para std_logic_vector
    function char_to_slv(c : character) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(character'pos(c), 7));
    end function;

    -- Procedimento para imprimir um caractere na tela
    procedure print_char(
        constant enable :   in  boolean;   -- Habilita o caractere
        constant h, v   :   in  integer;   -- Posição atual da varredura
        constant x, y   :   in  integer;   -- Coordenadas do caractere
        constant char   :   in  character;
        signal   addr   :   out std_logic_vector(10 downto 0);
        constant data   :   in  std_logic_vector(7 downto 0);
        constant color  :   in  std_logic_vector(15 downto 0); -- Cor
        constant font_size : in integer;   -- Fator de ampliação
        variable draw   :   inout std_logic_vector(15 downto 0)) is    -- Indica quando imprimir a cor do quadrado
    begin
        if enable then
            -- Verifica se o pixel atual está dentro da área do caractere escalado
            if (v >= y and v < y + 15 * font_size) and (h >= x and h < x + 9 * font_size) then
                -- Calcula as coordenadas relativas ao caractere original
                addr <= char_to_slv(char) & std_logic_vector(to_unsigned((v - y) / font_size, 4));
                
                -- Verifica se o pixel original deve ser desenhado
                if data(((x - h) / font_size) + 9 - 1) = '1' then
                    draw := color;
                end if;
            end if;
        end if;
    end procedure;

    -- Procedimento para imprimir uma linha na tela
    procedure print_ln(
        constant enable :   in  boolean;   -- Habilita o texto
        constant h, v   :   in  integer;   -- Posição atual da varredura
        constant x, y   :   in  integer;   -- Coordenadas da linha
        constant ln     :   in  string;
        signal   addr   :   out std_logic_vector(10 downto 0);
        constant data   :   in  std_logic_vector(7 downto 0);
        constant color  :   in  std_logic_vector(15 downto 0); -- Cor
        constant font_size : in integer;   -- Fator de ampliação
        variable draw   :   inout std_logic_vector(15 downto 0)) is    -- Indica quando imprimir a cor do quadrado
    
        variable text   :   string(1 to ln'length) := (others => ' ');
    begin
        text := ln;
    
        if enable then
            for i in ln'range loop
                print_char(enable, h, v, x + (i - 1) * 9 * font_size, y, text(i), addr, data, color, font_size, draw);
            end loop;
        end if;
    end procedure;



    
    
    -- Sinais
    signal horizontal   :   integer range 0 to H_PIXELS := 0;    -- 800 x 600 72Hz
    signal vertical     :   integer range 0 to V_PIXELS := 0;     -- 800 x 600 72Hz
    signal active       :   boolean;

    signal x_pos        :   integer range 0 to H_ACTIVE_VIDEO;
    signal y_pos        :   integer range 0 to V_ACTIVE_VIDEO;
    signal delay_flag   :   boolean := false;

    signal font_addr    :   std_logic_vector(10 downto 0);
    signal font_data    :   std_logic_vector(7 downto 0);



    type texts_t is array (0 to 1) of string(1 to 12);
    constant texts      :   texts_t := ("Hello World!", "Subscribe!!!");
    signal text_index   : integer range 0 to 1 := 0;

    signal random_color : std_logic_vector(15 downto 0) := "1010101010101010";
	
    
begin

    FONT : entity work.font_rom
        port map(PixelClk, font_addr, font_data);

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
            -- font_addr <= (others => '0');
            draw := (others => '0');
            
            -- quadrado(active, horizontal, vertical, x_pos, y_pos, 60, green, draw);
            -- print_char(active, horizontal, vertical, x_pos, y_pos, 'B', font_addr, font_data, red, 2, draw);
            -- print_char(active, horizontal, vertical, 200, 200, 'B', font_addr, font_data, red, 2,  draw);
            -- print_char(active, horizontal, vertical, 220, 200, 'B', font_addr, font_data, red, 2, draw);
            print_ln(active, horizontal, vertical, x_pos - 100, y_pos - 20, texts(text_index), font_addr, font_data, random_color, 2, draw);
            

            if horizontal = 0 or horizontal = 1024-1 or vertical = 0 or vertical = 600-1 then
                draw := (others => '1');
            end if;
            
            -- 15, 14, 13, 12, 11       10, 9, 8, 7, 6, 5       4, 3, 2, 1, 0
            LCD_R <= draw(15 downto 11); -- red
            LCD_G <= draw(10 downto 5);  -- green
            LCD_B <= draw(4 downto 0);  -- blue
        end if;
    end process;

    process(PixelClk)
        variable x  :   integer range 0 to H_ACTIVE_VIDEO := H_ACTIVE_VIDEO/2;
        variable y  :   integer range 0 to V_ACTIVE_VIDEO := V_ACTIVE_VIDEO/2;
        variable vx :   integer range -1 to 1 := 1;
        variable vy :   integer range -1 to 1 := 1;
    begin
        if rising_edge(PixelClk) then
            if delay_flag then
                x := x + vx;
                y := y + vy;
                if x = 0 + 30 or x = H_ACTIVE_VIDEO - 30 then
                    vx := - vx;
                end if;
                if y = 0 + 30 or y = V_ACTIVE_VIDEO - 30 then
                    vy := - vy;
                end if;
            end if;
        end if;
        x_pos <= x;
        y_pos <= y;
    end process;

    process(PixelClk)
        variable i : integer range 0 to 2**18 -1 := 0;
    begin
        if rising_edge(PixelClk) then
            delay_flag <= false;
            i := i + 1;
            if i = 0 then
                delay_flag <= true;
            end if;
        end if;

    end process;


    -- Incrementa o índice do texto a cada 2^27 ciclos de clock
    process(PixelClk)
        variable i : integer range 0 to 2**27 -1 := 0;        
    begin
        if rising_edge(PixelClk) then            
            i := i + 1;
            if i = 0 then
                text_index <= text_index + 1;
            end if;
        end if;

    end process;

    process(PixelClk)
        variable i : integer range 0 to 2**24 -1 := 0;        
    begin
        if rising_edge(PixelClk) then            
            i := i + 1;
            if i = 0 then
                random_color <= (random_color(14 downto 0) & (random_color(15) xor random_color(10) xor random_color(8) xor random_color(0))) or "1000010000010000";
            end if;
        end if;

    end process;

    
    
    
end architecture;