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
  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_acl" "urlscan_bucket" {
    bucket = aws_s3_bucket.urlscan_bucket.id 
    acl = "public-read"
    
}

resource "aws_s3_bucket_policy" "allow_access_for_report" {
    bucket = aws_s3_bucket.urlscan_bucket.id
    policy = data.aws_iam_policy_document.allow_access_from_internet.json

}

data "aws_iam_policy_document" "allow_access_from_internet" {
    statement {
        sid = "PublicReadGetObject"
        principals  {
          type = "*"
          identifiers = ["*"]
        }
        actions = [
          "s3:GetObject",
        ]
        resources = [
            aws_s3_bucket.urlscan_bucket.arn,
            "${aws_s3_bucket.urlscan_bucket.arn}/*",
        ]
        effect = "Allow"
    }
}