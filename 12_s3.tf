resource "aws_s3_bucket" "www" {
  bucket = "binkowski-marcin-netguru-devops-collage"
  acl    = "public-read"
  website {
    index_document = "index.html"
}
}

