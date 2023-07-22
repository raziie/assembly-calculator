%include "asm_io.inc"

segment .data
msg1:	db "invalid operator!", 10, 0
msg2:	db "overflow!", 10, 0
msg3:	db "division by zero!", 10, 0

segment .text
        global  _asm_main
_asm_main:
        enter   0,0
        pusha

	call read_int
	mov ebx, eax

	call read_char
	call read_char
	mov ecx, eax

	call read_int

	xchg eax, ebx
	
	cmp ecx, '+'
	je addition

	cmp ecx, '-'
	je subtraction

	cmp ecx, '*'
	je multiple

	cmp eax, 0
	jl negative

	mov edx, 0
	jmp rest

negative: 
	mov edx, -1
rest:

	cmp ecx, '/'
	je division

	cmp ecx, '%'
	je remainder

	jmp char_error

addition:
	add eax, ebx
	jo overflow
	jmp end
subtraction:
	sub eax, ebx
	jo overflow
	jmp end
multiple:
	imul ebx
	jo overflow
	jmp end	
division:
	cmp ebx, 0
	je is_zero
	idiv ebx
	jo overflow
	jmp end
remainder:
	cmp ebx, 0
	je is_zero
	idiv ebx
	jo overflow
	mov eax, edx
	jmp end
char_error:
	mov eax, msg1
	jmp end
overflow:
	mov eax, msg2
	jmp end
is_zero:
	mov eax, msg3
	jmp end
end:
	call print_int
	call print_nl

        popa
        mov     eax, 0
        leave                     
        ret