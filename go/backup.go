package main

import (
	"github.com/docker/go-dockercloud/dockercloud"
	"log"
)

/**
 * Compiling instruction:
 * ---------------------
 *
 * `go build`
 *
 * Usage:
 * -----
 *
 * `DOCKERCLOUD_USER=visay DOCKERCLOUD_APIKEY=<token> ./go`
 *
 * Note: Get docker cloud api key from docker cloud user account settings
 */

func main() {
	dockercloud.User = "visay"
	dockercloud.Namespace = "prettygreenplants"

	// Uuid of docker cloud service to execute
	service, err := dockercloud.GetService("54182f71-ff94-4682-99b4-479dc2b5e0e0")

	if err != nil {
		log.Println(err)
	}

	if err = service.Update(dockercloud.ServiceCreateRequest{Target_num_containers: 1}); err != nil {
		log.Println(err)
	}

	if err = service.Start(); err != nil {
		log.Println(err)
	}
}
