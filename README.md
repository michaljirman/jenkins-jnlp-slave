# Jenkins JNLP Agent Docker image with the kubectl and helm pre-installed
  
The image is based on the official Jenkins jnlp-slave image. 
  
It allows for a jenkins slave deployed into a kubernetes cluster to be able to run the kubectl and helm commands.
  
## Building image
  
```bash
    make docker_build
    make docker_push
```