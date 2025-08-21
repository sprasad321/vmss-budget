resource "azurerm_consumption_budget_subscription" "vmss_budget" {
  name            = "vmss-demo-monthly-budget"
  subscription_id = var.subscription_id
  amount          = 50
  time_grain      = "Monthly"

  time_period {
    start_date = "2025-08-01T00:00:00Z"
    end_date   = "2030-12-31T00:00:00Z"
  }

  filter {
    tag {
      name     = "costScope"
      operator = "In"
      values   = ["vmss-demo"]
    }
  }

  notification {
    enabled         = true
    operator        = "GreaterThan"
    threshold       = 80
    threshold_type  = "Actual"
    contact_emails  = ["alerts@example.com"]
  }

  notification {
    enabled         = true
    operator        = "GreaterThan"
    threshold       = 100
    threshold_type  = "Forecasted"
    contact_emails  = ["hollasowmya@gmail.com"]
  }
}
