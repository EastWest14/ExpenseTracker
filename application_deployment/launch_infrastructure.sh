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
echo 'Loading DB Host:'
DBHost=$(aws cloudformation describe-stacks --stack-name ET-Database --query 'Stacks[0].Outputs[?OutputKey==`DatabaseHost`].OutputValue' --output text)
echo $DBHost

echo "AWS Key name: $KeyName"

aws cloudformation create-stack --stack-name ET-Application \
--capabilities CAPABILITY_IAM \
--template-body file://infrastructure.json \
--parameters ParameterKey=VPC,ParameterValue=$VpcID \
ParameterKey=Subnet,ParameterValue=$SubnetID \
ParameterKey=ApplicationSecurityGroup,ParameterValue=$ApplicationSecurityGroup \
ParameterKey=InstanceType,ParameterValue=t2.micro \
ParameterKey=DBHost,ParameterValue=$DBHost \
ParameterKey=DBUser,ParameterValue=$DBUser \
ParameterKey=DBPassword,ParameterValue=$DBPassword \
ParameterKey=KeyName,ParameterValue=$KeyName

echo 'Stack creation in progress'
aws cloudformation wait stack-create-complete --stack-name ET-Application
echo 'Application Stack is created'

echo 'Getting Name of Load Balancer:'
LB_NAME=$(aws cloudformation describe-stacks --stack-name ET-Application --query 'Stacks[0].Outputs[?OutputKey==`LoadBalancerDNSName`].OutputValue' --output text)
echo $LB_NAME

echo 'Getting AutoScaling Group Name:'
AS_GROUP_NAME=$(aws cloudformation describe-stacks --stack-name ET-Application --query 'Stacks[0].Outputs[?OutputKey==`AutoScalingGroup`].OutputValue' --output text)
echo $AS_GROUP_NAME

echo 'Getting CodeDeployRole ARN:'
CD_ROLE=$(aws cloudformation describe-stacks --stack-name ET-Application --query 'Stacks[0].Outputs[?OutputKey==`CodeDeployRole`].OutputValue' --output text)
echo $CD_ROLE

echo 'Creating GB Deployment Group:'
aws deploy create-deployment-group --application-name ETAppDeploy \
--auto-scaling-groups $AS_GROUP_NAME \
--deployment-config-name CodeDeployDefault.OneAtATime \
--deployment-group-name ApplicationGroup \
--load-balancer-info targetGroupInfoList=[{name="AppTargetGroup"}] \
--deployment-style deploymentType=BLUE_GREEN,deploymentOption=WITH_TRAFFIC_CONTROL \
--auto-rollback-configuration enabled=true,events=DEPLOYMENT_FAILURE,DEPLOYMENT_STOP_ON_REQUEST \
--blue-green-deployment-configuration deploymentReadyOption={actionOnTimeout=CONTINUE_DEPLOYMENT},terminateBlueInstancesOnDeploymentSuccess={action=TERMINATE},greenFleetProvisioningOption={action=COPY_AUTO_SCALING_GROUP} \
--service-role-arn $CD_ROLE
