data "ovh_order_cart" "card" {
  ovh_subsidiary = "ca"
}

data "ovh_order_cart_product_plan" "vrack" {
  cart_id        = data.ovh_order_cart.card.id
  price_capacity = "renew"
  product        = "vrack"
  plan_code      = "vrack"
}


resource "ovh_vrack" "vrack" {
  ovh_subsidiary = data.ovh_order_cart.card.ovh_subsidiary
  name           = "k8s"
  description    = "k8s"

  plan {
    duration     = data.ovh_order_cart_product_plan.vrack.selected_price.0.duration
    plan_code    = data.ovh_order_cart_product_plan.vrack.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.vrack.selected_price.0.pricing_mode
  }
}


resource "ovh_vrack_cloudproject" "this" {
  service_name = ovh_vrack.vrack.service_name
  project_id   = local.global_openstack_project_id
}
