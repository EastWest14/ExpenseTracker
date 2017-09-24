set -e

echo '###Expense Tracker network CF launch###'
echo ''

echo 'Loading VPC ID:'
VpcID=$(aws ec2 describe-vpcs --query Vpcs[0].VpcId --output text)
echo $VpcID
echo 'Loading DB subnet group:'
DBSubnetGroup=$(../strip_quotes.sh $(aws cloudformation describe-stacks --stack-name ET-Network --query 'Stacks[0].Outputs[?OutputKey==`DatabaseSubnetGroup`].OutputValue' --output text))
echo $DBSubnetGroup
echo 'Loading DB security group:'
DBSecurityGroup=$(../strip_quotes.sh $(aws cloudformation describe-stacks --stack-name ET-Network --query 'Stacks[0].Outputs[?OutputKey==`DatabaseSecurityGroup`].OutputValue' --output text))
echo $DBSecurityGroup

aws cloudformation create-stack --stack-name ET-Database \
--capabilities CAPABILITY_IAM \
--template-body file://database.json \
--parameters ParameterKey=VPC,ParameterValue=$VpcID \
ParameterKey=DatabaseSubnetGroup,ParameterValue=$DBSubnetGroup \
ParameterKey=DatabaseSecurityGroup,ParameterValue=$DBSecurityGroup

echo 'Stack creation in progress'
aws cloudformation wait stack-create-complete --stack-name ET-Database
echo 'Database Stack is created'

set +e