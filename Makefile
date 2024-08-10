generate:
	tuist install
	TUIST_ROOT_DIR=${PWD} TUIST_SCHEME=DEBUG tuist generate

feature:
	python3 Scripts/TuistScript.py feature
	tuist edit

share:
	python3 Scripts/TuistScript.py share
	tuist edit

core:
	python3 Scripts/TuistScript.py core
	tuist edit

archive:
	python3 Scripts/EditArchiveVersion.py
	TUIST_ROOT_DIR=${PWD} TUIST_SCHEME=DEBUG tuist generate

graph:
	tuist graph -d
