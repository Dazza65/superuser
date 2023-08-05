import * as cdk from 'aws-cdk-lib';
import { AccountRootPrincipal, ManagedPolicy, Policy, Role } from 'aws-cdk-lib/aws-iam';
import { Construct } from 'constructs';

export class SuperUserStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const permissionsBoundary = ManagedPolicy.fromManagedPolicyArn(this, 'devBoundaryPolicy', 'arn:aws:iam::887312641336:policy/DeveloperBoundaryPolicy');

    console.log(`BP: ${permissionsBoundary}`);
    
    new Role(this, 'SuperUserRole', {
      roleName: 'SuperUserRole',
      assumedBy: new AccountRootPrincipal(),
      path: '/applicationroles/superuser/',
      permissionsBoundary,
      managedPolicies: [
        ManagedPolicy.fromManagedPolicyArn(this, 'AdminPolicy', 'arn:aws:iam::aws:policy/AdministratorAccess')
      ]
    })
  }
}
