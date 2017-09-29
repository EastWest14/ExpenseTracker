set -e

echo '###Expense Tracker application server creation###'
echo ''

echo 'Loading VPC ID:'
VpcID=$(aws ec2 describe-vpcs --query Vpcs[0].VpcId --output text)
echo $VpcID
echo 'Loading Subnet ID:'
SubnetID=$(aws cloudformation describe-stacks --stack-name ET-Network --query 'Stacks[0].Outputs[?OutputKey==`SubnetOne`].OutputValue' --output text)
echo $SubnetID
echo 'Loading Application security group:'
ApplicationSecurityGroup=$(../strip_quotes.sh $(aws cloudformation describe-stacks --stack-name ET-Network --query 'Stacks[0].Outputs[?OutputKey==`ApplicationSecurityGroup`].OutputValue' --output text))
echo $ApplicationSecurityGroup

echo "AWS Key name: $KeyName"

aws cloudformation create-stack --stack-name ET-Database \
--capabilities CAPABILITY_IAM \
--template-body file://database.json \
--parameters ParameterKey=VPC,ParameterValue=$VpcID \
ParameterKey=Subnet,ParameterValue=$SubnetID \
ParameterKey=ApplicationSecurityGroup,ParameterValue=$ApplicationSecurityGroup \
ParameterKey=InstanceType,ParameterValue=t2.micro \
ParameterKey=DBUser,ParameterValue=$DBUser \
ParameterKey=DBPassword,ParameterValue=$DBPassword \
ParameterKey=KeyName,ParameterValue=$KeyName

echo 'Stack creation in progress'
aws cloudformation wait stack-create-complete --stack-name ET-Database
echo 'Database Stack is created'