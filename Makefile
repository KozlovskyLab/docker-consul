all: build

build:
	@docker build -t ${USER}/consul —-no-cache .
