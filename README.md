# VPC Workshops

This repository is dedicated to documenting various VPC (Virtual Private Cloud) labs. It contains a collection of Terraform configurations and scripts to help you set up and manage different VPC scenarios on AWS.


## Getting Started

To get started with any of the labs, navigate to the respective directory and follow the instructions in the `README.md` file.

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS CLI configured with appropriate permissions

### Running a Lab

1. Navigate to the desired lab directory, for example:

    ```sh
    cd gateway-endpoint
    ```

2. Initialize Terraform:

    ```sh
    terraform init
    ```

3. Plan the infrastructure changes:

    ```sh
    terraform plan
    ```

4. Apply the changes:

    ```sh
    terraform apply
    ```

5. Follow any additional instructions provided in the lab's [README.md](http://_vscodecontentref_/5) file.

### Cleaning Up

To clean up the resources created by a lab, run:

```sh
terraform destroy