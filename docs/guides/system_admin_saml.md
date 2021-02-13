# System Admin and SAML

Configure a FortiOS system admin that will authenticate against a SAML
Identity Provider, in this case, Okta.


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
- [Okta: Create a SAML integration using AIW](https://help.okta.com/en/prod/Content/Topics/Apps/Apps_App_Integration_Wizard_SAML.htm)