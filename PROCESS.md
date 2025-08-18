# Process

Typically I separate projects based on the boundary of responsibility. IAC is the hardware, provisioning is install and configuration, execution would be in the service projects. For the purpose of this example project please consider `./iac`, `./helm/*`, and `./srv` would be individual projects in actual practice.

Oh, and typically we would not commit binary files to a Git project without using LFS. But its a couple hour long practical project so I do not see the need, lets just keep it in-tree.

## Workflow#

### Make It Work

#### Preflight

Ok, with that out of the way lets get our toolchain installed. Copy in `./libs/bash/install.sh` to leverage previous effort towards this project.

Add .gitignore before we commit undesired resources.

Tools installed, basic docs added.

How do we want to handle the public facing ELB?  As part of the cluster resources or a separate boundary?

Since this project is a all-include lets handle it ELB as part of the cluster resources deployment.

To prevent naming collisions in the case of multiple deployments of the same resources multiple times per environment, for example multiple `dev` deployments leveraging shared resources such as VPC, S3, etc, I have gotten into the practice of using a `deployment_id` per deployed instance of the stack.

I know TF has workspaces, but I feel they do not provide enough isolation. Plus they are a bit of a pain to work with in my experience.

- Tag all resources using the provider

- Use AWS EKS Auto Mode. When it comes to infra my experience has been less-is-more;/ until the organization reaches such a point that the cost of labour is less than the benefits of over-optimization.

Each IAC configuration type gets its own file, makes finding things a lot easier later on.

For simplicity, but never in actual deployments, store the state file locally. A good deployment we must store the state file remotely.

#### IAM, VPC, EKS

Now deploy the network and IAM resources.

Bring the VPC modules up to the most recent published version.

To cover the requirement of High Availability (HA) within the scope of the project the EKS cluster spans 3 availability zones. If we wanted even more assurance we do multiple regions and join the clusters.

At this point we have a VPC w/ 3 public and 3 private subnets and a Kubernetes cluster deployed

#### Container Service

Lets pull the image locally and run it to understand the output.

I would really prefer a SemVer tagged and published version of the image but the requirements say to use the latest.

```sh
podman pull gradyent/tech-interview:latest
podman image ls
podman inspect
podman run -d --rm -p 8080:80 gradyent/tech-interview:latest
podman container list
curl --verbose 127.0.0.1:8080
```

Odd, the connection is reset by peer.

Pull the nginx container and test

```sh
podman pull nginx:1.28.0-alpine3.21
podman run -d --rm -p 8080:80 nginx:1.28.0-alpine3.21
curl --verbose 127.0.0.1:8080
```

Yep, nginx responds.

Lets check the layers from Docker Hub at https://hub.docker.com/layers/gradyent/tech-interview/latest/images/sha256-ee575cdcaa8d5247f6b9e07bd6fb38452d518db538aa87c1ef6c26ab62f3f992

Copies in a Go binary on step 14, sets a non-root user on step 15 (very good security practice) then step 16 is the CMD calling `/app`... but the binary is at `/go/bin/app`.

Lets try to run the container using `/go/bin/app` as the command... nope.

Registry says it was last updated 5 months ago. No way its broken. What am I doing wrong here? It's a simple container?...

`podman logs [[RUNNING CONTAINER HASH]]` returns nothing, even after trying to hit the endpoint.

Container does not contain `bash` nor `sh` commands.

Ok, lets try it with `docker` instead of `podman`

```sh
docker run -it --rm -p 8080:80 gradyent/tech-interview:latest
# service is running
netstat -tupln
...
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
...
tcp6       0      0 :::8080                 :::*                    LISTEN      181600/pasta        
...
# 8080 is open and listening
curl --location --verbose 127.0.0.1:8080
curl --location --verbose 0.0.0.0:8080
# both return "connection rest by peer
```

Ok, lets tail the logs

```sh
podman run -d -it --rm -p 8080:80 docker.io/gradyent/tech-interview /app
podman logs -f [[CONTAINER_NAME]]
curl --location --verbose 0.0.0.0:8080
```

Nothing. Do I reach out to Gradyent at this point?

Trying to read anything from inside the container via `ls`, `whoami`, `cat /proc`. All returns `OCI runtime attempted to invoke a command that was not found`.



### Make It Right

### Make If Fast

## Additional Deliverables

- Scalability

Services within the cluster can be configured to auto-scale based on a number of resource usage parameters. CPU, MEM, connection count, etc. CPU and MEM can be handled by the cluster natively, for other scaling triggers custom controllers or even CloudWatch could be leveraged.

- Monitoring

CloudWatch Metrics and Logs is the easy answer here, but also the Prometheus Controller is also a good option. Coupled with an alerting system to inform operators when a service is operating near or past allowable boundaries.

- Cost

AWS Budget to keep accounts within an allowable spend. To help with this scaling-to-zero any internal accounts during off hours.

- Ease of use

Project toolchain install via `./libs/bash/install.sh` (Fedora 42 only, sorry)

to install the ingress and service is a matter of executing the following

```sh

Helm ...
```

## Bonus Items

- CI/CD pipeline

- Ingress configuration

- An architecture diagram

- Security Considerations

- Impress us
