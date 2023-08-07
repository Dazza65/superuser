#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { SuperUserStack } from '../lib/super-user-stack';

const app = new cdk.App();
new SuperUserStack(app, 'SuperUserStack', {
});