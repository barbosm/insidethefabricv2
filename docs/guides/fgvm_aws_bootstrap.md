# FortiGate-VM AWS Bootstrap

This deployment reference will will cover how to launch a FG-VM instance
at AWS using Terraform. The instance will boot up with a minimal
config and a license (ON DEMAND).


## Versions
- Terraform v0.13.5


## Deployment

=== "main.tf"

    ```terraform
    --8<-- "code/terraform/fgvm_aws_bootstrap/main.tf"
    ```

=== "variables.tf"

    ```terraform
    --8<-- "code/terraform/fgvm_aws_bootstrap/variables.tf"
    ```

=== "fgtvm.conf"

    ```bash
    --8<-- "code/terraform/fgvm_aws_bootstrap/fgtvm.conf"
    ```


## References
- [Fortinet: Terraform Deployment Templates](https://github.com/fortinet/fortigate-terraform-deploy)
