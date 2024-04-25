MKFILE_DIR := $(abspath $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))))

# Make Terraform Documentation
.PHONY: docs
docs:
	for directory in .; do \
	  terraform-docs markdown table --output-file README.md --output-mode inject "$${directory}" ; \
	done

.Phony: format
format:
	terraform fmt -recursive && cd ..

.PHONY: fixcommit
fixcommit:
	pre-commit run --all-files

.PHONY: diagram
diagram:
	python3 diagram.py

.PHONY: tflint
tflint:
	tflint --recursive
