set -e

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