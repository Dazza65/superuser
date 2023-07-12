for keyval in $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
    $(aws sts assume-role \
        --role-arn arn:aws:iam::887312641336:role/applicationroles/TestLambdaRole \
        --role-session-name MySessionName \
        --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
    --output text))
do
    key=`echo $keyval | cut -d= -f1`
    val=`echo $keyval | cut -d= -f2 | tr '[:upper:]' '[:lower:]'`

    aws configure set `echo ${key} ` ${val} --profile assumed-role
done

aws configure set region ap-southeast-2 --profile assumed-role

export AWS_PROFILE=assumed-role
echo "Role assumption has completed successfully"

aws sts get-caller-identity
