#!/usr/bin/env bash
 
# if aws s3 ls "s3://$PR_BRANCH_NAME" | grep 'AccessDenied' &> /dev/null == 0; then
#   echo "$PR_BRANCH_NAME exists but but we do not have access to"
# elif aws s3 ls "s3://$PR_BRANCH_NAME" | grep 'NoSuchBucket' &> /dev/null == 1; then
#   echo "Emptying contents of bucket: s3://$PR_BRANCH_NAME"
#   aws s3 rm s3://$SITE_BUCKET_NAME --recursive
# else
#   echo "Creating $PR_BRANCH_NAME"
#   aws s3 mb s3://$PR_BRANCH_NAME 
# fi

bucketstatus=$(aws s3api head-bucket --bucket "$PR_BRANCH_NAME" 2>&1)
if echo "${bucketstatus}" | grep 'Not Found';
then
  echo "Creating $PR_BRANCH_NAME"
  echo "aws s3 create-bucket --bucket $PR_BRANCH_NAME --region $AWS_REGION"
  aws s3 mb s3://$PR_BRANCH_NAME
  aws s3 website s3://$PR_BRANCH_NAME  --index-document index.html-document --error index.html

elif echo "${bucketstatus}" | grep 'Forbidden';
then
  echo "$PR_BRANCH_NAME exists but but we do not have access to"
elif echo "${bucketstatus}" | grep 'Bad Request';
then
  echo "Bucket name specified is less than 3 or greater than 63 characters"
else
  echo "Emptying contents of bucket: s3://$PR_BRANCH_NAME"
  aws s3 rm s3://$PR_BRANCH_NAME --recursive
fi