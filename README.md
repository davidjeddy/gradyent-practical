# NAME

## Table of Contents

- [NAME](#name)
  - [Table of Contents](#table-of-contents)
  - [Objective](#objective)
  - [Thought Process and Procedure Flow](#thought-process-and-procedure-flow)
  - [RoadMap](#roadmap)
  - [Runbook](#runbook)
  - [Usage](#usage)
    - [Download](#download)
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

1. Deploy an EKS cluster using Terraform.

2. Create and deploy a Helm chart for the Docker image `docker pull gradyent/tech-interview:latest`, with the following requirements:

- Configure a readiness probe for :8080/ (returns "OK").

- Configure a liveness probe for :8080/hello (returns "world").

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

## Usage

### Download

```sh
git clone https://gitlab.com/b5087/devops/coding-challenge/david-eddy.git
```

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
- [ROADMAP](./ROADMAP.md) example from [all-contributors/all-contributors](https://github.com/all-contributors/all-contributors/blob/master/MAINTAINERS.md).
- Based on [README Maturity Model](https://github.com/LappleApple/feedmereadmes/blob/master/README-maturity-model.md); strive for a Level 5 `Product-oriented README`.
- [CONTRIBUTING.md](./CONTRIBUTING.md) is based on the [Ruby on Rails Contributing](https://github.com/rails/rails/blob/master/CONTRIBUTING.md) document, credit is due to them.
- [LICENSE](./LICENSE.md) sources from:
