
## Table of contents
1. [Introduction](#introduction)
2. [Goal: define project-wide variables when deploying infrastructure](#goal)
3. [Types of variable in Terraform](#Variable)
4. [A lack of global variables in Terraform](#Project-wide)
5. [A variables folder](#A-variables-folder)
6. [Case study: AWS CloudFront distribution to serve a static website](#Case-study)
7. [Website storage](#website)
8. [Cloudfront distribution](#Cloudfront)
9. [Conclusion: project-wide variables are useful for sharing data among projects](#conclusion)

## Introduction <a name="introduction"></a>
When deploying infrastructure, Terraform uses different types of variables, inputs, outputs, and locals, to define or describe infrastructure characteristics. In significant infrastructural developments, with numerous pieces of infrastructure, the same information is sometimes needed for different infrastructural parts. For example, a domain name is needed to create a hosted zone, obtain an SSL/TLS certificate, and to deploy a CloudFront distribution. Project-wide variables, also known as global variables in general programming would help us solve this need. Unfortunately, Terraform does not have global variables _per se_, and only inputs and local variables can be used to define infrastructural features. Still, when using Terraform there are smarter and more efficient ways to work that can help us bypass the lack of global variables.

Here I will show how to use Terraform's backend to create a centralized folder containing all project-wide variables that can be used in any piece of infrastructure deployed underneath the project's umbrella. This work practice can lead to minimizing the number of meaningful variables employed in a Terraform project.

## Goal: use multiple profiles when deploying infrastructure <a name="goal"></a>
<div class="alert alert-block alert-info">
Here I describe a technique to create project-wide variables when deploying infrastructure with Terraform.
</div>

## Types of variable in Terraform <a name="Variable"></a>
Terraform's documentation does an excellent work describing the different types of variables used to create infrastructure. Here I will just give a small summary while introducing Global variables, a foreign idea in Terraform.

On one hand, input variables are declared using the `variable` block. Variable declaration has numerous optional arguments, such as variable type (string, number, bool), a default tag (sets the default variable value), a description tag (an explanation of the variable's purpose), a sensitive tag (if true, Terraform hides its value from plan or apply output), ephemeral tag (if true the variable is available during runtime but omitted from state and plan files), a nullable tag (if true the variable cannot be set to null), among others. On the other hand, output values, are very different from input variables, informing about the infrastructure available on the command line. Locals are indeed different than input variables, assign a name to an expression or a value, and are used to avoid the repeated use of expressions or values.


## A lack of global variables in Terraform <a name="Project-wide"></a>
In Terraform each folder normally contains a piece of infrastructure. As such each folder should have its input, output, and locals. In programming, a global variable is a variable declared outside of any function, making it accessible from anywhere within the program. However, Terraform used a domain-specific configuration language called HashiCorp Configuration Language to define the infrastructure, and the concept of a global variable, available for every module, is not defined.

## A variables folder <a name="A-variables-folder"></a>
A way to bypass the lack of global variables in Terraform is to first use a centralized variable folder with an exported state and to then import that state anytime variables are needed in the project. I will describe next how to do this. 
I previously described how to set up Terraform's state.
I will first enter the `global/variables` folder, where all Global variables are defined. There are many ways to define variables: as a variables file, as a JSON file, etc. I choose to define each variable (e.g. domain-var) as a single file (e.g. domain-var.tf) for simplicity, so that by listing the files in the folder you can see what variables are defined. Let us take a look at one of the variable files:

<h5 a><strong><code>vi global/variables/domain-var.tf</code></strong></h5>

```
variable "domain" {
# domain name
# This should be your own domain hosted in AWS (e.g. mydomain.com)
  default = "mydomain.com"
}
```

Every input variable here needs to be accompanied by an output variable that prints the value of the variable.

<h5 a><strong><code>vi global/variables/output.tf</code></strong></h5>

```
output "domain" {
  description = ""
  value       = var.domain
}
```


By simply executing the start.sh file you can define all input variables in the folder and populate all outputs.

<h5 a><strong><code>cd global/variables</code></strong></h5>

```
bash start.sh
```

## Case study: AWS CloudFront distribution to serve a static website <a name="Case-study"></a>
Here I will explain how to use Terraform's backend in order to create a centralized folder containing all project-wide variables by using a simple example, where I develop a plain website statically in AWS and serve it using a CloudFront distribution. In order to do this, first I need to create a hosted zone and obtain an SSL/TLS certificate. I will enter the `vpcs` folder and create a hosted zone to then obtain an SSL/TLS certificate:

<h5 a><strong><code>cd vpcs</code></strong></h5>

```
cd zone; bash start.sh
cd ../certs ; bash start.sh
```

## Website storage <a name="website"></a>
Now we are ready to start the storage service that will host the website. 

<h5 a><strong><code>cd storage/storage-www</code></strong></h5>

```
bash start.sh
```

At this point, we can address how global variables work. To statically host a website, we need to create a bucket with the domain name. Let us take a look at the `bucket.tf` file

<h5 a><strong><code>vi storage/storage-www/bucket.tf</code></strong></h5>

```
resource "aws_s3_bucket" "domain" {
  provider      =  aws.Infrastructure
  bucket        = "${local.aws_s3_bucket_bucket_name}.${data.terraform_remote_state.variables.outputs.domain}"
  force_destroy = local.aws_s3_bucket_force_destroy

  # this local provisioner ensured all files from the folder are copied recursively
  provisioner "local-exec" {
        command = "aws s3 cp ../../files/website s3://${aws_s3_bucket.domain.id} --recursive --profile 'Infrastructure' "
  }
}
```

In this file, the domain is specified by `${data.terraform_remote_state.variables.outputs.domain}`. To use this variable we first need to export the variables folder state:
<h5 a><strong><code>vi storage/storage-www/exportbackend.tf</code></strong></h5>

```
data "terraform_remote_state" "variables" {
   backend = "s3"
   config = {
       key = "global/variables/variables.tfstate"
        region = "us-east-1"
        profile  = "Infrastructure"
        bucket  = "tfstate03312025"
   }
}
```


## Cloudfront distribution <a name="Cloudfront"></a>
Now I will deploy Cloudfront's distribution. CloudFront is an AWS service used to distribute content with the help of a network of servers around the world. Terraform's Cloudfront resource is shown below.

<h5 a><strong><code>vi services/cloudfront-www/cloudfront.tf</code></strong></h5>

```
resource "aws_cloudfront_distribution" "domain" {
  origin {
    domain_name = "${data.terraform_remote_state.storage.outputs.aws-s3-bucket-website-configuration-my-config-website-endpoint}" 
    origin_id   ="${data.terraform_remote_state.storage.outputs.aws-s3-bucket-domain-bucket-regional-domain-name}"


   custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
}

  provider                     =  aws.Infrastructure
  aliases = ["www.${data.terraform_remote_state.variables.outputs.domain}"]

  enabled = true
    default_root_object = "index.html"

  default_cache_behavior {
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${data.terraform_remote_state.storage.outputs.aws-s3-bucket-domain-bucket-regional-domain-name}"

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 300 

  }



  viewer_certificate {
    acm_certificate_arn = "${data.terraform_remote_state.certs.outputs.aws-acm-certificate-domain-arn}" 
    ssl_support_method = "sni-only"
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}
```

There are numerous options to configure the service and I will refer to AWS's documentation for that. 
Again, I exported the `global/variables` backend using the `exportbackend.tf` file as the `${data.terraform_remote_state.variables.outputs.domain}` variable is used here. At the same time, the distribution requires an SSL certificate to serve https connections.
My approach was to redirect the distribution to the S3 bucket endpoint that serves the website using an Alias record deployed in Route53:

<h5 a><strong><code>vi services/cloudfront-www/route53_record.tf</code></strong></h5>

```
resource "aws_route53_record" "www" {
  provider                     =  aws.Domain
  zone_id = "${data.terraform_remote_state.zones.outputs.zone_id}"
  name    = "www"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.domain.domain_name
    zone_id                = aws_cloudfront_distribution.domain.hosted_zone_id
    evaluate_target_health = false
  }

}
```

The distribution can be simply deployed using the `start.sh` bash script.

<h5 a><strong><code>cd services/cloudfront-www</code></strong></h5>

```
bash start.sh
```

The distribution's URL will be displayed after deploying the distribution and will look like the below with a different ID:

```
https://d54xdzk7wxeez.cloudfront.net
```

## Conclusion: project-wide variables are useful for sharing data among projects <a name="conclusion"></a>
<div class="alert alert-block alert-info">
Here I describe how to use project-wide variables by means of importing and exporting the state of a single `global/variables` folder when deploying infrastructure with Terraform.
</div>

