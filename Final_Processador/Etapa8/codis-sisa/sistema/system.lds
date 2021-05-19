/*
 *  Canviem l'script per defecte
 *   per adequar-lo a l'arquitectura
 */
OUTPUT_FORMAT("elf32-sisa","elf32-sisa","elf32-sisa")
OUTPUT_ARCH(sisa)
SECTIONS
{
  /* Ens situem a la part de flash */
  . = 0xc000 ;

  /* text space */
  .sistema :
  {
    entrada.o(.text) 
    entrada.o(.rodata) 
    . = ALIGN(2);
  }
  __entry_point = LOADADDR(.sistema);

  PROVIDE (__user_start = .);
  . = 0x0 ; /* Part d'usuari */

  .userdata :
  {
    user.o(.data)
  }

. = 0x4000 ;
  .user : 
  {
    user.o(.text)
    user.o(.rodata)
  }

  __user_end = __user_start + SIZEOF(.userdata) + SIZEOF(.user);

  
   /* Ens situem en la part de sistema */
  . = 0x8000 ;

  .sysdata : {  entrada.o(.data) }
}
