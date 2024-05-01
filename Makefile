generate:
	tuist install
	TUIST_ROOT_DIR=${PWD} TUIST_SCHEME=DEBUG tuist generate

feature:
	python Scripts/TuistScript.py feature
	tuist edit

share:
	python Scripts/TuistScript.py share
	tuist edit

core:
	python Scripts/TuistScript.py core
	tuist edit

archive:
	python Scripts/EditArchiveVersion.py
	TUIST_ROOT_DIR=${PWD} TUIST_SCHEME=DEBUG tuist generate
