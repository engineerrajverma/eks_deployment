# in backend we are going to mention where are the artificate is going to store .
# Here i am using S3 bucket.
# when we intialize terrafrom , it we download the required modules and provider plugins and also intialize the backend
#step2
terraform {
       backend "s3" {
        bucket = "mytodoappbacket
        key= "jenkins/terrafomr.tfstate"
        region ="us-east-2
       }
}



