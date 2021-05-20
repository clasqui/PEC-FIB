#!/bin/bash


echo "Ensamblando ..."
#compila el ensamblador
sisa-as entrada.s -o entrada.o
sisa-as user.s    -o user.o

echo "Compilando ..."
#compila el c (solo compila)  (para ver el codigo fuente entre el codigo desensamblado hay que compilar con la opcion -O0)
#sisa-gcc -gstabs -c -Wall -Wextra -O2 engine.c -o engine.o -DVERSION=\""1.7"\"
      
echo "Linkando ..."
#Linkamos los ficheros (la opcion -s es para que genere menos comentarios)
sisa-ld -s -T system.lds entrada.o user.o -o jp-sistema.o

#desensamblamos el codigo
sisa-objdump -d -z --section=.sistema jp-sistema.o >jpsistema-sys.code
sisa-objdump -s -z --section=.sysdata jp-sistema.o >jpsistema-sys.data
sisa-objdump -d -z --section=.user    jp-sistema.o >jpsistema-user.code
sisa-objdump -s -z --section=.userdata jp-sistema.o >jpsistema-user.data

./limpiar.pl codigo jpsistema-sys.code
./limpiar.pl datos jpsistema-sys.data
./limpiar.pl codigo jpsistema-user.code
./limpiar.pl datos jpsistema-user.data

#Linkamos los ficheros (sin la opcion -s es para que genere mas comentarios) y desensamblamos
#(para ver el codigo fuente entre el codigo desensamblado hay que haber compilado con la opcion -O0)
sisa-ld -T system.lds entrada.o user.o -o temp_sistema.o

sisa-objdump -S -x -w --section=.sistema temp_sistema.o >  jpsistema.dis
sisa-objdump -S -x -w --section=.sysdata temp_sistema.o >> jpsistema.dis
sisa-objdump -S -x -w --section=.user temp_sistema.o >>  jpsistema.dis
sisa-objdump -S -x -w --section=.userdata temp_sistema.o >> jpsistema.dis

#rm entrada.o lib_sisa.o fruit.o engine.o nsnake.o player.o main.o temp_nsnake.o nsnake.code nsnake.data

