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
add wave -noupdate /test_sisa/SoC/pro0/c0/we_tlb
add wave -noupdate /test_sisa/SoC/pro0/c0/i_d
add wave -noupdate /test_sisa/SoC/pro0/c0/v_p
add wave -noupdate -divider {Interrupt controller}
add wave -noupdate /test_sisa/SoC/io0/intctrl0/intr
add wave -noupdate /test_sisa/SoC/io0/intctrl0/inta
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
add wave -noupdate /test_sisa/SoC/pro0/e0/v_p
add wave -noupdate /test_sisa/SoC/pro0/e0/i_d
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
add wave -noupdate -divider {TLB instruccions}
add wave -noupdate /test_sisa/SoC/pro0/e0/tlbi/vtag
add wave -noupdate /test_sisa/SoC/pro0/e0/tlbi/tag_in
add wave -noupdate /test_sisa/SoC/pro0/e0/tlbi/addr
add wave -noupdate /test_sisa/SoC/pro0/e0/tlbi/v_p
add wave -noupdate /test_sisa/SoC/pro0/e0/tlbi/we
add wave -noupdate /test_sisa/SoC/pro0/e0/tlbi/ptag
add wave -noupdate /test_sisa/SoC/pro0/e0/tlbi/miss
add wave -noupdate /test_sisa/SoC/pro0/e0/tlbi/inv_pg
add wave -noupdate /test_sisa/SoC/pro0/e0/tlbi/pr_pg
add wave -noupdate /test_sisa/SoC/pro0/e0/tlbi/ro_pg
add wave -noupdate /test_sisa/SoC/pro0/e0/tlbi/flush
add wave -noupdate -radix hexadecimal -childformat {{/test_sisa/SoC/pro0/e0/tlbi/virtual(0) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/virtual(1) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/virtual(2) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/virtual(3) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/virtual(4) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/virtual(5) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/virtual(6) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/virtual(7) -radix hexadecimal}} -expand -subitemconfig {/test_sisa/SoC/pro0/e0/tlbi/virtual(0) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/virtual(1) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/virtual(2) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/virtual(3) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/virtual(4) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/virtual(5) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/virtual(6) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/virtual(7) {-height 15 -radix hexadecimal}} /test_sisa/SoC/pro0/e0/tlbi/virtual
add wave -noupdate -radix hexadecimal -childformat {{/test_sisa/SoC/pro0/e0/tlbi/fisica(0) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/fisica(1) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/fisica(2) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/fisica(3) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/fisica(4) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/fisica(5) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/fisica(6) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/tlbi/fisica(7) -radix hexadecimal}} -expand -subitemconfig {/test_sisa/SoC/pro0/e0/tlbi/fisica(0) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/fisica(1) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/fisica(2) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/fisica(3) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/fisica(4) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/fisica(5) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/fisica(6) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/tlbi/fisica(7) {-height 15 -radix hexadecimal}} /test_sisa/SoC/pro0/e0/tlbi/fisica
add wave -noupdate -divider {Banc de Registres}
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/wrd
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/d
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/addr_a
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/addr_b
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/addr_d
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/a
add wave -noupdate -radix hexadecimal /test_sisa/SoC/pro0/e0/reg0/b
add wave -noupdate -radix hexadecimal -childformat {{/test_sisa/SoC/pro0/e0/reg0/registres(0) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(1) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(2) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(3) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(4) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(5) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(6) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres(7) -radix hexadecimal}} -expand -subitemconfig {/test_sisa/SoC/pro0/e0/reg0/registres(0) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(1) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(2) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(3) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(4) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(5) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(6) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres(7) {-height 15 -radix hexadecimal}} /test_sisa/SoC/pro0/e0/reg0/registres
add wave -noupdate -childformat {{/test_sisa/SoC/pro0/e0/reg0/registres_sistema(0) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres_sistema(1) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres_sistema(2) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres_sistema(3) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres_sistema(4) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres_sistema(5) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres_sistema(6) -radix hexadecimal} {/test_sisa/SoC/pro0/e0/reg0/registres_sistema(7) -radix hexadecimal}} -expand -subitemconfig {/test_sisa/SoC/pro0/e0/reg0/registres_sistema(0) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres_sistema(1) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres_sistema(2) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres_sistema(3) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres_sistema(4) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres_sistema(5) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres_sistema(6) {-height 15 -radix hexadecimal} /test_sisa/SoC/pro0/e0/reg0/registres_sistema(7) {-height 15 -radix hexadecimal}} /test_sisa/SoC/pro0/e0/reg0/registres_sistema
add wave -noupdate -divider {Controlador Excepcions}
add wave -noupdate /test_sisa/SoC/pro0/exc0/clk
add wave -noupdate /test_sisa/SoC/pro0/exc0/boot
add wave -noupdate /test_sisa/SoC/pro0/exc0/i_ilegal
add wave -noupdate /test_sisa/SoC/pro0/exc0/a_impar
add wave -noupdate /test_sisa/SoC/pro0/exc0/zero_div
add wave -noupdate /test_sisa/SoC/pro0/exc0/acces_no_alineat
add wave -noupdate /test_sisa/SoC/pro0/exc0/direccio_protegida_d
add wave -noupdate /test_sisa/SoC/pro0/exc0/direccio_protegida_i
add wave -noupdate /test_sisa/SoC/pro0/exc0/miss_dades
add wave -noupdate /test_sisa/SoC/pro0/exc0/miss_instr
add wave -noupdate /test_sisa/SoC/pro0/exc0/inv_dir_d
add wave -noupdate /test_sisa/SoC/pro0/exc0/inv_dir_i
add wave -noupdate /test_sisa/SoC/pro0/exc0/ro_pg_excep
add wave -noupdate /test_sisa/SoC/pro0/exc0/excpr
add wave -noupdate /test_sisa/SoC/pro0/exc0/excp_id
add wave -noupdate /test_sisa/SoC/pro0/exc0/excp_of_fp_e
add wave -noupdate /test_sisa/SoC/pro0/exc0/except_tractant
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1136981 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 325
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
WaveRestoreZoom {614285 ps} {1382645 ps}
