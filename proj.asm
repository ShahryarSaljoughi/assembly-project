; written by elaheh seyyeding azar, 1396
%macro push_all_general_purpose_regs 0
    push eax
    push ebx
    push ecx
    push edx
%endmacro

%macro POP_all_general_purpose_regs 0
    POP edx
    POP ecx
    POP ebx
    POP eax
%endmacro

%macro exit 1
    mov eax, 1
    int 0x80
%endmacro

%macro get_input 0
    push_all_general_purpose_regs
    mov eax, 3     ; system call number --> sys_read
    mov ebx, 2     ; file descriptor
    mov ecx, num    ; address of 
    mov edx, 4
    int 0x80

    ; [%1] holds a character, we should convert it to number:
    ; lea ecx, [num]
    ; mov eax, [ecx]
    ; sub eax, '0'
    ; mov [num], eax
    sub byte [num], '0'

    POP_all_general_purpose_regs
%endmacro

%macro print_num 1
; parameter should be from memory
    push_all_general_purpose_regs
    mov eax,  4
    mov ebx,  1  ; file descriptor
    mov edx,  4  ; length of message
    mov ecx,  %1 ; message to write
    int 0x80
    POP_all_general_purpose_regs
%endmacro
    
%macro show_char 1
    push_all_general_purpose_regs
    mov eax,  4
    mov ebx,  1  ; file descriptor
    mov edx,  1  ; length of message
    mov ecx,  %1 ; message to write
    int 0x80
    POP_all_general_purpose_regs
%endmacro

%macro abs 1
    ; tested! it works great :)))
    ; parameter should be in temp[0]
    ; result will be in temp[4]
    push eax
    push ebx

    cmp dword [%1], 0
    jge .pos
    mov ebx, %1
    
    not dword [ebx]
    mov eax, [ebx]
    inc eax
    mov [%1], eax ; temp = not(temp) + 1 
.pos:
    mov eax, [%1]
    mov ebx, %1
    add ebx, 4
    mov [ebx], eax

    POP ebx
    POP eax
%endmacro

%macro min 3
    ; param1
    ; param2
    ; result
    push_all_general_purpose_regs

    mov al, [%1] ; eax holds the first parameter
    cbw
    cwd

    mov ebx, eax  ; we assume %1 is the answer
                  ; ebx holds the answer
    cmp al, byte [%2]
    jl .ret_min_1
    mov al, [%2]
    cbw
    cwd 
    mov ebx, eax ; if %2 is the answer 
.ret_min_1:
    mov [%3], ebx ; save answer in [%3]

    POP_all_general_purpose_regs
%endmacro

%macro calculate_bound 0
; param = eax  :  eax should contain input , n
; result will be held in edx
    mov edx , eax ; edx = n
    shl edx, 1
    dec edx; edx = 2*n -1 
%endmacro

%macro cal_row_column_index 2
; param1 = esi or edi (i or j)
; param2 = address of memory to save result in
    push_all_general_purpose_regs
    push %1   ; esi or edi should not be altered with this function
    
    inc %1
    sub %1, eax ; %1 = %1 - (n-1) 
    
    mov [temp], %1
    abs temp
    mov ebx, temp
    add ebx, 4
    mov eax, [ebx] ; eax = |%1|
    neg eax
    add eax, [num] ; eax = abs_diff(i, n-1) + n 
    dec eax        ; eax = abs_diff(i, n-1) + n - 1
    mov [%2], eax

    POP %1 
    POP_all_general_purpose_regs
%endmacro

%macro move_m2m 2
; this macro moves from memory to momery
;param1 = dest
;param2 = source
    push eax
    mov eax, [%2]
    mov [%1], eax
    POP eax
%endmacro
%macro print_char 2
    min %1, %2, var_char
    add dword [var_char], 65 ; now temp has the right character to print
    show_char var_char
%endmacro

%macro endl 0
    push_all_general_purpose_regs
    mov eax, 4
    mov ebx, 1
    mov edx, 1
    mov ecx, newline
    int 80h
    POP_all_general_purpose_regs
%endmacro

section .data
    char db 'a'
    newline db 0xa

section .bss    
    num resb 1 ; num is the input
    temp resb 16 ; for passing arguments
    var_char resb 4
    ; min_param_1 resb 4
    ; min_param_2 resb 4
    ; min_result resb 4

    row_index resb 4
    col_index resb 4

section .text
    global _start
    _start:

;     get_input num           ; cin>>n 
;     calculate_bound num     ; this alters edx, edx = 2*input-1

;     mov esi, 0 ; esi is the index of outer loop:  esi = i
; outer_loop:
;     cal_row_column_index  esi, row_index
        
;     mov edi, 0
;     inner_loop:
;         cal_row_column_index edi, col_index
;         print_char row_index, col_index ; should be implemented
        
        ; inc edi
        ; cmp edi, edx
        ; jnz inner_loop

    ; inc esi
    ; cmp esi, edx
    ; jnz outer_loop

        get_input  
        mov al, [num]
        cbw
        cwd                    ;  eax = [num]

        calculate_bound        ;  edx = 2*n-1

        mov esi, 0
        outer_loop:
            cal_row_column_index  esi, row_index

            mov edi, 0
            inner_loop:
                cal_row_column_index edi, col_index
                
                print_char row_index, col_index

            inc edi
            cmp edi, edx
            jnz inner_loop

            endl
        inc esi
        cmp esi, edx
        jnz outer_loop

    finished:
    exit [num]
    