
all:
	ocamlbuild -use-ocamlfind main.byte

clean:
	ocamlbuild -clean
