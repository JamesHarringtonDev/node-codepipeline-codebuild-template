bucketResponse=$(aws s3 ls "s3://$PR_BRANCH_NAME") 
     
if [ ($bucketResponse | grep 'AccessDenied' &> /dev/null) == 0 ] 
then
  echo "$PR_BRANCH_NAME exists but but we do not have access to"
  exit
elif [ ($bucketResponse | grep 'NoSuchBucket' &> /dev/null) == 0 ]
  echo "Emptying contents of bucket: s3://$PR_BRANCH_NAME"
  aws s3 rm s3://$SITE_BUCKET_NAME --recursive
else
  echo "Creating $PR_BRANCH_NAME"
  aws s3 mb s3://$PR_BRANCH_NAME 
fi



if [ $bucketResponse | grep 'NoSuchBucket' &> /dev/null) == 0 ] 
then
    echo "$PR_BRANCH_NAME doesn\'t exist please check again"
    exit

fi