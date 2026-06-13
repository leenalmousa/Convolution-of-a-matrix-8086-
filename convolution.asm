data segment
    
    

indata  db 2,0,2,1,0,2,6,8           ; my uni id 20210268 
        db 4,0,4,2,0,4,12,15
        db 6,0,6,3,0,6,7,10          ; edited the numbers in the intilzation of theindata as some of them are larger that 15
                                     ; so that would mean that i cant represent them using one hex digit 
        db 8,0,8,4,0,8,2,4
        db 10,0,10,5,0,10,0,6
        db 12,0,12,6,0,12,6,8
        db 14,0,14,7,0,14,2,4
        db 12,0,12,8,0,6,8,4  
         
outdata db 36 dup(0)                 ; Reserve enough space for output

        
    
intext db  "The original input in hexadecimal$"   ;text to print on screen pre input data 
outext   db  "The output after convolution in hexadecimal$"        ;text to print on screen pre output data 



ends

stack segment
   
ends

code segment
start: 
    mov ax, data        ; set  the datasegment register and extra register   to point at data segment defined earlier  
    mov ds, ax
    mov es, ax
    call print_in_text   ; procedure to print the (intext)
    mov dx,10            ; returning cursor to inital position
    mov ah,02h
    int 21h
    mov dx,13
    mov ah,02h
    int 21h 
    call print_data_in   ; procedure to print the  data before convelution
    call print_out_text  ; procedure to print the (outtext)
    mov dx,10            ; returning cursor to inital position
    mov ah,02h
    int 21h
    mov dx,13
    mov ah,02h
    int 21h 
    call calc_avg        ;procedure perform calculations onthe in data and store in in the designated address 
    call print_data_out  ; procedure to print the  data after convelution


  
   
    ; Exit program
    mov ax, 4c00h
    int 21h 
            
            
print_in_text proc
    lea dx,intext    ; print the intext 
    mov ah,09h
     int 21h
     ret 
print_in_text endp                

print_out_text proc
    lea dx,outext     ; print the outtext 
    mov ah,09h
     int 21h
     ret 
print_out_text endp             
            
print_data_out proc
    lea si, outdata           ; Load address of outdata into SI
    mov cx, 6                 ; Outer loop counter

r_loop:
    push cx                   ; Save outer loop counter
    mov cx, 6                 ; Inner loop counter

c_loop:
    mov dl, [si]              ; Load data from memory into DL
       cmp dl,9h
    jge char1
    add dl, 30h 
    jmp next1
char1:
    add dl, 37h 
next1:                    ; Convert to ASCII 
    mov ah, 02h               ; Print character 
    int 21h
    inc si                    ; Move to nextcolumn
    loop c_loop              ; Repeat inner loop

   
    mov dl, 10                ;fix the cursor postion
    mov ah, 02h
    int 21h
    mov dl, 13               
    mov ah, 02h
    int 21h

    pop cx                    ; Restore outer loop counter
    loop r_loop            

    ret
print_data_out endp
  

print_data_in proc
    lea si, indata            ; Load address of outdata into SI
    mov cx, 8                 ; Outer loop counter

out_loop:
    push cx                   ; Save outer loop counter
    mov cx, 8                 ; Inner loop counter

in_loop:
    mov dl, [si]              ; Load data from memory into DL
    cmp dl,9h
    jge char
    add dl, 30h 
    jmp next
char:
    add dl, 37h 
next:                    ; Convert to ASCII 
    mov ah, 02h               ; Print character 
    int 21h
    inc si                    ; Move to nextcolumn
    loop in_loop              ; Repeat inner loop

   
    mov dl, 10                ;fix the cursor postion
    mov ah, 02h
    int 21h
    mov dl, 13               
    mov ah, 02h
    int 21h

    pop cx                    ; Restore outer loop counter
    loop out_loop           

    ret
print_data_in endp




calc_avg proc   
    lea si,indata
    lea di,outdata
    mov cx,6 
   rows_loop:
    push cx             ; Save Row's loop counter
    mov cx,6            ; Set the column's  loop counter to 6
  
    columns_loop:
    mov ax, 0
    ; Sum 3x3 block
    add al, [si]        ; First row
    add al, [si+1]
    add al, [si+2]
    add al, [si+8]      ; Secound  row
    add al, [si+9]     
    add al, [si+10]
    add al, [si+16]     ; Third row
    add al, [si+17]
    add al, [si+18]
    ; Divide by 9
    mov bl, 9
    div bl
    ; Store result in outdata
    mov [di], al 
    
               
    ; Move to the next column 
    inc di
    inc si
    loop columns_loop 
    
    add si,2           ; move to next row 
   
    pop cx              ; Restore outer loop counter
    loop rows_loop    
    ret
calc_avg endp
end start

ends       
