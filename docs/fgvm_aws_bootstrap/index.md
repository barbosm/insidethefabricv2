# FortiGate-VM AWS Bootstrap

This deployment reference will will cover how to launch a FG-VM instance
at AWS using Terraform. The instance will boot up with a minimal
config and a license (ON DEMAND).


## Versions
- Terraform v0.13.5


## Deployment

=== "main.tf"

    ```terraform
    --8<-- "docs/fgvm_aws_bootstrap/terraform/main.tf"
    ```

=== "variables.tf"

    ```terraform
    --8<-- "docs/fgvm_aws_bootstrap/terraform/variables.tf"
    ```

=== "fgtvm.conf"

    ```
    --8<-- "docs/fgvm_aws_bootstrap/terraform/fgtvm.conf"
    ```



## References
- [Fortinet: Terraform Deployment Templates](https://github.com/fortinet/fortigate-terraform-deploy)
