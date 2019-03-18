provider "aws" {
  region     = "us-east-1"
  alias      = "us-east-1"
}

resource "aws_s3_bucket" "bucket-nanoservices-raw-images" {
  bucket = "nanoservices-raw-images"
  acl    = "private"

  tags = {
    Name        = "nanoservices-raw-images"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "bucket-nanoservices-thumbnail-images" {
  bucket = "nanoservices-thumbnail-images"
  acl    = "private"

  tags = {
    Name        = "nanoservices-thumbnail-images"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "bucket-nanoservices-blackwhite-images" {
  bucket = "nanoservices-blackwhite-images"
  acl    = "private"

  tags = {
    Name        = "nanoservices-blackwhite-images"
    Environment = "Dev"
  }
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "nanoservices-images"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id" 

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-images"
    Environment = "Dev"
  }
}

resource "aws_sns_topic" "basic-sns-topic" {
  name = "s3-raw-images-put-topic"
  policy = "{\"Version\":\"2008-10-17\",\"Id\":\"__default_policy_ID\",\"Statement\":[{\"Sid\":\"__default_statement_ID\",\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"*\"},\"Action\":[\"SNS:GetTopicAttributes\",\"SNS:SetTopicAttributes\",\"SNS:AddPermission\",\"SNS:RemovePermission\",\"SNS:DeleteTopic\",\"SNS:Subscribe\",\"SNS:ListSubscriptionsByTopic\",\"SNS:Publish\",\"SNS:Receive\"],\"Resource\":\"arn:aws:sns:us-east-1:[ACCOUNT_NUMBER]:s3-raw-images-put-topic\",\"Condition\":{\"ArnLike\":{\"AWS:SourceArn\":\"${aws_s3_bucket.bucket-nanoservices-raw-images.arn}\"}}}]}"
}

resource "aws_s3_bucket_notification" "bucket-nanoservices-raw-images-notification" {
  bucket = "${aws_s3_bucket.bucket-nanoservices-raw-images.id}"

  topic {
    id = "put-object-notification"
    topic_arn     = "${aws_sns_topic.basic-sns-topic.arn}"
    events        = ["s3:ObjectCreated:Put"]
  }
}

resource "aws_sqs_queue" "nanoservices-image-queue" {
  name                      = "nanoservices-image-queue"
  delay_seconds             = 30
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Environment = "Dev"
  }
}

resource "aws_vpc" "nanoservices-vpc" {
  cidr_block = "10.0.0.0/16"
}