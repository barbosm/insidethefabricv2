# FortiGate-VM GCP Bootstrap

This deployment reference will will cover how to launch a FG-VM instance
at GCP using Terraform. The instance will boot up with a minimal
config and a license (ON DEMAND).


## Versions
- Terraform v0.14.4


## Deployment

=== "main.tf"

    ```terraform
    --8<-- "code/terraform/fgvm_gcp_bootstrap/main.tf"
    ```

=== "variables.tf"

    ```terraform
    --8<-- "code/terraform/fgvm_gcp_bootstrap/variables.tf"
    ```

=== "fgtvm.conf"

    ```bash
    --8<-- "code/terraform/fgvm_gcp_bootstrap/fgtvm.conf"
    ```


## References
- [Fortinet: Terraform Deployment Templates](https://github.com/fortinet/fortigate-terraform-deploy)
