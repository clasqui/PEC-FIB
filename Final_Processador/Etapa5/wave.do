onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider SoC
add wave -noupdate -radix hexadecimal /test_sisa/SoC/clk_proc
add wave -noupdate -radix hexadecimal /test_sisa/SoC/CLOCK_50
add wave -noupdate -radix hexadecimal /test_sisa/SoC/SW
add wave -noupdate -radix hexadecimal /test_sisa/SoC/LEDG
add wave -noupdate -radix hexadecimal /test_sisa/SoC/LEDR
add wave -noupdate -radix hexadecimal /test_sisa/SoC/HEX0
add wave -noupdate -radix hexadecimal /test_sisa/SoC/HEX1
add wave -noupdate -radix hexadecimal /test_sisa/SoC/HEX2
add wave -noupdate -radix hexadecimal /test_sisa/SoC/HEX3
add wave -noupdate -divider {Unitat de Control}
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/c0/boot
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/c0/ac/estat
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/c0/datard_m
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/c0/tknbr
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/c0/nou_pc
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/c0/pc
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/c0/wr_m
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/c0/ac/wr_m_l
add wave -noupdate -divider ControlMemoria
add wave -noupdate -radix hexadecimal /test_sisa/SoC/mem0/addr
add wave -noupdate -radix hexadecimal /test_sisa/SoC/mem0/wr_data
add wave -noupdate -radix hexadecimal /test_sisa/SoC/mem0/rd_data
add wave -noupdate -radix hexadecimal /test_sisa/SoC/mem0/we
add wave -noupdate -radix hexadecimal /test_sisa/SoC/mem0/byte_m
add wave -noupdate -divider {SDRAM Control Memoria}
add wave -noupdate -radix hexadecimal /test_sisa/SoC/mem0/sram/WR
add wave -noupdate -radix hexadecimal /test_sisa/SoC/SRAM_ADDR
add wave -noupdate -radix hexadecimal /test_sisa/SoC/SRAM_DQ
add wave -noupdate -radix hexadecimal /test_sisa/SoC/SRAM_UB_N
add wave -noupdate -radix hexadecimal /test_sisa/SoC/SRAM_LB_N
add wave -noupdate -radix hexadecimal /test_sisa/SoC/SRAM_CE_N
add wave -noupdate -radix hexadecimal /test_sisa/SoC/SRAM_OE_N
add wave -noupdate -radix hexadecimal /test_sisa/SoC/SRAM_WE_N
add wave -noupdate -radix hexadecimal /test_sisa/SoC/mem0/sram/dataReaded
add wave -noupdate -radix hexadecimal /test_sisa/SoC/mem0/sram/dataToWrite
add wave -noupdate -divider Datapath
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/a
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/b
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/Rb_N
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/x
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/y
add wave -noupdate -divider Alu
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/alu0/x
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/alu0/y
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/alu0/w
add wave -noupdate -divider ControlIO
add wave -noupdate -radix hexadecimal /test_sisa/SoC/io0/addr_io
add wave -noupdate -radix hexadecimal /test_sisa/SoC/io0/wr_io
add wave -noupdate -radix hexadecimal /test_sisa/SoC/io0/rd_io
add wave -noupdate -radix hexadecimal /test_sisa/SoC/io0/wr_out
add wave -noupdate -radix hexadecimal /test_sisa/SoC/io0/rd_in
add wave -noupdate -radix hexadecimal /test_sisa/SoC/io0/io_ports
add wave -noupdate -divider {Banc de Registres}
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/wrd
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/d
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/addr_a
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/addr_b
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/addr_d
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/a
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/b
add wave -noupdate -radix hexadecimal -childformat {{/test_sisa/SoC/pro0/e0/reg0/registres(0) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(1) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(2) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(3) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(4) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(5) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(6) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(7) -radix hexadecimal}} -expand -subitemconfig {/test_sisa/SoC/pro0/e0/reg0/registres(0) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(1) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(2) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(3) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(4) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(5) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(6) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(7) {-height 15 -radix hexadecimal}} /test_sisa/SoC/pro0/e0/reg0/registres
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1016000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 253
configure wave -valuecolwidth 54
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {804440 ps} {1953656 ps}
