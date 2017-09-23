set -e

echo '###Expense Tracker network CF launch###'
echo ''

echo 'Loading VPC ID:'
VpcID=$(aws ec2 describe-vpcs --query Vpcs[0].VpcId --output text)
echo $VpcID
echo 'Loading Subnet ID:'
SubnetID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VpcID --query Subnets[0].SubnetId --output text)
echo $SubnetID

aws cloudformation create-stack --stack-name ET-Network \
--capabilities CAPABILITY_IAM \
--template-body file://network.json \
--parameters ParameterKey=VPC,ParameterValue=$VpcID \
ParameterKey=Subnet,ParameterValue=$SubnetID \
ParameterKey=InstanceType,ParameterValue=t2.micro

echo 'Stack creation in progress'
aws cloudformation wait stack-create-complete --stack-name Tofu
echo 'Network Stack is created'

set +e