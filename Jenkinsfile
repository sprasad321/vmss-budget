pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy_budget', 'rmstate_budget'],
            description: 'apply = create VMSS + Budget; destroy_budget = delete only budget in Azure; rmstate_budget = remove from state only'
        )
    }

    environment {
        ARM_CLIENT_ID = 'a9457979-c45c-4dbf-9d29-63a9597c4f36'
        ARM_CLIENT_SECRET = 'rPD8Q~s.NlCRTzH_AIjPJcjFqtOhMEFMkgJjydcE'
        ARM_TENANT_ID = 'a1099c37-a63e-49aa-aae9-c1c91be6b89a'
        ARM_SUBSCRIPTION_ID = '972f43d4-e847-43f2-8efe-0f9c1507d61e'
        TF_VAR_subscription_id = '/subscriptions/972f43d4-e847-43f2-8efe-0f9c1507d61e'
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Terraform Init and Validate') {
            steps {
                sh '''
                terraform -chdir=terraform init -input=false
                terraform -chdir=terraform fmt -check -diff || true
                terraform -chdir=terraform validate
                '''
            }
        }

        stage('Execute Terraform') {
            steps {
                script {
                    if (params.ACTION == 'apply') {
                        sh '''
                        terraform -chdir=terraform plan -out=tfplan
                        terraform -chdir=terraform apply -auto-approve tfplan
                        '''
                    } else if (params.ACTION == 'destroy_budget') {
                        sh '''
                        terraform -chdir=terraform destroy -auto-approve -target=azurerm_consumption_budget_subscription.vmss_budget
                        '''
                    } else if (params.ACTION == 'rmstate_budget') {
                        sh '''
                        terraform -chdir=terraform state rm azurerm_consumption_budget_subscription.vmss_budget || true
                        '''
                    }
                }
            }
        }
    }
}
