#!/bin/bash
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Switches to the specified AWS IAM Role"
   echo
   echo "Syntax: switch-role.sh [-h|a|r]"
   echo "options:"
   echo "h     Print this Help."
   echo "a     AWS Account ID"
   echo "r     Role name"
   echo
   echo "Example . ./switch-role.sh -a 123456789012 -r myrole/with/path"
   echo
}

# Get the options
while getopts ":ha:r:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      a)
         AWS_ACCOUNT_ID=$OPTARG;;
      r)
         ROLE=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

if [ $# -ne 4 ]
then
    Help
else
    for keyval in $(printf "AWS_ACCESS_KEY_ID:%s AWS_SECRET_ACCESS_KEY:%s AWS_SESSION_TOKEN:%s" \
        $(aws sts assume-role \
            --role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/${ROLE} \
            --role-session-name MySessionName \
            --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
        --output text))
    do
        key=`echo $keyval | cut -d: -f1 | tr '[:upper:]' '[:lower:]'`
        val=`echo $keyval | cut -d: -f2`

        aws configure set ${key} ${val} --profile assumed-role
    done

    aws configure set region ap-southeast-2 --profile assumed-role

    export AWS_PROFILE=assumed-role
    echo "Role assumption has completed successfully"

    aws sts get-caller-identity
fi
