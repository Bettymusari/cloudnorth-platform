# S3 Bucket for static assets
resource "aws_s3_bucket" "static_assets" {
  bucket = var.bucket_name

  tags = {
    Name = "cloudnorth-static-assets"
  }
}

# Remove the ACL resource - it's not needed and causes errors
# resource "aws_s3_bucket_acl" "static_assets_acl" {
#   bucket = aws_s3_bucket.static_assets.id
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "static_assets_versioning" {
  bucket = aws_s3_bucket.static_assets.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access - this is the modern way to secure buckets
resource "aws_s3_bucket_public_access_block" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Add bucket ownership controls to ensure private by default
resource "aws_s3_bucket_ownership_controls" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  rule {
    object_ownership = "BucketOwnerEnforced"  # This makes ACLs unnecessary
  }
}
