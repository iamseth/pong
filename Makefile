SHELL := /bin/bash


package: clean test
	@zip -9 -r Pong.love *lua assets

test:
	@luacheck  --std love --codes .

clean:
	@rm Pong.love

run: package
	@love Pong.love

.PHONY: build test clean run
