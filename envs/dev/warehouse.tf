# -------------------------------------------------------
# Virtual Warehouse
# -------------------------------------------------------
resource "snowflake_warehouse" "main" {
  name                      = "${var.project_prefix}_WH"
  warehouse_type            = "STANDARD"
  warehouse_size            = var.warehouse_size
  max_cluster_count         = 1
  min_cluster_count         = 1
  auto_suspend              = var.warehouse_auto_suspend
  auto_resume               = true
  enable_query_acceleration = false
  initially_suspended       = true
}
