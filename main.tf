provider "aws" {
    region = "eu-east-2"
}

variable "elastic-app" {
    default = "myapp"
}
variable "beanstalkapp-env" {
    default = "myenv"
}
variable "stack-name" {
    type = string
}
variable "tier" {
    type = string
}
variable "vpc_id" {}
variable "public_subnets" {}
variable "elb_public_subnets" {}

resource "aws_elastic_beanstalk_application" "elastic-app" {
  name = var.elastic-app 
}

resource "aws_elastic_beanstalk_environment" "beanstalkapp-env" {
  name = var.beanstalkapp-env
  application = aws_elastic_beanstalk_application.elastic-app.name
  solution_stack_name = var.stack-name
  tier = var.tier

  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = var.vpc_id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "True"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = join(",", var.public_subnets)
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name = "MatcherHTTPCode"
    value = "200"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "application"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "t2.medium"
  }
  setting {
      namespace = "aws:ec2:vpc"
      name = "ELBScheme"
      value = "internet facing"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name = "MiniSize"
    value = 1
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = 2
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name = "SystemType"
    value = "enhanced"
  }
}