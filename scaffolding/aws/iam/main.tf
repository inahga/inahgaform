resource "aws_key_pair" "key_pairs" {
  for_each   = var.ssh_keys
  key_name   = each.key
  public_key = each.value
}

resource "aws_iam_policy" "certman" {
  name = "certman"
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

resource "aws_iam_user" "certman" {
  name = "certman"
}

resource "aws_iam_user_policy_attachment" "certman_attachment" {
  user       = aws_iam_user.certman.name
  policy_arn = aws_iam_policy.certman.arn
}
