# CDK SuperUser 
CDK project to demonstrate using an IAM Permission Boundary to restrict the default created role for the CDK bootstrap Cloudformation execution role.

## Prerequisites
The following need to be installed and available

1. AWS CLI
1. AWS CDK
1. NodeJs

It is assumed that the AWS account in which you're trying this has already been bootstrapped for CDK use.

# Background
To allow CDK to deploy your resources to your account you need to "bootstrap" it. You use the ```cdk bootstrap``` command to perform this one time operation. The [official documentation](https://docs.aws.amazon.com/cdk/v2/guide/bootstrapping.html) describes the options in more detail and you should familiarise yourself with these, particularly if you're going to use one account to deploy resources to other accounts.

The ```cdk bootstrap``` command actually deploys a CloudFormation template into your account and among other things it creates 5 IAM roles to perform the various steps in the CDK lifecycle.  These roles have the following format:<br><br>
```cdk-{qualifier}-{specific-role}-{AWS account ID}-{AWS region}```

The qualifier has a default value of ```hnb659fds``` but you can specify a different one during the bootstrapping. This qualifier allows you to create multiple CDK environments and you use the cdk.json configuration file to specify which one to use.

```
{
  "app": "...",
  "context": {
    "@aws-cdk/core:bootstrapQualifier": "MYQUALIFIER"
  }
}
```
## Sample roles created by the bootstrap command
* cdk-hnb659fds-cfn-exec-role-123456789012-ap-southeast-2
* cdk-hnb659fds-deploy-role-123456789012-ap-southeast-2
* cdk-hnb659fds-file-publishing-role-123456789012-ap-southeast-2
* cdk-hnb659fds-image-publishing-123456789012-ap-southeast-2
* cdk-hnb659fds-lookup-role-123456789012-ap-southeast-2

The ```cfn-exec-role``` is used to execute the generated CloudFormation changeset, and by default, unless overridden during the bootstrapping process is assigned the AWS ```AdminstratorAccess``` managed policy.  This is clearly dangerous as it allows the developer to create resources that he perhaps is prevented from doing so by his role's associated policy.

## What does this demo do?
The ```super-user-stack.ts``` is used to demonstrate how a developer with some resricted access to his AWS account can use the overly privileged default CDK bootstrap execution role to create a new IAM role with administrator privileges which they can then assume to gain additional access to their account.

### Gain Administrator access

1. Authrnticate to your AWS account
1. Deploy the stack with ```cdk deploy```
1. Assume the newly created role ```. ./scritps/swith-role.sh

### Use PermissionBoundary to limit priviliage escalation

# Solution

The use of AWS IAM Users is highly discouraged with the preference to use a federated identity provier to provide AWS access by assuming roles which provide temporary credentials.

IAM permission boundaries are a good way of restricting what a role can do by specifying a set of IAM actions that can be performed irrespective of the policy that's assigned to the role. The permission boundary can prevent the user from being able modify the permission boundary itself, but also to enforce the assigment of the permission boundary to any new IAM resources that the user might create, preventing them from elevating their access.

```cdk bootstrap --custom-permissions-boundary DeveloperBoundaryPolicy```
