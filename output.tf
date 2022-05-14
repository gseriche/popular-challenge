output "bucket_domain_name" {
  value = aws_s3_bucket.urlscan_bucket.bucket_domain_name
}

output "instance_ip_address" {
  value = aws_instance.ec2_pivote.public_ip
}