resource "aws_cloudformation_stack" "appstream_elasticfleet" {
  name = "Appstream-ElasticFleet-Test"
  template_body = <<STACK

  "Resources" : {
     "ASF21QI6": {
    "Type": "AWS::AppStream::Fleet",
    "Properties": {
        "Description": "Appstream-Elastic-Fleet-Terraform",
        "DisconnectTimeoutInSeconds": 60,
        "DisplayName": "Appstream-Elastic-Fleet-Terraform",
        "EnableDefaultInternetAccess": false,
        "FleetType": "ELASTIC",
        "IamRoleArn": "${aws_iam_role.role.arn}",
        "IdleDisconnectTimeoutInSeconds": 1200,
        "InstanceType": "stream.standard.small",
        "MaxConcurrentSessions": 5,
        "MaxUserDurationInSeconds": 4800,
        "Name": "Appstream-Elastic-Fleet-Terraform",
        "Platform": "WINDOWS_SERVER_2019",
        "StreamView": "APP",
        "VpcConfig": {
            "SecurityGroupIds": [
                "${aws_security_group.rdhosts.id}"
            ],
            "SubnetIds": [
                "${aws_subnet.private["af-south-1a"].id}",
                "${aws_subnet.private["af-south-1b"].id}"
            ]
        }
    }
  }
}
STACK
}
