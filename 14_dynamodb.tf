resource "aws_dynamodb_table" "tf_lock" {
  name           = "tf_state"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
resource "aws_s3_bucket" "terraform_state"{
    bucket = "binkowski-marcin-netguru-terraform-state"
    
    versioning {
        enabled = true
    }
}


terraform {
  backend "s3" {
    bucket = "binkowski-marcin-netguru-terraform-state"
    key    = "terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "tf_state"
  }
}