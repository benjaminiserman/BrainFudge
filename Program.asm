segment .data

	enter_code_str		db		"Enter BrainFudge code: (press enter twice to run)",10,0
	nl		db		10,0
	d_fmt		db		"%d ",0
	c_fmt		db		"%c",0
	start_curly		db		"{ ",0
	end_curly		db		"}",10,0

segment .bss

	buffer		resb	1024
	current		resq	1 ; the stack wasn't working ok
	left_anchor	resq	1 ; ^

segment .text

	global  main
	extern  fgets
	extern	scanf
	extern  printf
	extern	stdin
	extern	malloc

main:
	push	rbp
	mov		rbp, rsp

	; print_start prompt
	mov		rdi, enter_code_str
	call	printf

	; fgets(buffer, 1024, stdin)
	mov     rdx, QWORD stdin[0]
	lea     rax, buffer
	mov     esi, 1024
	mov     rdi, rax
	call    fgets

	; current = malloc(24); all values init to 0
	mov		edi, 24
	call	malloc
	mov		QWORD [current], rax ; current
	mov		QWORD [left_anchor], rax ; left_anchor
	mov		DWORD [rax], 0 ; val
	mov		DWORD [rax + 8], 0 ; left
	mov		DWORD [rax + 16], 0 ; right

	; execute BF code in buffer
	mov		r15, 0 ; i = 0
	code_start:
	mov		cl, BYTE [buffer + r15] ; cl = buffer[i]
	cmp		cl, 0
	mov		r10, QWORD [current] ; r10 = current
	je		code_end
		cmp		cl, '+' ; switch (cl)
		je		plus
		cmp		cl, '-'
		je		minus
		cmp		cl, '<'
		je		left
		cmp		cl, '>'
		je		right
		cmp		cl, '['
		je 		l_brace
		cmp		cl, ']'
		je		r_brace
		cmp		cl, ','
		je		input
		cmp		cl, '.'
		je		output
		
		jmp		code_inc ; default: continue

		plus:
			add		QWORD [r10], 1 ; current++
			jmp		code_inc
		minus:
			sub		QWORD [r10], 1 ; current--
			jmp		code_inc
		left:
			cmp		QWORD [r10 + 8], 0
			je		make_left
				mov		r10, QWORD [r10 + 8] ; current = current->left
				mov		QWORD [current], r10
				jmp		code_inc
			make_left:
				mov		edi, 24
				call	malloc
				mov		r10, QWORD [current] ; restore r10
				mov		QWORD [r10 + 8], rax ; left = new
				mov		QWORD [current], rax ; current
				mov		QWORD [left_anchor], rax ; left_anchor = current
				mov		QWORD [rax], 0 ; val
				mov		QWORD [rax + 8], 0 ; left
				mov		QWORD [rax + 16], r10 ; right
				jmp		code_inc
		right:
			cmp		QWORD [r10 + 16], 0
			je		make_right
				mov		r10, QWORD [r10 + 16] ; current = current->right
				mov		QWORD [current], r10
				jmp		code_inc
			make_right:
				mov		edi, 24
				call	malloc
				mov		r10, QWORD [current] ; restore r10
				mov		QWORD [r10 + 16], rax ; right = new
				mov		QWORD [current], rax ; current
				mov		QWORD [rax], 0 ; val
				mov		QWORD [rax + 8], r10 ; left
				mov		QWORD [rax + 16], 0 ; right
				jmp		code_inc
		l_brace:
			cmp		QWORD [r10], 0 ; if current == 0
			jne		code_inc
			mov		r14, 1 ; open = 1
			l_brace_start:
			cmp		r14, 0 ; if open == 0
			jle		code_inc
				inc		r15 ; i++
				mov		cl, BYTE [buffer + r15] ; cl = buffer[i]
				cmp		cl, '[' ; switch cl
				je		l_brace_l
				cmp		cl, ']'
				je		l_brace_r
				jmp		l_brace_start
				l_brace_l: ; [ -> open++
					inc		r14
					jmp		l_brace_start
				l_brace_r: ; ] -> open--
					dec		r14
					jmp		l_brace_start
		r_brace:
			cmp		QWORD [r10], 0 ; if current != 0
			je		code_inc
			mov		r14, 1 ; open = 1
			r_brace_start:
			cmp		r14, 0 ; if open == 0
			jle		code_inc
				dec		r15 ; i--
				mov		cl, BYTE [buffer + r15] ; cl = buffer[i]
				cmp		cl, '[' ; switch cl
				je		r_brace_l
				cmp		cl, ']'
				je		r_brace_r
				jmp		r_brace_start
				r_brace_l: ; [ -> open--
					dec		r14
					jmp		r_brace_start
				r_brace_r: ; ] -> open++
					inc		r14
					jmp		r_brace_start
		input:
			mov		rdi, c_fmt ; scanf("%c", current)
			mov		rsi, QWORD [current]
			call	scanf
			jmp		code_inc
		output:
			mov		rdi, c_fmt ; printf("%c", current)
			mov		rsi, QWORD [current]
			mov		rsi, QWORD [rsi]
			call	printf
			jmp		code_inc
	code_inc:
	inc		r15 ; i++
	jmp		code_start
	code_end:
	
	mov		rax, QWORD [left_anchor] ; current = left_anchor
	mov		QWORD [current], rax
	
	mov		rdi, start_curly ; printf("{ ")
	call	printf
	print_start:
		mov		rdi, d_fmt ; printf("%d", current->val)
		mov		rsi, QWORD [current]
		mov		rsi, QWORD [rsi]
		call	printf
		mov		r10, QWORD [current] ; fix r10
		cmp		QWORD [r10 + 16], 0 ; stop if current->right == NULL
		je		print_end
		mov		r10, QWORD [r10 + 16] ; current = current->right
		mov		QWORD [current], r10
		jmp		print_start
	print_end:
	mov		rdi, end_curly ; printf("}\n")
	call	printf

	mov		rax, 0
	mov		rsp, rbp
	pop		rbp
	ret
