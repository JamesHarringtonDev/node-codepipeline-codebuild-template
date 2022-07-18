#!/usr/bin/env bash
 
if aws s3 ls "s3://$PR_BRANCH_NAME" | grep 'AccessDenied' &> /dev/null == 0; then
  echo "$PR_BRANCH_NAME exists but but we do not have access to"
elif aws s3 ls "s3://$PR_BRANCH_NAME" | grep 'NoSuchBucket' &> /dev/null == 1; then
  echo "Emptying contents of bucket: s3://$PR_BRANCH_NAME"
  aws s3 rm s3://$SITE_BUCKET_NAME --recursive
else
  echo "Creating $PR_BRANCH_NAME"
  aws s3 mb s3://$PR_BRANCH_NAME 
fi


# s3://node-codepipeline-codebuild-template-dev-pr-10