# Process

Typically I separate projects based on the boundary of responsibility. IAC is the hardware, provisioning is install and configuration, execution would be in the service projects. For the purpose of this example project please consider `./iac`, `./helm/*`, and `./srv` would be individual projects in actual practice.

Oh, and typically we would not commit binary files to a Git project without using LFS. But its a couple hour long practical project so I do not see the need, lets just keep it in-tree.

## Workflow

### Session 1

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

```sh
podman top priceless_brahmagupta
```

Shows the process running, ok thats something.

When trying to exec into the container using `/app` I get `2025/08/18 19:28:26 listen tcp :8080: bind: address already in use`. :|

Really. The documentation is incorrect. Its not port `80` inside the container. Its `8080`. The following returns `ok` and `world` as expected:

```sh
podman run -it --rm -p 8080:8080 docker.io/gradyent/tech-interview:latest /app
da$ curl --location --verbose 127.0.0.1:8080/
ok
$ curl --location --verbose 127.0.0.1:8080/hello
world!
* Connection #0 to host 127.0.0.1 left intact
```

That was an incorrect assumption on my part :/. :facepalm:

Now with that out of the way, on to configuring the Kube resources.

#### Kubernetes service, without Helm

Add the raw Kube resources for the service, the deployment, and the ingress.

- As discussed above we will use resources to deploy the ELB given the context and scope of this project.

Note: Do not forget to add permissions to the IAM user used to access the cluster via `Access` in the web UI. Again, typically we would codify this access bu this is an example project.

```sh
aws eks update-kubeconfig --region eu-west-1 --name dev-gradyent-gpp0
kubectl config set-context dev-gradyent-gpp0
kubectl get ns

cd ./srv/web-app
kubectl apply -f ingressClass.yaml 
kubectl apply -f ingress.yaml
kubectl apply -f service.yaml
kubectl apply -f deployment.yaml
```

This is a good stopping place for now. Destroying the resources to save costs and committing what we have so far.

### Session 2

AWS web UI is inconsistent when assigning cluster permissions. You have to press `add permission` for each permission set :/. #dumb. Also dumb UI is the `X` to close the success message ends up being right over the `delete` button on some views.

Like yesterday the folders under `./srv` would be isolated projects. Ideally sharing a pipeline with source, build, test, tag, publish, deploy stages.

```sh
cd ./src/web-app
kube apply -f .
```

Ok deployment to default namespace works, now destroy move it to a non-default namespace. Lets use namespace `web-app`. Apply the `namespace.yaml` first, then all the other resources

```sh
kube destroy -f .
# edit namespace.yaml
kube apply -f namespace.yaml
kube apply -f .
```

Wait for the ELB to provision...

```sh
$ kubectl get all -n web-app
NAME                                     READY   STATUS    RESTARTS   AGE
pod/deployment-web-app-545587d9f-7t4z7   1/1     Running   0          4m29s
pod/deployment-web-app-545587d9f-cmvg5   1/1     Running   0          4m29s
pod/deployment-web-app-545587d9f-wggsr   1/1     Running   0          4m29s

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/service-web-app   ClusterIP   172.20.158.242   <none>        80/TCP    4m35s

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/deployment-web-app   3/3     3            3           4m29s

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/deployment-web-app-545587d9f   3         3         3       4m29s
```

and 

```sh
curl --location --verbose http://k8s-webapp-ingressw-72770ac2d5-2065808880.eu-west-1.elb.amazonaws.com/
* Host k8s-webapp-ingressw-72770ac2d5-2065808880.eu-west-1.elb.amazonaws.com:80 was resolved.
* IPv6: (none)
* IPv4: 54.171.44.59, 18.203.13.22, 54.171.31.221
*   Trying 54.171.44.59:80...
* Connected to k8s-webapp-ingressw-72770ac2d5-2065808880.eu-west-1.elb.amazonaws.com (54.171.44.59) port 80
* using HTTP/1.x
> GET / HTTP/1.1
> Host: k8s-webapp-ingressw-72770ac2d5-2065808880.eu-west-1.elb.amazonaws.com
> User-Agent: curl/8.11.1
> Accept: */*
> 
* Request completely sent off
< HTTP/1.1 200 OK
< Date: Tue, 19 Aug 2025 19:25:40 GMT
< Content-Type: text/plain; charset=utf-8
< Content-Length: 2
< Connection: keep-alive
< 
* Connection #0 to host k8s-webapp-ingressw-72770ac2d5-2065808880.eu-west-1.elb.amazonaws.com left intact
ok
```

Success. Our service is running and accessible from the internet.

Now time to Helm'ify the service

#### Kubernetes service with Helm

```sh
cd ./srv/web-app
helm create web-app
```

Replace the generated Kube configs with ours and deploy.

```sh
$ helm install web-app .

$ kubectl get all -n web-app
NAME                                     READY   STATUS    RESTARTS   AGE
pod/deployment-web-app-545587d9f-gkp24   0/1     Pending   0          29s
pod/deployment-web-app-545587d9f-hx75v   0/1     Pending   0          29s
pod/deployment-web-app-545587d9f-x4s24   0/1     Pending   0          29s

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/service-web-app   ClusterIP   172.20.250.51   <none>        80/TCP    29s

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/deployment-web-app   0/3     3            0           29s

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/deployment-web-app-545587d9f   3         3         0       29s

$ helm status web-app
NAME: web-app
LAST DEPLOYED: Tue Aug 19 21:58:40 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1

$ helm history web-app
REVISION	UPDATED                 	STATUS  	CHART        	APP VERSION	DESCRIPTION     
1       	Tue Aug 19 21:58:40 2025	deployed	web-app-0.1.0	0.0.1      	Install complete

```

Nice, replace the repeated and configurable values with `Chart` and `values` values.

Update deployment, success.

Now lets mode the values.yaml into a path that matches the IAC pathing a bit better. This way it is easy to map a Helm deployment to a specific IAC resource group.

### Session 3

Now that we have a functional service in a cluster lets add a bit of flare:

- Pretty sub-domain w/ TLS
- Auto add EKSClusterPermission to existing IAM user
- Kubernetes Dashboard

### Make It Right

### Make If Fast
