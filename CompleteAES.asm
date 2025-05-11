org 100h 

 subBytes MACRO input, sbox
    push cx
    MOV SI, OFFSET input        ; SI points to the input 
    MOV DI, OFFSET sbox         ; DI points to the sbox
    MOV CX, 16                  ; cx acts as a counter of 16 bytes
    
    L:
        MOV AL, [SI]            ; Load byte from the input to AL
        MOV BL, AL              ; Move to BL for index lookup
        MOV AL, [DI + BX]       ; Fetch the sbox value corresponding to the current byte
        MOV [SI], AL            ; Store the substituted byte back 
        INC SI                  ; Move to the next input byte    
        DEC CX                  ; Decrement counter
        JNZ L                   ; Jumps back to L  
        pop cx
 ENDM     
 subBytes2 MACRO input, sbox
    push cx
    MOV SI, OFFSET input        ; SI points to the input 
    MOV DI, OFFSET sbox         ; DI points to the sbox
    MOV CX, 16                  ; cx acts as a counter of 16 bytes
    
    L2:
        MOV AL, [SI]            ; Load byte from the input to AL
        MOV BL, AL              ; Move to BL for index lookup
        MOV AL, [DI + BX]       ; Fetch the sbox value corresponding to the current byte
        MOV [SI], AL            ; Store the substituted byte back 
        INC SI                  ; Move to the next input byte    
        DEC CX                  ; Decrement counter
        JNZ L2                   ; Jumps back to L 
        pop cx
   ENDM         
   
   shiftRows MACRO input
    push cx    
     MOV SI, OFFSET input     ; SI points to the input

    ; Row 0: No shifting
    ; Row 1: Shift left by 1
    MOV AL, [SI + 4]         ; Save the first byte of Row 1
    MOV BL, [SI + 5]         ; Shift the second byte
    MOV [SI + 4], BL         ; Move second byte to first position
    MOV BL, [SI + 6]         ; Shift the third byte
    MOV [SI + 5], BL         ; Move third byte to second position
    MOV BL, [SI + 7]         ; Shift the fourth byte
    MOV [SI + 6], BL         ; Move fourth byte to third position
    MOV [SI + 7], AL         ; Restore the saved byte to the last position

    ; Row 2: Shift left by 2
    MOV AL, [SI + 8]         ; Save the first byte of Row 2
    MOV BL, [SI + 9]         ; Save the second byte of Row 2
    MOV CL, [SI + 10]        ; Move third byte to a register
    MOV [SI + 8], CL         ; Move third byte to the first position
    MOV CL, [SI + 11]        ; Move fourth byte to a register
    MOV [SI + 9], CL         ; Move fourth byte to the second position
    MOV [SI + 10], AL        ; Restore first byte to the third position
    MOV [SI + 11], BL        ; Restore second byte to the fourth position

    ; Row 3: Shift left by 3
    MOV AL, [SI + 12]        ; Save the first byte of Row 3
    MOV BL, [SI + 13]        ; Save the second byte
    MOV CL, [SI + 14]        ; Save the third byte
    MOV DL, [SI + 15]        ; Save the fourth byte
    MOV [SI + 12], DL        ; Move fourth byte to the first position
    MOV [SI + 13], AL        ; Restore first byte to the second position
    MOV [SI + 14], BL        ; Restore second byte to the third position
    MOV [SI + 15], CL        ; Restore third byte to the fourth position
    pop cx
   ENDM 
   
   
  
  MixColumns MACRO input, mixcol, temp  
    push cx
    MOV SI, OFFSET input
    MOV DI, OFFSET mixcol 
    MOV BX, OFFSET temp
    MOV CX, 4    
    C1:
        MOV AX, [SI]
        MUL [DI]
        PUSH AX
        MOV AX, [SI+4]
        MUL [DI+1]
        PUSH AX
        MOV AX, [SI+8]
        MUL [DI+2]
        PUSH AX
        MOV AX, [SI+12]
        MUL [DI+3]
        POP DX
        XOR AX, DX
        POP DX
        XOR AX, DX
        POP DX
        XOR AX, DX  
        MOV [BX], AX
        INC BX
        ADD DI, 4
    Loop C1
    INC SI 
    MOV CX, 4
    C2:
        MOV AX, [SI]
        MUL [DI]
        PUSH AX
        MOV AX, [SI+4]
        MUL [DI+1]
        PUSH AX
        MOV AX, [SI+8]
        MUL [DI+2]
        PUSH AX
        MOV AX, [SI+12]
        MUL [DI+3]
        POP DX
        XOR AX, DX
        POP DX
        XOR AX, DX
        POP DX
        XOR AX, DX  
        MOV [BX], AX
        INC BX
        ADD DI, 4
    LOOP C2 
    INC SI 
    MOV CX, 4
    C3:
        MOV AX, [SI]
        MUL [DI]
        PUSH AX
        MOV AX, [SI+4]
        MUL [DI+1]
        PUSH AX
        MOV AX, [SI+8]
        MUL [DI+2]
        PUSH AX
        MOV AX, [SI+12]
        MUL [DI+3]
        POP DX
        XOR AX, DX
        POP DX
        XOR AX, DX
        POP DX
        XOR AX, DX  
        MOV [BX], AX
        INC BX
        ADD DI, 4
    LOOP C3
    INC SI 
    MOV CX, 4
    C4:
        MOV AX, [SI]
        MUL [DI]
        PUSH AX
        MOV AX, [SI+4]
        MUL [DI+1]
        PUSH AX
        MOV AX, [SI+8]
        MUL [DI+2]
        PUSH AX
        MOV AX, [SI+12]
        MUL [DI+3]
        POP DX
        XOR AX, DX
        POP DX
        XOR AX, DX
        POP DX
        XOR AX, DX  
        MOV [BX], AX
        INC BX
        ADD DI, 4
     LOOP C4 
     MOV SI, OFFSET temp       ; Point SI to the temp matrix
    MOV DI, OFFSET input      ; Point DI to the input matrix
    MOV CX, 16                ; Set loop counter for all 16 elements

    Copy_Loop:
        MOV AL, [SI]              ; Load element from temp
        MOV [DI], AL              ; Store it back to input
        INC SI                    ; Move to next element in temp
        INC DI                    ; Move to next element in input
    LOOP Copy_Loop     
    pop cx       
  ENDM
        
   
   AddRoundKey MACRO input, addkey   
    push cx
    MOV SI, OFFSET input       ; Load address of the input into SI
    MOV DI, OFFSET addkey      ; Load address of the round key into DI
    MOV CX, 16                 ; Set counter for 16 bytes 

    AddRoundKeyLoop:
        MOV AL, [SI]               ; Load a byte from the input into AL
        XOR AL, [DI]               ; XOR it with the corresponding round key byte
        MOV [SI], AL               ; Store the result back in the input
        INC SI                     ; Move to the next byte in the input
        INC DI                     ; Move to the next byte in the round key
        DEC CX                     ; Decrement counter
        JNZ AddRoundKeyLoop        ; Repeat until all 16 bytes are processed
        pop cx  
   ENDM 
    AddRoundKey2 MACRO input, addkey     
        push cx
    MOV SI, OFFSET input       ; Load address of the input into SI
    MOV DI, OFFSET addkey      ; Load address of the round key into DI
    MOV CX, 16                 ; Set counter for 16 bytes 

    AddRoundKeyLoop2:
        MOV AL, [SI]               ; Load a byte from the input into AL
        XOR AL, [DI]               ; XOR it with the corresponding round key byte
        MOV [SI], AL               ; Store the result back in the input
        INC SI                     ; Move to the next byte in the input
        INC DI                     ; Move to the next byte in the round key
        DEC CX                     ; Decrement counter
        JNZ AddRoundKeyLoop2        ; Repeat until all 16 bytes are processed 
        pop cx 
    ENDM 
    
     AddRoundKey3 MACRO input, addkey   
        push cx
    MOV SI, OFFSET input       ; Load address of the input into SI
    MOV DI, OFFSET addkey      ; Load address of the round key into DI
    MOV CX, 16                 ; Set counter for 16 bytes 

    AddRoundKeyLoop3:
        MOV AL, [SI]               ; Load a byte from the input into AL
        XOR AL, [DI]               ; XOR it with the corresponding round key byte
        MOV [SI], AL               ; Store the result back in the input
        INC SI                     ; Move to the next byte in the input
        INC DI                     ; Move to the next byte in the round key
        DEC CX                     ; Decrement counter
        JNZ AddRoundKeyLoop3        ; Repeat until all 16 bytes are processed
        pop cx  
   ENDM 
   
   
 
.data segment
    ;input DB 019h, 0a0h, 09ah, 0E9h, 03dh, 0f4h, 0c6h, 0f8h, 0e3h, 0e2h, 08dh, 048h, 0beh, 02bh, 02ah, 008h 
    sbox DB 063h,07Ch,077h,07Bh,0F2h,06Bh,06Fh,0C5h,030h,001h,067h,02Bh,0FEh,0D7h,0ABh,076h,0CAh,082h,0C9h,07Dh,0FAh,059h,047h,0F0h,0ADh,0D4h,0A2h,0AFh,09Ch,0A4h,072h,0C0h,0B7h,0FDh,093h,026h,036h,03Fh,0F7h,0CCh,034h,0A5h,0E5h,0F1h,071h,0D8h,031h,015h,004h,0C7h,023h,0C3h,018h,096h,005h,09Ah,007h,012h,080h,0E2h,0EBh,027h,0B2h,075h,009h,083h,02Ch,01Ah,01Bh,06Eh,05Ah,0A0h,052h,03Bh,0D6h,0B3h,029h,0E3h,02Fh,084h,053h,0D1h,000h,0EDh,020h,0FCh,0B1h,05Bh,06Ah,0CBh,0BEh,039h,04Ah,04Ch,058h,0CFh,0D0h,0EFh,0AAh,0FBh,043h,04Dh,033h,085h,045h,0F9h,002h,07Fh,050h,03Ch,09Fh,0A8h,051h,0A3h,040h,08Fh,092h,09Dh,038h,0F5h,0BCh,0B6h,0DAh,021h,010h,0FFh,0F3h,0D2h,0CDh,00Ch,013h,0ECh,05Fh,097h,044h,017h,0C4h,0A7h,07Eh,03Dh,064h,05Dh,019h,073h,060h,081h,04Fh,0DCh,022h,02Ah,090h,088h,046h,0EEh,0B8h,014h,0DEh,05Eh,00Bh,0DBh,0E0h,032h,03Ah,00Ah,049h,006h,024h,05Ch,0C2h,0D3h,0ACh,062h,091h,095h,0E4h,079h,0E7h,0C8h,037h,06Dh,08Dh,0D5h,04Eh,0A9h,06Ch,056h,0F4h,0EAh,065h,07Ah,0AEh,008h,0BAh,078h,025h,02Eh,01Ch,0A6h,0B4h,0C6h,0E8h,0DDh,074h,01Fh,04Bh,0BDh,08Bh,08Ah,070h,03Eh,0B5h,066h,048h,003h,0F6h,00Eh,061h,035h,057h,0B9h,086h,0C1h,01Dh,09Eh,0E1h,0F8h,098h,011h,069h,0D9h,08Eh,094h,09Bh,01Eh,087h,0E9h,0CEh,055h,028h,0DFh,08Ch,0A1h,089h,00Dh,0BFh,0E6h,042h,068h,041h,099h,02Dh,00Fh,0B0h,054h,0BBh,016h
    addkey DB 0FFh, 0FFh, 0FFh, 0FFh. 0FFh, 0FFh, 0FFh, 0FFh 
    temp DB 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h  
    mixcol DB 002h, 003h, 001h, 001h, 001h, 002h, 003h, 001h, 001h, 001h, 002h, 003h, 003h, 001h, 001h, 002h
    prompt db 'Enter input: $'
    input db 16       ; Maximum input length of 16
       db ?        ; Actual length entered
       db 16 dup(?) ; Space to store the input characters 
    output db 0Dh, 0Ah, 'OUTPUT: $'   

.code segment
    CALL GetInput 
    AddRoundKey2 input, addkey
    mov cx, 9  
    loop1:
     subBytes input, sbox
     shiftRows input  
     MixColumns input, mixcol, temp
     AddRoundKey  input, addkey
    loop loop1 
    subBytes2 input, sbox 
    shiftRows input
    AddRoundKey3 input, addkey
    CALL PrintInput
ret

    


GetInput proc
    ; Display the prompt
    mov ah, 09h
    MOV dx, OFFSET prompt
    int 21h

    ; Prepare to read input
    MOV SI, OFFSET input
    mov cx, 16              ; We need to process 16 bytes

InputLoop:
    ; Read first hex digit (high nibble)
    mov ah, 01h             ; DOS interrupt to read a single character
    int 21h                 ; Character is returned in AL
    call ConvertToHex       ; Convert ASCII to hex
    shl al, 4               ; Shift high nibble to the left
    mov bl, al              ; Save high nibble in BL

    ; Read second hex digit (low nibble)
    int 21h                 ; Get second character in AL
    call ConvertToHex       ; Convert ASCII to hex
    or bl, al               ; Combine high and low nibbles
    mov [SI], bl            ; Store the resulting byte in the input array
    INC SI

    loop InputLoop          ; Repeat for 16 bytes 
    mov ah, 02h
    mov dl, 0Dh             ; Carriage return
    int 21h
    mov dl, 0Ah             ; Line feed
    int 21h

    ret

; Subroutine to convert ASCII to hexadecimal
; Input: AL contains ASCII character
; Output: AL contains the corresponding hex value (0-15)
ConvertToHex proc
    cmp al, '0'
    jl InvalidInput         ; Check if input is less than '0'
    cmp al, '9'
    jle IsDigit             ; If within '0'-'9', it's a digit
    cmp al, 'A'
    jl InvalidInput         ; Check if input is less than 'A'
    cmp al, 'F'
    jle IsHexLetter         ; If within 'A'-'F', it's valid
    cmp al, 'a'
    jl InvalidInput         ; Check if input is less than 'a'
    cmp al, 'f'
    jg InvalidInput         ; If greater than 'f', it's invalid
    sub al, 'a' - 10        ; Convert 'a'-'f' to 10-15
    ret

IsDigit:
    sub al, '0'             ; Convert '0'-'9' to 0-9
    ret

IsHexLetter:
    sub al, 'A' - 10        ; Convert 'A'-'F' to 10-15
    ret

InvalidInput:
    mov al, 0               ; Default to 0 on invalid input
    ret
ConvertToHex endp   




PrintInput proc
    ; Input: SI points to the start of the 16-byte input array
    ; Output: Prints each byte as two hexadecimal characters

    mov cx, 16              ; Process 16 bytes
    mov si, OFFSET input    ; Point to the input array

PrintLoop:
    mov al, [si]            ; Load the current byte into AX
    call PrintHexByte       ; Print the byte as two hexadecimal characters
    inc si                  ; Move to the next byte
    loop PrintLoop          ; Repeat for all 16 bytes

    ; Print a newline for clarity
    mov ah, 02h
    mov dl, 0Dh             ; Carriage return
    int 21h
    mov dl, 0Ah             ; Line feed
    int 21h

    ret
PrintInput endp




PrintHexByte proc
    ; Input: AL contains the byte to print (e.g., 0xAA)
    ; Output: Prints the byte as two hexadecimal characters (e.g., "AA")

    ; Extract and print the high nibble 
    mov ah, al
    and al, 0Fh
    shr ah, 4
    cmp ah, 0Ah             ; Check if high nibble >= 10
    jl PrintHighNibbleNum   ; If less than 10, it's a number
    add ah, 'A' - 10        ; Convert 10-15 to ASCII 'A'-'F'
    jmp PrintHighNibbleDone

PrintHighNibbleNum:
    add ah, '0'             ; Convert to ASCII '0'-'9'

PrintHighNibbleDone:
    mov dl, ah              ; Move high nibble ASCII to DL
    mov ah, 02h             ; DOS interrupt to print a character
    PUSH AX
    int 21h
    POP AX

    ; Extract and print the low nibble
    ;and al, 0Fh             ; Mask out everything except the low nibble
    cmp al, 0Ah             ; Check if low nibble >= 10
    jl PrintLowNibbleNum    ; If less than 10, it's a number
    add al, 'A' - 10        ; Convert 10-15 to ASCII 'A'-'F'
    jmp PrintLowNibbleDone

PrintLowNibbleNum:
    add al, '0'             ; Convert to ASCII '0'-'9'

PrintLowNibbleDone:
    mov dl, al              ; Move low nibble ASCII to DL
    mov ah, 02h             ; DOS interrupt to print a character
    int 21h

    ret
PrintHexByte endp  

