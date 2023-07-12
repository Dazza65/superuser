import * as cdk from 'aws-cdk-lib';
import { AccountRootPrincipal, ManagedPolicy, Role } from 'aws-cdk-lib/aws-iam';
import { Construct } from 'constructs';
// import * as sqs from 'aws-cdk-lib/aws-sqs';

export class SuperUserStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    new Role(this, 'SuperUserRole', {
      roleName: 'SuperUserRole',
      assumedBy: new AccountRootPrincipal(),
      managedPolicies: [
        ManagedPolicy.fromManagedPolicyArn(this, 'AdminPolicy', 'arn:aws:iam::aws:policy/AdministratorAccess')
      ]
    })
  }
}
