resource "azurerm_resource_group" "this" {
  name     = "${var.project_name}-${var.environment}-${local.location_abbreviation}"
  location = var.location

  tags = merge(
    local.common_tags != null ? local.common_tags : {},
  )
}