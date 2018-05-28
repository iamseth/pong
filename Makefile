SHELL := /bin/bash


package: clean test
	@zip -9 -r Pong.love *lua

test:
	@luacheck  --std love --codes .

clean:
	@rm Pong.love

.PHONY: build test clean
