![Nodezoo][Logo]

# nodezoo-terraform

- __Lead:__ [Mircea Alexandru][Lead]
- __Sponsor:__ [nearForm][]


Terraform deploy project.

Terraform configuration to create all required resources for running this project with distinct instances for each microservice on AWS.

If you're using this project, and need help, you can:

- Post a [github issue][],
- Tweet to [@nodezoo][],
- Ask on the [Gitter][gitter-url].

This project is part of the [NodeZoo org][] system. Please follow the
link below for details on obtaining and running the complete system.

- [Nodezoo: The complete system][System]


# Prerequisites

## Install Terraform

To install Terraform please check documentation [site](https://www.terraform.io/intro/getting-started/install.html).

## Create AWS account and generate access keys

To run this project you need to set-up and [AWS account](http://console.aws.amazon.com) and generate then security access keys from [IAM](https://console.aws.amazon.com/iam/home).

Please follow documentation on site for more details.

## Set the access keys into project.

To use the access key into project you can:
 * enter their values each time you run a Terraform command and when you are prompted or
 * create a ```terraform.tfvars``` with following content:

```
access_key = "....your access key....."
secret_key = "....your secret key....."
```
 
Be careful not to share these keys by committing the file.
 
## Generate ssh access keys

In order to run command remotly and generate/install packages on remote instances you need to generate ssh keys. You can do that by running:

```
$ ssh-keygen -t rsa -C "nodezoo" -P '' -f ssh/nodezoo
```

In the ```keypairs.tf``` file this key is set, so it can be used into the Terraform project. If you place your key in another folder or use another name please update the ```keypairs.tf``` accordingly.

# The project

The project contains various files and their role is explained bellow:

The structure of the file is:

```
|-- ssh                    # folder where ssh keys are placed
|-- 1.security.tf          # configuration for security resources including key pairs, security groups, a.s.o
|-- 2.network.tf           # configuration for network resources (load balancer)
|-- 3.servers-infrastructure.tf
                           # configuration for infrastructure servers (redis, elasticsearch and mesh base)
|-- 4.servers-app.tf       # configuration for instances with microservices running.
|-- keypairs.tf            # definition for keypairs used for SSH access on remote instances
|-- outputs.tf             # configuration for outputs variables to be displayed after a ```terraform apply``` command is successfully executed.
|-- variables.tf           # variables used by Terraform project. Here you can change the zone of deployment and also the instance types to be created by this project.
```


# Working with Terraform

### Verify the plan
To verify the plan to be created by this project, after completing the above steps you can run 
```
terraform plan
```

This command will verify/validate the configuration files and will present a plan to be created on AWS.

### Create the plan

To create the plan simply run

```
terraform apply
```

This should create all resources and all should be working properly.

### Destroy the plan

To destroy the resources you should run 

```
terraform destroy
```

and respond yes when prompted.

This will destroy all resources create by this plan.


## Contributing
The [NodeZoo org][] encourages __open__ and __safe__ participation.

- __[Code of Conduct][CoC]__

If you feel you can help in any way, be it with documentation, examples, extra testing, or new
features please get in touch.

## License
Copyright (c) 2016, Mircea Alexandru and other contributors.
Licensed under [MIT][].


[MIT]: ./LICENSE
[CoC]: ./CoC.md
[Lead]: https://github.com/mirceaalexandru
[nearForm]: http://www.nearform.com/
[NodeZoo]: http://www.nodezoo.com/
[NodeZoo org]: https://github.com/nodezoo
[Logo]: https://raw.githubusercontent.com/nodezoo/nodezoo-org/master/assets/logo-nodezoo.png
[github issue]: https://github.com/nodezoo/nodezoo-terraform/issues
[@nodezoo]: http://twitter.com/nodezoo
[gitter-url]: https://gitter.im/nodezoo/nodezoo-org
[System]: https://github.com/nodezoo/nodezoo-system