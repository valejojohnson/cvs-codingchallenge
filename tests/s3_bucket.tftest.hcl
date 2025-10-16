# tests/s3_bucket.tftest.hcl
run "s3_bucket_exists_and_is_secure" {
  command = plan

  variables {
    aws_region         = "us-west-1"
    bucket_name        = "tf-test-bucket-1234567"
    versioning_enabled = true
  }

  # 1) Bucket exists and name matches
  assert {
    condition     = aws_s3_bucket.this.bucket == var.bucket_name
    error_message = "S3 bucket name does not match the provided bucket_name."
  }

  # 2) All public access is blocked
  assert {
    condition = alltrue([
      aws_s3_bucket_public_access_block.this.block_public_acls,
      aws_s3_bucket_public_access_block.this.block_public_policy,
      aws_s3_bucket_public_access_block.this.ignore_public_acls,
      aws_s3_bucket_public_access_block.this.restrict_public_buckets,
    ])
    error_message = "S3 bucket must block ALL forms of public access."
  }

  # 3) Encryption at rest is enabled (AES256 or aws:kms)
  #    Iterate over the set-typed blocks instead of indexing.
  assert {
    condition = anytrue([
      for r in aws_s3_bucket_server_side_encryption_configuration.this.rule : anytrue([
        for d in r.apply_server_side_encryption_by_default :
        contains(["AES256", "aws:kms"], try(d.sse_algorithm, ""))
      ])
    ])
    error_message = "S3 bucket must have encryption at rest enabled (AES256 or aws:kms)."
  }

  # 4) Versioning is enabled
  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled"
    error_message = "S3 bucket versioning must be enabled."
  }
}