pipeline {
    agent any
    parameters {
        string(name: 'AMI_NAME', description: 'AMI name to use in data_source.tf')
        booleanParam(name: 'TERRAFORM_DESTROY', defaultValue: false, description: 'Perform Terraform destroy')
    }
    stages {
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }
        stage('terraform plan') {
            when {
                expression { !params.TERRAFORM_DESTROY }
            }
            steps {
                dir('terraform') {
                    sh "echo ${AMI_NAME}"
                    sh "echo ${env.AMI_NAME}"
                    sh "sed -i 's/base-image/${env.AMI_NAME}/g' data_source.tf"
                    sh 'terraform plan'
                }
            }
        }
        stage('terraform apply') {
            when {
                expression { !params.TERRAFORM_DESTROY }
            }
            steps {
                dir('terraform') {
                    script{
                        def showOutput = sh(script: 'terraform show', returnStdout: true).trim()

                        // Check if the launch template resource is present in the show output
                        def launchTemplateResourceExists = showOutput.contains('aws_launch_template.app_asg_lc')

                        if (launchTemplateResourceExists) {
                            echo "Launch template resource exists. Applying specific target."
                            sh 'terraform apply -auto-approve -target=aws_launch_template.app_asg_lc'
                            sh 'terraform apply -auto-approve -target=aws_autoscaling_group.app'
                        } else {
                            echo "Launch template resource not found. Applying normally."
                            sh 'terraform apply -auto-approve'
                        }
                    }
                }
            }
        }
        stage('terraform destroy') {
            when {
                expression { return params.TERRAFORM_DESTROY }
            }
            steps {
                dir('terraform') {
                    sh "sed -i 's/base-image/${env.AMI_NAME}/g' data_source.tf"
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}