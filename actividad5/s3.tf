resource "random_id" "bucket_sufix" {
  byte_length = 7
}

resource "aws_s3_bucket" "dev1dev2_bucket" {
  bucket = "dev1dev2-bucket-${random_id.bucket_sufix.hex}"
}
output "bucket_name" {
  value = aws_s3_bucket.dev1dev2_bucket.bucket
}