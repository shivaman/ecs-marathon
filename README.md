# Amazon ECS Scheduler Driver
The Amazon EC2 Container Service (Amazon ECS) Scheduler Driver is an initial proof of concept of how we could start integrating Apache Mesos with ECS. This proof of concept demonstrates how Mesos schedulers (frameworks) could schedule workloads on ECS. It demonstrates the potential for Amazon ECS to integrate with the Mesos ecosystem, which would allow you to use Mesos schedulers like Marathon and Chronos to launch tasks on Amazon ECS. 

This is based on https://github.com/awslabs/ecs-mesos-scheduler-driver

# Example for Marathon

Marathon is a cluster-wide init and control system for services which supports Docker containers. It uses `MesosSchedulerDriver` from JVM, that our `ECSSchedulerDriver` can interrupt to use Amazon ECS without any modification of code.

In this example, we will start Marathon and ZK containers, and use Marathon to start tasks on an existing ECS cluster. 

## Run Marathon and ZooKeeper locally
Before this section, you should install Docker Engine and Docker Compose on your local machine (desktop, laptop, dev machine, etc.).

If you are using Docker for Mac, I could not get it to use my credentials in ~/.aws. So I ended up using an EC2 instance (public IP with port 8080 open for the Marathon UI), with docker and docker-compose installed.

Clone this repo and, open `docker-compose.yml` in ecs-marathon/example/ directory and modify the lines below :

    - ECS_REGION=
    - ECS_CLUSTER=

These are the parameters for ECSSchedulerDriver.

After that, you can build and up Marathon container with ECSSchedulerDriver along with a ZooKeeper container with the below commands:

    docker-compose build
    docker-compose up

By default, it uses your default AWS profile stored at `~/.aws` or EC2 instance profile if you run docker on an EC2 instance. This credential should have privileges to access Amazon ECS API.

# Start application through Marathon API
Then, just call Marathon API to create Docker application as you did before:

    curl -i -H "Content-Type: application/json" -d '
    {
      "id": "nginx",
      "cpus": 0.1,
      "mem": 100.0,
      "instances": 1,
      "container": {
        "type": "DOCKER",
        "docker": {
          "image": "nginx:latest",
          "network": "BRIDGE",
          "portMappings": [
            {
              "containerPort":80,
              "hostPort":80
            }
          ]
        }
      }
    }
    ' http://52.2.176.129:8080/v2/apps

Note: If you use Docker Machine (like VirtualBox on Mac), you should specify VirtualBox IP address instead of `localhost` or you can port forward via ssh and you can use `localhost` as well:

    docker-machine ssh YOUR_MACHINE -N -L 8080:localhost:8080

This request automatically creates a Task Definition containing a single container with `nignx:latest` and starts a Task on your ECS cluster.

Alternatively, you can start application through Marathon UI.
