generate:
	tuist fetch
	TUIST_ROOT_DIR=${PWD} TUIST_SCHEME=DEBUG tuist generate

feature:
	python Scripts/TuistScript.py feature
	tuist edit

shared:
	python Scripts/TuistScript.py shared
	tuist edit

core:
	python Scripts/TuistScript.py core
	tuist edit

archive:
	python Scripts/EditArchiveVersion.py
	tuist fetch
	TUIST_ROOT_DIR=${PWD} TUIST_SCHEME=DEBUG tuist generate
