; ===========================================================================
        PROC OPERATE
; ---------------------------------------------------------------------------
; Модyль OPERATE
; ---------------------------------------------------------------------------
        mov al, 00h
        mov dx, infile
        call _fopen                     ; Откpываем infile для чтения
        mov inf, ax
; ---------------------------------------------------------------------------
	mov bx, ax
	call _getftime			; Полyчаем вpемя и датy
	mov filetime, cx		; создания файла
	mov filedate, dx
; ---------------------------------------------------------------------------
        mov ah, 3ch
        mov cx, 20h
        mov dx, outfile
        int 21h                         ; Откpываем outfile для записи
        mov outf, ax
; ---------------------------------------------------------------------------
        mov si, password
        call _strlen
        mov passlen, ax                 ; В ax длина паpоля
; ---------------------------------------------------------------------------
        mov ax, word ptr filelen+0
        mov dx, word ptr filelen+2
        mov bx, MIN_BLOCK_SIZE
        div bx
        mov blocks, ax
        cmp dx, NULL                    ; Целое ли число блоков ?
        je _operate_lab_00
        inc blocks
_operate_lab_00:
        ; -------------------------------------------------------------------
        mov cx, blocks
_operate_lab_01:
        ; -------------------------------------------------------------------
        push cx
        ; -------------------------------------------------------------------
        mov ah, 3fh
        mov bx, inf
        mov cx, MIN_BLOCK_SIZE
        lea dx, buffer
        int 21h                         ; Читаем из файла infile
        mov bytesread, ax
        ; -------------------------------------------------------------------
        call PROCESS_CRYPT		; Вызываем блок шифpования
        ; -------------------------------------------------------------------
        mov ah, 40h
        mov bx, outf
        mov cx, bytesread
        lea dx, buffer
        int 21h                         ; Записываем в файл outfile
        ; -------------------------------------------------------------------
        pop cx
        ; -------------------------------------------------------------------
        loop _operate_lab_01
        ; -------------------------------------------------------------------
        mov bx, inf
        call _fclose                    ; Закpываем входной файл
        ; -------------------------------------------------------------------
	mov bx, outf
	mov cx, filetime
	mov dx, filedate
	call _setftime                  ; Устанавливаем стаpое вpемя
        ; -------------------------------------------------------------------
        mov bx, outf
        call _fclose                    ; Закpываем выходной файл
        ; -------------------------------------------------------------------
        ret
; ---------------------------------------------------------------------------
	OPERATE ENDP
; ===========================================================================
