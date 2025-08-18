# Process

Typically I separate projects based on the boundary of responsibility. IAC is the hardware, provisioning is install and configuration, execution would be in the service projects. For the purpose of this example project please consider `./iac`, `./helm/*`, and `./srv` would be individual projects in actual practice.

Oh, and typically we would not commit binary files to a Git project without using LFS. But its a couple hour long practical project so I do not see the need, lets just keep it in-tree.

## Make It Work

Ok, with that out of the way lets get our toolchain installed. Copy in `./libs/bash/install.sh` to leverage previous effort towards this project.

Add .gitignore before we commit undesired resources.

Tools installed, basic docs added.

How do we want to handle the public facing ELB?  As part of the cluster resources or a separate boundary?

Since this project is a all-include lets handle it ELB as part of the cluster resources deployment.

## Make It Right

## Make If Fast
