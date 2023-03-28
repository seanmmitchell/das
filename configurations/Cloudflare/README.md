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

# Useful Links
## Cloudflare Terraform Dev Docs:
>https://developers.cloudflare.com/terraform/

##  Cloudflare Terraform Provider:
>https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs