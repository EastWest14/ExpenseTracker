# ExpenseTracker
**WIP**
An AWS hosted web application for accumulating and analysing expenses. Uses CodeDeploy and CloudFormation.

Prerequisites:
- Bash. (with uuidgen installed)
- Configured AWS account.
- AWS CLI installed with version 1.11.155 or above.
- Set environment variables DBUser, DBPassword and KeyName (name of AWS key).
- Go installed with GOPATH set directly above the repo.

Launch instructions:
1. Launch network infrastructure.
`cd network_deployment;
./launch_network.sh`
2. Launch database.
`cd database_deployment;
./launch_database;
./deploy`
3. Launch application.
`cd application_deployment;
./launch_infrastructure.sh;
./deploy.sh`

To deploy new application, run:
`cd application_deployment;
./deploy.sh`

This will re-build and re-deploy application through Blue-Green deployment on AWS.