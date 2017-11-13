.PHONY: all publish server

all:

publish:
	./bin/publish.sh --force

server:
	# runs a server on localhost for testing
	hugo server -D
