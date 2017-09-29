set -e

echo '###Expense Tracker database creation###'
echo ''

echo 'Loading VPC ID:'
VpcID=$(aws ec2 describe-vpcs --query Vpcs[0].VpcId --output text)
echo $VpcID
echo 'Loading Subnet ID:'
SubnetID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VpcID --query Subnets[0].SubnetId --output text)
echo $SubnetID
echo 'Loading DB subnet group:'
DBSubnetGroup=$(../strip_quotes.sh $(aws cloudformation describe-stacks --stack-name ET-Network --query 'Stacks[0].Outputs[?OutputKey==`DatabaseSubnetGroup`].OutputValue' --output text))
echo $DBSubnetGroup
echo 'Loading DB security group:'
DBSecurityGroup=$(../strip_quotes.sh $(aws cloudformation describe-stacks --stack-name ET-Network --query 'Stacks[0].Outputs[?OutputKey==`DatabaseSecurityGroup`].OutputValue' --output text))
echo $DBSecurityGroup
echo 'Loading Application security group:'
ApplicationSecurityGroup=$(../strip_quotes.sh $(aws cloudformation describe-stacks --stack-name ET-Network --query 'Stacks[0].Outputs[?OutputKey==`ApplicationSecurityGroup`].OutputValue' --output text))
echo $ApplicationSecurityGroup
KeyName=ET
echo "AWS Key name: $KeyName"

DBUser='temp'
DBPassword='temptemptemp'

aws cloudformation create-stack --stack-name ET-Database \
--capabilities CAPABILITY_IAM \
--template-body file://database.json \
--parameters ParameterKey=VPC,ParameterValue=$VpcID \
ParameterKey=Subnet,ParameterValue=$SubnetID \
ParameterKey=DatabaseSubnetGroup,ParameterValue=$DBSubnetGroup \
ParameterKey=DatabaseSecurityGroup,ParameterValue=$DBSecurityGroup \
ParameterKey=ApplicationSecurityGroup,ParameterValue=$ApplicationSecurityGroup \
ParameterKey=InstanceType,ParameterValue=t2.micro \
ParameterKey=DBUser,ParameterValue=$DBUser \
ParameterKey=DBPassword,ParameterValue=$DBPassword \
ParameterKey=KeyName,ParameterValue=$KeyName

echo 'Stack creation in progress'
aws cloudformation wait stack-create-complete --stack-name ET-Database
echo 'Database Stack is created'

echo 'Loading DB deploy S3:'
DBDeployBucket=$(../strip_quotes.sh $(aws cloudformation describe-stacks --stack-name ET-Database --query 'Stacks[0].Outputs[?OutputKey==`DBDeployBucket`].OutputValue' --output text))
echo $DBDeployBucket
UUID=$(uuidgen)
echo "S3 key: $UUID"

echo 'Push DB Deploy revision to S3:'
aws deploy push --application-name DBDeploy \
--s3-location s3://$DBDeployBucket/$UUID \
--ignore-hidden-files \
--source .
echo 'DB Deploy revision pushed to S3'

echo 'Deploying database data'
DeploymentID=$(aws deploy create-deployment --application-name DBDeploy \
--s3-location bucket=$DBDeployBucket,key=$UUID,bundleType=zip \
--deployment-group-name DBGroup \
--description "Deploying DB data" \
--file-exists-behavior OVERWRITE \
--query deploymentId --output text)
echo "Deployment in progress, deployment ID: $DeploymentID"

set +e