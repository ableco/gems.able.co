.PHONY: test

console:
	irb -Ilib -r 'scholar'

test:
	cutest test/**.rb
