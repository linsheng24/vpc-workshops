# 設定要清空的 S3 bucket 名稱
BUCKET_NAME="my-workshop-example-s3-bucket"

# 刪除 S3 bucket 中的所有 objects
aws s3 rm s3://$BUCKET_NAME --recursive

terraform destroy -auto-approve