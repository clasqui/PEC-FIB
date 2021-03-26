onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /test_sisa/proc0/clk
add wave -noupdate -radix hexadecimal /test_sisa/proc0/boot
add wave -noupdate -radix hexadecimal /test_sisa/proc0/c0/ac/estat
add wave -noupdate -radix hexadecimal /test_sisa/proc0/addr_m
add wave -noupdate -radix hexadecimal /test_sisa/proc0/datard_m
add wave -noupdate -radix hexadecimal /test_sisa/proc0/data_wr
add wave -noupdate -radix hexadecimal /test_sisa/proc0/wr_m
add wave -noupdate -radix hexadecimal /test_sisa/proc0/word_byte
add wave -noupdate -divider {Unitat de Control}
add wave -noupdate -radix hexadecimal /test_sisa/proc0/c0/c0/PC
add wave -noupdate -radix hexadecimal /test_sisa/proc0/c0/ir_actual
add wave -noupdate -radix hexadecimal /test_sisa/proc0/c0/ldpc_l
add wave -noupdate -radix hexadecimal /test_sisa/proc0/c0/ldir
add wave -noupdate -radix hexadecimal /test_sisa/proc0/c0/ldpc
add wave -noupdate -radix hexadecimal /test_sisa/proc0/c0/in_d
add wave -noupdate -radix hexadecimal /test_sisa/proc0/c0/ins_dad
add wave -noupdate -radix hexadecimal /test_sisa/proc0/c0/immed_x2
add wave -noupdate -divider Datapath
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/datard_m
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/immed
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/in_d
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/ins_dad
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/immed_x2
add wave -noupdate -divider Alu
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/alu0/x
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/alu0/y
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/alu0/op
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/alu0/w
add wave -noupdate -divider {Banc de Registres}
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/reg0/addr_a
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/reg0/a
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/reg0/addr_b
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/reg0/b
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/reg0/addr_d
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/reg0/wrd
add wave -noupdate -radix hexadecimal /test_sisa/proc0/e0/reg0/d
add wave -noupdate -radix hexadecimal -childformat {{/test_sisa/proc0/e0/reg0/registres(0) -radix hexadecimal} {/test_sisa/proc0/e0/reg0/registres(1) -radix hexadecimal} {/test_sisa/proc0/e0/reg0/registres(2) -radix hexadecimal} {/test_sisa/proc0/e0/reg0/registres(3) -radix hexadecimal} {/test_sisa/proc0/e0/reg0/registres(4) -radix hexadecimal} {/test_sisa/proc0/e0/reg0/registres(5) -radix hexadecimal} {/test_sisa/proc0/e0/reg0/registres(6) -radix hexadecimal} {/test_sisa/proc0/e0/reg0/registres(7) -radix hexadecimal}} -expand -subitemconfig {/test_sisa/proc0/e0/reg0/registres(0) {-radix hexadecimal} /test_sisa/proc0/e0/reg0/registres(1) {-radix hexadecimal} /test_sisa/proc0/e0/reg0/registres(2) {-radix hexadecimal} /test_sisa/proc0/e0/reg0/registres(3) {-radix hexadecimal} /test_sisa/proc0/e0/reg0/registres(4) {-radix hexadecimal} /test_sisa/proc0/e0/reg0/registres(5) {-radix hexadecimal} /test_sisa/proc0/e0/reg0/registres(6) {-radix hexadecimal} /test_sisa/proc0/e0/reg0/registres(7) {-radix hexadecimal}} /test_sisa/proc0/e0/reg0/registres
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95536 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 226
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
WaveRestoreZoom {0 ps} {163603 ps}
