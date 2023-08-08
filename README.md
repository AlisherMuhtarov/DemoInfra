# DemoInfra
this infra includes Auto Scaling Group, Custom Security Group, And Launch Template
# Auto Scaling Group
The ASG has create_before_destroy parameter which allows you to do blue and green deployment so before you destroy an instance it creates one.
It also has instance_refresh so whenever your ASG fetches the new version of the launch template it automatically refreshes the instances to use the latest version of Launch Template
# Launch Template and Jenkinsfile
The launch template will be only changing its "image_id" due to Jenkinsfile as we have already seen we've passed down the variable from our first pipeline which is the packer pipeline and the variable AMI_NAME contained the ami name of the new packer ami and well be using the AMI_NAME variable in this pipeline to switch out the data_source configuration using the linux command "sed"