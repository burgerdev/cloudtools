
build:
	jbuilder build

examples: build
	jbuilder build @examples

test: build examples

clean:
	jbuilder clean

.PHONY: build examples test clean
