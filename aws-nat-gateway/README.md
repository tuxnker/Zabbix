Create an IAM USER with  the following permisions 

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1454324072000",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeNatGateways"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
} 

```

add the user to the /etc/zabbix/.aws/config using 
```
cat /etc/zabbix/.aws/config
[profile zabbix_check_nat]
region = 
aws_access_key_id = 
aws_secret_access_key
```
Create the host with any custom name 

Apply the template to the host and in the dns add the nat-instance-id

