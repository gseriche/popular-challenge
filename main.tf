# lets create a bucket
resource "aws_s3_bucket" "urlscan_bucket" {
  bucket = "lapopular-url-scan"
  tags = {
    Name        = "My UrlScan bucket"
    Environment = "test"
  }
}

resource "aws_s3_bucket_public_access_block" "urlscan_bucket" {
  bucket = aws_s3_bucket.urlscan_bucket.id
  block_public_acls   = true
  block_public_policy = true
}