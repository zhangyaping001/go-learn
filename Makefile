GO := go
GOOS := linux
GO_ENVS := CGO_ENABLED=0 GOOS=${GOOS} GOPROXY=direct GOSUMDB=off
GO_TOOL_ENVS := CGO_ENABLED=0 GOPROXY=direct GOSUMDB=off

BUILD_TIME = $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
VERSION := $(shell cat VERSION | tr -d '\n')
ENV := dev

GO_LD_FLAGS = \
	-X main.BuildTime=${BUILD_TIME} \
	-X main.Version=${VERSION} \
	-X main.Env=${ENV}

GO_BUILD_FLAGS = -v -ldflags='${GO_LD_FLAGS}'

BINARIES = go-learn
VERSION_NAME = ${BINARIES}-${VERSION}
DIST := dist/${VERSION_NAME}
TAR = ${VERSION_NAME}.tar.gz
PKGS = $(shell ${GO} list ./... | tr '\n' ',')
EXEC := ${DIST}/bin/${BINARIES}

.PHONY: all  build clean pkg fmt check-fmt 

all: clean pkg

build: 
	env ${GO_ENVS} ${GO} build ${GO_BUILD_FLAGS} -o ${EXEC} .

clean:
	rm -rf ${TAR}
	rm -rf dist

pkg: build
	chmod a+x ${EXEC}
	tar -zcf ${TAR} -C dist ${VERSION_NAME}
	@echo "Build successfully"

fmt:
	goimports -w .

check-fmt:
	@test -z "`goimports -l .`"

