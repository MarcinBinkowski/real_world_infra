resource "aws_kms_key" "my_key" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "my_key" {
  name          = "alias/my-key-alias"
  target_key_id = aws_kms_key.my_key.key_id
}
