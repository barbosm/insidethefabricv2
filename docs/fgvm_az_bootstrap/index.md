# FortiGate-VM Azure Bootstrap

This deployment reference will will cover how to launch a FG-VM instance
at Azure using Terraform. The instance will boot up with a minimal
config and a license (ON DEMAND).


## Versions
- Terraform v0.13.5
- Azure CLI 2.16.0

## Deployment

=== "main.tf"

    ```terraform
    --8<-- "docs/fgvm_az_bootstrap/terraform/main.tf"
    ```

=== "variables.tf"

    ```terraform
    --8<-- "docs/fgvm_az_bootstrap/terraform/variables.tf"
    ```

=== "fgvm.conf"

    ```
    --8<-- "docs/fgvm_az_bootstrap/terraform/fgtvm.conf"
    ```



## References
- [Microsoft: Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Fortinet: Terraform Deployment Templates](https://github.com/fortinet/fortigate-terraform-deploy)