set -e
accountId=`aws sts get-caller-identity --query "Account" --output text`

echo "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
        {
            \"Effect\": \"Allow\",
            \"Principal\": {
              \"AWS\": \"arn:aws:iam::${accountId}:root\"
            },
            \"Action\": \"sts:AssumeRole\"
          }
    ]
}" > trust-policy.json