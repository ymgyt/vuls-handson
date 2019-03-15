// +build mage

package main

import (
	"fmt"
	"os"

	"github.com/magefile/mage/mg"
	"github.com/magefile/mage/sh"
)

const (
	dockerTag           = "vlusho"
	dockerContainerName = "vulsho"
)

var Aliases = map[string]interface{}{
	"docker:rm": Docker.Remove,
}

var sshDir = os.Getenv("SSH_DIR")

type Docker mg.Namespace

// Build build docker image.
func (d Docker) Build() {
	sh.RunV("docker", "build", "--tag", dockerTag, ".")
}

// Run docker image.
func (d Docker) Run() {
	sh.RunV("docker", "run",
		"--name", dockerContainerName, "-it",
		"--mount", fmt.Sprintf("type=bind,src=%s,dst=/root/vuls", cwd()),
		"--mount", fmt.Sprintf("type=bind,src=%s,dst=/root/.ssh/", sshDir),
		"--publish", "5111:5111",
		dockerTag, "/bin/bash")
}

// Remove remove docker container.
func (d Docker) Remove() {
	sh.RunV("docker", "container", "rm", dockerContainerName)
}

// All recreate container.
func (d Docker) All() {
	d.Remove()
	d.Build()
	d.Run()
}

func cwd() string {
	d, err := os.Getwd()
	if err != nil {
		panic(err)
	}
	return d
}
