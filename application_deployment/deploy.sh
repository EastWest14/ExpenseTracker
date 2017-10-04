set -e

echo 'Build Application'
export GOOS=linux
export GOARCH=amd64
cd application
go build main.go
cd ..

echo 'Loading Application deploy S3:'
AppDeployBucket=$(aws cloudformation describe-stacks --stack-name ET-Application --query 'Stacks[0].Outputs[?OutputKey==`AppDeployBucket`].OutputValue' --output text)
echo $AppDeployBucket
UUID=$(uuidgen)
echo "S3 key: $UUID"

echo 'Push Application Deploy revision to S3:'
aws deploy push --application-name DBDeploy \
--s3-location s3://$AppDeployBucket/$UUID \
--ignore-hidden-files \
--source ./application
echo 'Application Deploy revision pushed to S3'

echo 'Deploying application'
DeploymentID=$(aws deploy create-deployment --application-name ETAppDeploy \
--s3-location bucket=$AppDeployBucket,key=$UUID,bundleType=zip \
--deployment-group-name ApplicationGroup \
--description "Deploying Application" \
--file-exists-behavior OVERWRITE \
--query deploymentId --output text)
echo "Deployment in progress, deployment ID: $DeploymentID"
