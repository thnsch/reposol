# Go Environment Setup (Terminal-focused)

This tutorial helps you restart and configure a basic Go environment manually from the terminal, including workspace setup and environment variables.

---

## 1. Install Go

Download from: https://go.dev/dl/
Unpack and move Go to a directory like `/usr/local/go`

Example: \
    `sudo tar -C /usr/local -xzf go1.xx.x.linux-amd64.tar.gz`

Add to your PATH (typically in ~/.bashrc or ~/.zshrc): \
    `export PATH=$PATH:/usr/local/go/bin `

Check version: \
    `go version `

### Install Completion
---
Documentation: https://pkg.go.dev/github.com/posener/complete#section-readme

GOPATH is still used for Go-installed tools via `go install` and `go get -u`.

Add GOPATH/bin to your PATH: \
`export PATH="$PATH:$(go env GOPATH)/bin" `

Restart your shell, e.g. zsh: \
`exec zsh -l `

Download the 'complete' package: \
`go install github.com/posener/complete/gocomplete@latest   # newer alternative to: go get -u ... `

Install: \
`gocomplete -install `

Restart your shell, e.g. zsh: \
`exec zsh -l `

Uninstall: \
`gocomplete -uninstall `

---

## 2. Define Your Go Workspace (pre Go modules)

Go modules (introduced in Go 1.11+) replace GOPATH-style workflows, but knowing GOPATH is still useful.

Classic workspace structure: \
    $HOME/go/ \
             ├── bin/ \
             ├── pkg/ \
             └── src/ \
                  └── github.com/yourname/project/ \

Set environment variable:
```
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```


---

## 3. Using Go Modules

Since Go 1.16, modules are the default — you no longer need GOPATH **for projects** using modules.

Structure:
- Project: A collection of modules. A descriptive name for a repo or a folder, nothing Go specific.
- Module : A collection of packages. Contains a go.mod file in its root directory.
- Package: A directory containing .go files with the same package declaration.

```
project/                # just a folder or a repo
├──module1/             # root of the module; also directory == package
   ├── go.mod           # declares the module name 
   ├── main.go          # e.g. package main; import "[module name]/services"
   ├── services/        # package services; directory == package
   │   └── service.go
   ├── controllers/     # package controllers; directory == package
   │   └── contoller.go
├──module2/
   ├── ...
```

Files:
- go.mod contains the
  - module path
  - minimum version of Go
  - required modules incl. minimum version
  - optional: replace directives mapping module name to local disk path, e.g. another module in a sibling-folder
- go.sum contains checksums - hashes of the
  - required modules 
  - go.mod file

To create a module-enabled project:
```
mkdir project && cd project
go mod init project           # creates go.mod
```

Add missing and remove unused modules (go.mod, go.sum): \
`go mod tidy `

Download a dependency, e.g.: \
`go get github.com/gorilla/mux `

Build the project: \
`go build `

Run it: \
`go run main.go `

Help:
```
go help
go help mod
go help mod tidy
go help build
go help run
```
---

## 4. Important Environment Variables

| Variable     | Description                          |
|--------------|--------------------------------------|
| GOROOT       | Path where Go is installed           |
| GOPATH       | Your Go workspace (for classic mode); Still used for Go-installed tools |
| PATH         | Must include both $(go env GOROOT)/bin and $(go env GOPATH)/bin |
| GO111MODULE  | Set to 'on' to force module usage    |

Example for ~/.bashrc: \
    export GOROOT=/usr/local/go \
    export GOPATH=$HOME/go \
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin \
    export GO111MODULE=on

---

## 5. Tips for Using Go in Terminal

- `go mod tidy` — clean up go.mod and go.sum
- `go test ./...` — run all tests recursively
- `go build` — compile the project
- `go run main.go` — compile and run
- `go install` — install binary to $GOPATH/bin

