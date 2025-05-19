locals {
  # let's define common tags that we can use to apply to all resources
  common_tags = merge({
    "managed-by"        = "terraform"
    "environment"       = var.environment
    #"last-updated-by"  = data.azuread_user.current_user.user_principal_name
    #"last_updated_at" = plantimestamp() # it is a cool idea but can be a lot of output so for now it's off
    },
    var.common_tags != null ? var.common_tags : {},
  )

  location_abbreviations = {
    # Europe
    "West Europe"          = "we"
    "westeurope"           = "we"
    "North Europe"         = "ne"
    "northeurope"          = "ne"
    "France Central"       = "fc"
    "francecentral"        = "fc"
    "France South"         = "fs"
    "francesouth"          = "fs"
    "Germany West Central" = "gwc"
    "germanywestcentral"   = "gwc"
    "Germany North"        = "gn"
    "germanynorth"         = "gn"
    "Norway East"          = "noe"
    "norwayeast"           = "noe"
    "Norway West"          = "now"
    "norwaywest"           = "now"
    "Sweden Central"       = "sec"
    "swedencentral"        = "sec"
    "Sweden South"         = "ses"
    "swedensouth"          = "ses"
    "Switzerland North"    = "swn"
    "switzerlandnorth"     = "swn"
    "Switzerland West"     = "sww"
    "switzerlandwest"      = "sww"
    "UK South"             = "uks"
    "uksouth"              = "uks"
    "UK West"              = "ukw"
    "ukwest"               = "ukw"

    # Americas
    "East US"          = "eus"
    "eastus"           = "eus"
    "East US 2"        = "eus2"
    "eastus2"          = "eus2"
    "Central US"       = "cus"
    "centralus"        = "cus"
    "North Central US" = "ncus"
    "northcentralus"   = "ncus"
    "South Central US" = "scus"
    "southcentralus"   = "scus"
    "West US"          = "wus"
    "westus"           = "wus"
    "West US 2"        = "wus2"
    "westus2"          = "wus2"
    "West US 3"        = "wus3"
    "westus3"          = "wus3"
    "Canada Central"   = "cac"
    "canadacentral"    = "cac"
    "Canada East"      = "cae"
    "canadaeast"       = "cae"
    "Brazil South"     = "brs"
    "brazilsouth"      = "brs"
    "Brazil Southeast" = "brse"
    "brazilsoutheast"  = "brse"

    # Asia
    "East Asia"      = "ea"
    "eastasia"       = "ea"
    "Southeast Asia" = "sea"
    "southeastasia"  = "sea"
    "Central India"  = "cin"
    "centralindia"   = "cin"
    "South India"    = "sin"
    "southindia"     = "sin"
    "West India"     = "win"
    "westindia"      = "win"
    "Japan East"     = "jpe"
    "japaneast"      = "jpe"
    "Japan West"     = "jpw"
    "japanwest"      = "jpw"
    "Korea Central"  = "korc"
    "koreacentral"   = "korc"
    "Korea South"    = "kors"
    "koreasouth"     = "kors"
    "China East"     = "che"
    "chinaeast"      = "che"
    "China East 2"   = "che2"
    "chinaeast2"     = "che2"
    "China North"    = "chn"
    "chinanorth"     = "chn"
    "China North 2"  = "chn2"
    "chinanorth2"    = "chn2"

    # Australia
    "Australia East"      = "aue"
    "australiaeast"       = "aue"
    "Australia Southeast" = "ause"
    "australiasoutheast"  = "ause"
    "Australia Central"   = "auc"
    "australiacentral"    = "auc"
    "Australia Central 2" = "auc2"
    "australiacentral2"   = "auc2"

    # Africa
    "South Africa North" = "san"
    "southafricanorth"   = "san"
    "South Africa West"  = "saw"
    "southafricawest"    = "saw"

    # Middle East
    "UAE North"      = "uaen"
    "uaenorth"       = "uaen"
    "UAE Central"    = "uaec"
    "uaecentral"     = "uaec"
    "Qatar Central"  = "qatc"
    "qatarcentral"   = "qatc"
    "Israel Central" = "ilc"
    "israelcentral"  = "ilc"

    # Misc / Gov (if needed)
    "US Gov Virginia" = "usgv"
    "usgovvirginia"   = "usgv"
    "US Gov Arizona"  = "usga"
    "usgovarizona"    = "usga"
  }

  # We can use this to get the location abbreviation from the location name, use it to name resources
  location_abbreviation = lookup(local.location_abbreviations, var.location, "")
}