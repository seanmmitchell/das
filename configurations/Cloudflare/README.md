# Cloudflare Terraform Configurations
In this folder you will find terraform scripts that can be used for configuring Cloudflare programatically. If API focused additions are made then I will change this README to reflect that information, but in the current state it is best to assume that only terraform content exists here currently.

# Recomendations
I recomend copying `.env.example` to `.env` and updating the values contained so you can avoid typing sensitive data such as API keys into the command line. After copying it, on an -NIX system such as Linux or MacOS you can type `source .env` to load the values into your terminal.

# Organization
Each subfolder in this directory has a prefix XXXX_FOLDER-NAME. The prefixs mean the following:
- TF_ 
  - A terraform scripting directory for things such as terraform importing. These directorys provide advice or tools for creating your own configurations.
- Zone_
  - Any terraform script targeting a zone level.
- Acct_
  - Any terraform script targeting an account or including an account level target.

# Local Validation

CI uses Terraform 1.13.5 with the committed provider lock files. From each `TF_`
or `Zone_` directory, run:

```sh
terraform fmt -check -recursive
terraform init -backend=false -input=false -lockfile=readonly
terraform validate
```

From either `Zone_` directory, also run `terraform test`
to check Free, Pro, Pro Plus, Business, and Enterprise plan detection. These tests
use a mocked provider and plan-only runs, so they need no credentials and do not
create or modify Cloudflare resources. They do not validate live API behavior or
plan entitlements for individual Cloudflare features.

# Useful Links
## Cloudflare Terraform Dev Docs:
>https://developers.cloudflare.com/terraform/

##  Cloudflare Terraform Provider:
>https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
