pipeline {
    agent any

    // Define pipeline parameters
    parameters {
        string(name: 'AMI_NAME', description: 'AMI name to use in data_source.tf')
        booleanParam(name: 'TERRAFORM_DESTROY', defaultValue: false, description: 'Perform Terraform destroy')
    }

    // Define environment variables
    environment {
        APPLY_RUN_ONCE = 'no' // Used to control applying Terraform only once
    }

    // Define pipeline stages
    stages {
        stage('Terraform Init') {
            // Initialize Terraform in the terraform directory
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('terraform plan') {
            when {
                // Condition to run this stage based on variables and parameters
                expression { return env.APPLY_RUN_ONCE == 'no' && !params.TERRAFORM_DESTROY }
            }
            steps {
                dir('terraform') {
                    sh "echo ${AMI_NAME}"
                    sh "echo ${env.AMI_NAME}"
                    // Replace AMI reference in data_source.tf with the specified AMI_NAME
                    sh "sed -i 's/base-image/${env.AMI_NAME}/g' data_source.tf"
                    sh 'terraform plan' // Generate and show the Terraform plan
                }
            }
        }

        stage('terraform apply') {
            when {
                // Condition to run this stage based on variables and parameters
                expression { return env.APPLY_RUN_ONCE == 'no' && !params.TERRAFORM_DESTROY }
            }
            steps {
                dir('terraform') {
                    script{
                        // Get the output of the current infrastructure state
                        def showOutput = sh(script: 'terraform show', returnStdout: true).trim()

                        // Check if the launch template resource is present in the show output
                        def launchTemplateResourceExists = showOutput.contains('aws_launch_template.app_asg_lc')

                        if (launchTemplateResourceExists) {
                            echo "Launch template resource exists. Applying specific targets."
                            sh 'terraform apply -auto-approve -target=aws_launch_template.app_asg_lc'
                            sh 'terraform apply -auto-approve -target=aws_autoscaling_group.app'
                        } else {
                            echo "Launch template resource not found. Applying normally."
                            sh 'terraform apply -auto-approve'
                        }
                    }
                }
            }
            post {
                success {
                    always {
                        script {
                            env.APPLY_RUN_ONCE = 'yes' // Mark that Terraform has been applied
                        }
                    }
                }
            }
        }

        stage('terraform destroy') {
            when {
                // Condition to run this stage if Terraform destroy is requested
                expression { return params.TERRAFORM_DESTROY }
            }
            steps {
                dir('terraform') {
                    // Replace AMI reference in data_source.tf for destroy operation
                    sh "sed -i 's/base-image/${env.AMI_NAME}/g' data_source.tf"
                    sh 'terraform destroy -auto-approve' // Execute Terraform destroy
                }
            }
        }
    }
}
