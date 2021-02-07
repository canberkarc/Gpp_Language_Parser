all:
	lex gpp_interpreter.l 
	yacc -d gpp_interpreter.y 
	gcc lex.yy.c y.tab.c -w -o gpp_interpreter.out -lm
	
run:
	./gpp_interpreter.out inputFile.g++ 