# assembly-project
this is my homework for assembly course at ZNU :)))

In case some user enters 3 input, below image would be its output!
<img src='https://serving.photos.photobox.com/12698326bb71deb8ce2d16904271f36e10e4805c2f4b46874127a061b830c6209066f44f.jpg'></img>


this project uses linux system calls (int 80h)

assembled using [nasm](http://nasm.us/) 

# how to run:
    git clone https://github.com/ShahryarSaljoughi/assembly-project
    nasm -f elf32 proj.asm
    ld -m elf_i386 proj.o
now an executable file(`a.out`) is create, which you can run!
 
