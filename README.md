# NAME

## Table of Contents

- [NAME](#name)
  - [Table of Contents](#table-of-contents)
  - [Objective](#objective)
  - [Thought Process and Procedure Flow](#thought-process-and-procedure-flow)
  - [RoadMap](#roadmap)
  - [Runbook](#runbook)
  - [Requirements](#requirements)
  - [Usage](#usage)
  - [Usage - Optional](#usage---optional)
    - [Public DNS + TLS](#public-dns--tls)
    - [Visuals Generation](#visuals-generation)
    - [Kubernetes Dashboard](#kubernetes-dashboard)
  - [Versioning](#versioning)
  - [Contributors](#contributors)
  - [Additional Information](#additional-information)

## Objective

Sourced from [./gradyent-practical.pdf](./gradyent-practical.pdf)

What We're Looking For: Our main focus is on your solution design. Can it handle
automation and scalability in a production environment, serving hundreds of customers in
a multi-tenant setup? Completing the entire assignment is not necessary; we are primarily
interested in your approach to the problem, and we will discuss it further during the
technical interview.

Task Overview:

1. Deploy an EKS cluster using Terraform

2. Create and deploy a Helm chart for the Docker image `docker pull gradyent/tech-interview:latest`, with the following requirements

- Configure a readiness probe for :8080/ (returns "OK")

- Configure a liveness probe for :8080/hello (returns "world")

Solution Requirements: The solution should address:

- Scalability
- Monitoring
- Cost
- Ease of use

Bonus Points for including:

- CI/CD pipeline

- Ingress configuration

- An architecture diagram

- Security considerations

- Impress us

Finally, submit your solution in a Git repository, including a README file.

## Thought Process and Procedure Flow

Follow along as we think and execute the process to satisfy the practices requirements via the [./PROCESS.md](./PROCESS.md).

## RoadMap

Upcoming planned project changes and feature adds.

## Runbook

A collection of errors and corrective actions within the scope of this project.

[./RUNBOOK](./RUNBOOK.md)

## Requirements

- AWS account with administrative permissions
- AWS CLI tool
- Kubernetes CLI tool
- Helm CLI tool
- (optional) AWS Route53 Hosted Zone

## Usage

```sh
git clone https://github.com/davidjeddy/gradyent-practical.git
cd gradyent-practical
export PROJECT_ROOT="$(pwd)"

# Deploy IAC
cd ${PROJECT_ROOT}/iac/aws/dev/eu-west-1/gpp0/web-app
terraform apply

# Deploy Kubernetes service
helm install web-app ./helm/web-app --values ./srv/web-app/dev/eu-west-1/gpp0/values.yaml 

# Wait for service to come ready, while we do that get the load balancer DNS
export LB_DNS="$(kubectl get Ingress/ingress-web-app-public -n web-app -o "jsonpath={.status.loadBalancer.ingress[0].hostname}")"

curl --location --verbose http://${LB_DNS}
curl --location --verbose http://${LB_DNS}/hello
```

## Usage - Optional

### Public DNS + TLS

```sh
cd ${PROJECT_ROOT}/iac/aws/dev/eu-west-1/gpp0/acm
# Edit variables
vi variables.tf
# Provide values for root_domain and web_app_elb_arn. Save and exit.
# Deploy IAC
terraform apply
```

### Visuals Generation

```sh
cd ${PROJECT_ROOT}/iac/aws/dev/eu-west-1/gpp0/web-app
terraform plan -out plan.out
terraform show -json plan.out > plan.json
podman run --rm -it -p 9000:9000 -v $(pwd)/plan.json:/src/plan.json:z im2nguyen/rover:latest -planJSONPath=plan.json
```

### Kubernetes Dashboard

```sh
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
```

Open browser and visit `https://localhost:8443` and follow the displayed command.

## Versioning

This project follows [SemVer 2.0](https://semver.org/) tagging pattern.

```quote
Given a version number MAJOR.MINOR.PATCH, increment the:

1. MAJOR version when you make incompatible API changes,
2. MINOR version when you add functionality in a backwards compatible manner, and
3. PATCH version when you make backwards compatible bug fixes.

Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.
```

## Contributors

## Additional Information

- [Changelog](https://github.com/olivierlacan/keep-a-changelog)
- Based on [README Maturity Model](https://github.com/LappleApple/feedmereadmes/blob/master/README-maturity-model.md); strive for a Level 5 `Product-oriented README`.
- [LICENSE](./LICENSE.md) sources from.
