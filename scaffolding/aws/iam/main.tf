resource "aws_key_pair" "key_pairs" {
  for_each   = var.ssh_keys
  key_name   = each.key
  public_key = each.value
}

resource "aws_iam_user" "certuser" {
  name = "certuser"
}

resource "aws_iam_policy" "certuser" {
  name = "certuser"
  path = "/"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "arn:aws:route53:::hostedzone/*"
    },
    {
      "Effect": "Allow",
      "Action": "route53:ListHostedZonesByName",
      "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_iam_policy" "certrole" {
  name = "certrole"
  path = "/"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Id": "certrole-dns-route53",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:GetChange"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource" : [
        "arn:aws:route53:::hostedzone/*"
      ]
    }
  ]
}
EOT
}

resource "aws_iam_user_policy_attachment" "certuser_attachment" {
  user       = aws_iam_user.certuser.name
  policy_arn = aws_iam_policy.certuser.arn
}

resource "aws_iam_role" "certrole" {
  name               = "certrole"
  assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOT
}

resource "aws_iam_role_policy_attachment" "certrole_attachment" {
  role       = aws_iam_role.certrole.name
  policy_arn = aws_iam_policy.certrole.arn
}
