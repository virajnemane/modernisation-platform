## This file is automatically generated to create a single-region KMS key in eu-west-2.

data "aws_caller_identity" "kms_current" {}
data "aws_partition" "kms_current" {}

data "aws_iam_policy_document" "kms" {
  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.kms_current.partition}:iam::${data.aws_caller_identity.kms_current.account_id}:root"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:${data.aws_partition.kms_current.partition}:cloudtrail:*:${data.aws_caller_identity.kms_current.account_id}:trail/*"]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["logs.eu-west-2.amazonaws.com"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Describe*"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "kms_roles" {
  statement {
    actions   = ["kms:Decrypt"]
    effect    = "Allow"
    resources = ["*"]
    sid       = "AllowRolesToAccess"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.kms_current.account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "kms_merged" {
  source_json   = data.aws_iam_policy_document.kms.json
  override_json = data.aws_iam_policy_document.kms_roles.json
}

resource "aws_kms_key" "cloudtrail" {
  provider                = aws.aws-eu-west-2
  deletion_window_in_days = 7
  description             = "CloudTrail encryption key"
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_merged.json
  tags                    = var.baseline_tags
}

resource "aws_kms_alias" "cloudtrail" {
  provider      = aws.aws-eu-west-2
  name          = "alias/cloudtrail_key"
  target_key_id = aws_kms_key.cloudtrail.id
}
