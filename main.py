#!/usr/bin/env python
from constructs import Construct
from cdktf import App, NamedRemoteWorkspace, TerraformStack, TerraformOutput, RemoteBackend
from cdktf_cdktf_provider_aws import AwsProvider, ec2


class MyStack(TerraformStack):
    def __init__(self, scope: Construct, ns: str):
        super().__init__(scope, ns)

        AwsProvider(self, "AWS", region="ap-northeast-2")

        instance = ec2.Instance(self, "compute",
                                ami="ami-058165de3b7202099",
                                instance_type="t2.micro",
                                tags= { "Name" : "CDKTF-DEMO" },
                                )

        TerraformOutput(self, "public_ip",
                        value=instance.public_ip,
                        )


app = App()
stack = MyStack(app, "aws_instance")

RemoteBackend(stack,
              hostname='app.terraform.io',
              organization='codns',
              workspaces=NamedRemoteWorkspace('cdktf_python')
              )

app.synth()
