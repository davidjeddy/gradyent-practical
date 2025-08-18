# Process

Typically I separate projects based on the boundary of responsibility. IAC is the hardware, provisioning is install and configuration, execution would be in the service projects. For the purpose of this example project please consider `./iac`, `./helm/*`, and `./srv` would be individual projects in actual practice.

Oh, and typically we would not commit binary files to a Git project without using LFS. But its a couple hour long practical project so I do not see the need, lets just keep it in-tree.

## Make It Work

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

Now deploy the network and IAM resources.

Bring the VPC modules up to the most recent published version.

## Make It Right

## Make If Fast
