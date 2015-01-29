# Fluent::Plugin::Kubernetes

Plugin for fluentd which try to recognize docker containers running under kubernetes and get their pod and containers names.


## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-kubernetes

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-kubernetes


## Usage

Add this section in fluend config

``
<match docker.container.var.lib.docker.containers.*.*.log>
  type kubernetes
  tag docker.container.${container_name}
</match>

``

You can use *container_name*  *k8s_container_name* *k8s_pod_name* placeholders in tag directive.

