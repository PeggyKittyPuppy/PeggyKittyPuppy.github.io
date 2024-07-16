generate: $(SRC)
	emacs -x blog.el

g: generate

server:
	python -m http.server

s: server

clean:
	find . -name "*.html" -type f -exec rm {} \;
