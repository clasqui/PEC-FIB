#!/bin/bash


echo "Ensamblando ..."
#compila el ensamblador
sisa-as entrada.s -o entrada.o
sisa-as user.s    -o user.o

#echo "Compilando ..."
#compila el c (solo compila)  (para ver el codigo fuente entre el codigo desensamblado hay que compilar con la opcion -O0)
#sisa-gcc -gstabs -c -Wall -Wextra -O2 engine.c -o engine.o -DVERSION=\""1.7"\"
      
echo "Linkando ..."
#Linkamos los ficheros (la opcion -s es para que genere menos comentarios)
sisa-ld -s -T system.lds entrada.o user.o -o jp-tlb.o

#desensamblamos el codigo
sisa-objdump -d -z --section=.sistema jp-tlb.o >jptlb-sys.code
sisa-objdump -s -z --section=.sysdata jp-tlb.o >jptlb-sys.data
sisa-objdump -d -z --section=.user    jp-tlb.o >jptlb-user.code
sisa-objdump -s -z --section=.userdata jp-tlb.o >jptlb-user.data

./limpiar.pl codigo jptlb-sys.code
./limpiar.pl datos jptlb-sys.data
./limpiar.pl codigo jptlb-user.code
./limpiar.pl datos jptlb-user.data

#Linkamos los ficheros (sin la opcion -s es para que genere mas comentarios) y desensamblamos
#(para ver el codigo fuente entre el codigo desensamblado hay que haber compilado con la opcion -O0)
sisa-ld -T system.lds entrada.o user.o -o temp_tlb.o

sisa-objdump -S -x -w --section=.sistema temp_tlb.o >  jptlb.dis
sisa-objdump -S -x -w --section=.sysdata temp_tlb.o >> jptlb.dis
sisa-objdump -S -x -w --section=.user temp_tlb.o >>  jptlb.dis
sisa-objdump -S -x -w --section=.userdata temp_tlb.o >> jptlb.dis

rm entrada.o user.o jp-tlb.o

