--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--Tool Version: V1.9.9.03 Education (64-bit)
--Part Number: GW1NZ-LV1QN48C6/I5
--Device: GW1NZ-1
--Created Time: Sun Mar 16 20:57:11 2025

--Change the instance name and port connections to the signal names
----------Copy here to design--------

component Gowin_rPLL
    port (
        clkout: out std_logic;
        clkoutd: out std_logic;
        clkin: in std_logic
    );
end component;

your_instance_name: Gowin_rPLL
    port map (
        clkout => clkout,
        clkoutd => clkoutd,
        clkin => clkin
    );

----------Copy end-------------------
