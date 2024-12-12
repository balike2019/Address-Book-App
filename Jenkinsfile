pipeline {
    agent { node { label 'jenkins_terraform_slave' } } 
    
    parameters {
        choice(name: 'Deployment_Type', choices: ['apply', 'destroy'], description: 'The deployment type (apply or destroy)')
    }
    
    environment {
        EMAIL_TO = 'anna.balike36@gmail.com'
        AWS_REGION = 'us-east-1'
    }
    
    stages {
        stage('1. Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                sh 'terraform init'
            }
        }
        
        stage('2. Terraform Plan') {
            steps {
                echo 'Running Terraform plan...'
                sh "AWS_REGION=${AWS_REGION} terraform plan"
            }
        }
        
        stage('3. Manual Approval') {
            steps {
                script {
                    def approval = input message: "Should we proceed with ${params.Deployment_Type}?", 
                                         ok: "Yes, proceed", 
                                         parameters: [
                                            choice(name: 'Manual_Approval', 
                                                   choices: ['Approve', 'Reject'], 
                                                   description: 'Approve or Reject the deployment')
                                         ]
                    if (approval == 'Reject') {
                        error "Deployment rejected by user."
                    }
                }
            }
        }
        
        stage('4. Terraform Deploy') {
            steps {
                echo "Starting Terraform ${params.Deployment_Type}..."
                sh "AWS_REGION=${AWS_REGION} terraform ${params.Deployment_Type} --auto-approve"
                sh "chmod +x -R scripts"
                sh "scripts/update-kubeconfig.sh"
                sh "scripts/install_helm.sh"
            }
        }
        
        stage('5. Email Notification') {
            steps {
                mail bcc: "${EMAIL_TO}",
                     body: """Terraform ${params.Deployment_Type} deployment has been completed.
                             Please verify the changes and let me know if there are any issues.
                             Thank you,
                             BalikeTech,
                             +27710525583""",
                     cc: "${EMAIL_TO}",
                     from: '',
                     replyTo: '',
                     subject: "Terraform Deployment (${params.Deployment_Type}) Completed!",
                     to: "${EMAIL_TO}"
            }
        }
    }
}
