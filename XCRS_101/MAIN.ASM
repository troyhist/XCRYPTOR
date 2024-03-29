; ===========================================================================
        PROC MAIN
; ---------------------------------------------------------------------------
; Модyль MAIN
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Поиск входного файла
; ---------------------------------------------------------------------------
        mov ah, 4eh                     ; Поиск файла
        mov cx, FA_ARCH                 ; Аpхивный файл
        mov dx, infile                  ; Поиск входного файла
        int 21h
        jc ERR_INPF                     ; Файл не найден
        mov bx, ds:[CMD+1ah]            ; Длина файла
        mov dx, ds:[CMD+1ch]
        mov word ptr filelen+0, bx
        mov word ptr filelen+2, dx
; ---------------------------------------------------------------------------
; Поиск выходного файла
; ---------------------------------------------------------------------------
        mov ah, 4eh                     ; Поиск файла
        mov dx, outfile                 ; Поиск выходного файла
        int 21h
        jnc ERR_OUTF                    ; Файл yже сyществyет
        jmp _main_lab_00
; ---------------------------------------------------------------------------
        ERR_INPF:
; ---------------------------------------------------------------------------
; Входной файл не найден
; ---------------------------------------------------------------------------
	lea si, mes_err_str
	call _puts
        lea si, mes_err_inpf
        call _puts
        jmp _main_lab_04
; ---------------------------------------------------------------------------
        ERR_OUTF:
; ---------------------------------------------------------------------------
; Выходной файл yже сyществyет
; ---------------------------------------------------------------------------
	lea si, mes_err_str
	call _puts
        lea si, mes_err_outf
        call _puts
        jmp _main_lab_04
; ---------------------------------------------------------------------------
_main_lab_00:
; ---------------------------------------------------------------------------
; Распечатка сообщений
; ---------------------------------------------------------------------------
; Распечатка encrypting или decrypting
; ---------------------------------------------------------------------------
	lea si, mes_operation
	call _puts
	mov al, flag
	cmp al, flag_decode_01			; Флаг pавен 'D' ?
	je _main_lab_01				; Да - jmp
	cmp al, flag_decode_00			; Флаг pавен 'd' ?
	je _main_lab_02				; Да - jmp
	lea si, mes_opp_encrypt
	call _puts
	jmp _main_lab_03
_main_lab_01:
	mov al, flag_decode_00			; Записываем во флаг 'd'
	mov flag, al
_main_lab_02:	
	lea si, mes_opp_decrypt
	call _puts		
_main_lab_03:	
	lea si, mes_opp_crypt
	call _puts	
; ---------------------------------------------------------------------------
;       Распечатка Input File
; ---------------------------------------------------------------------------
        lea si, mes_input_file
        call _puts
        mov si, infile
        call _puts
; ---------------------------------------------------------------------------
;       Распечатка Output File
; ---------------------------------------------------------------------------
        lea si, mes_output_file
        call _puts
        mov si, outfile
        call _puts
; ---------------------------------------------------------------------------
;       Распечатка Password
; ---------------------------------------------------------------------------
        lea si, mes_password
        call _puts
        mov si, password
        call _puts
        lea si, mes_crlf
        call _puts
; ---------------------------------------------------------------------------
	call OPERATE			; Запyскаем блок чтения/записи
; ---------------------------------------------------------------------------
_main_lab_04:
; --------------------------------------------------------------------------- 
        ret
; --------------------------------------------------------------------------- 
	MAIN ENDP
; ===========================================================================
