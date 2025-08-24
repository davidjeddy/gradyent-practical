# DELIVERABLES CHECKLIST

## Must Haves

- Deploy an EKS cluster using Terraform - DONE

- Create and deploy a Helm chart for the Docker image `docker pull gradyent/tech-interview:latest`, with the following requirements - DONE

- Configure a readiness probe for :8080/ (returns "OK") - DONE

- Configure a liveness probe for :8080/hello (returns "world") - DONE

## Should Haves

- Scalability

EKS Auto Mode manages the workload nodes compute, storage, and networking. For simple scaling activities  HPA (Horizontal Pod Autoscaling) resource can be deployed into the cluster. This would require the deployment of a metrics service. A good best-practice is to deploy pods across all available zones per region. - DONE

- Monitoring

Many solutions exist to address monitoring as knowing how the cluster is operating is paramount to successfully operating a cluster. The very basic is the Kubernetes Dashboard. If the monitoring solution should be hosted in the cluster the Prometheus Operator is a good option. If the desire is to keep the monitoring outside the cluster AWS CloudWatch Metrics and Logs can also be leveraged very easily. - DONE

- Cost

Costing is always a concern when operating applications. In non-prod deployments effort should be made to scale down resources during times they are not used. Using a Kubernetes cluster as the runtime schedules can be created to scale services down during non-business hours. Additionally budget alerts should be created to triggered if breached. Finally, as part of any applications lifecycle regular reviews should be completed to validate expenses.

- Ease of use

Process is detailed in the README.md - DONE

## Nice to Haves

- CI/CD pipeline

Leverage an existing CI/CD system such as GitLab, Jenkins, GitHub Actions to execute the source->build->test->approve->tag->publish->deploy process. GitLab has many stages of the process built in; GitHub actions exist for near all languages, and Jenkins libraries are numerous. LEts not re-invent the wheel. Leverage existing solutions as much as possible. - DONE

- Ingress configuration

For this solution I went with the deployment of an ALB via Kubernetes resources as part of the web-app services.

- An architecture diagram

Using im2nguyen/rover to automatically generate IAC diagrams. - DONE

- Security considerations

Principle of Least privilege, only load balancers, CDNs, and API gateways should be in public subnets, CloudTrail to watch for abnormal interactions with the AWS account. Additionally Kubernetes cluster RBAC permissions should also be audited regularly.

- Impress us

  - (optional, both in IAC and Helm deployments) Pretty DNS with TLS - DONE
  - Kubernetes Dashboard - DONE
  - 2048 web game as a second service - NEH

Solution in a Git repository - DONE

Include a README file - DONE
