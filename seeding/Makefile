
all: seed

seed: refs-to-seed seed.sh
	./seed.sh

bootstrap:
	@echo "/ipfs/"`ipfs add -q -w bootstrap.sh`
