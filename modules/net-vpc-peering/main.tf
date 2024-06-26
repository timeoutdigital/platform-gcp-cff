/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  local_network_name = element(reverse(split("/", var.local_network)), 0)
  peer_network_name  = element(reverse(split("/", var.peer_network)), 0)
  prefix             = var.prefix == null ? "" : "${var.prefix}-"
}

resource "google_compute_network_peering" "local_network_peering" {
  name                                = "${local.prefix}${local.local_network_name}-${local.peer_network_name}"
  network                             = var.local_network
  peer_network                        = var.peer_network
  export_custom_routes                = var.export_local_custom_routes
  import_custom_routes                = var.export_peer_custom_routes
  export_subnet_routes_with_public_ip = var.export_public_ip_routes
}

resource "google_compute_network_peering" "peer_network_peering" {
  count                               = var.peer_create_peering ? 1 : 0
  name                                = "${local.prefix}${local.peer_network_name}-${local.local_network_name}"
  network                             = var.peer_network
  peer_network                        = var.local_network
  export_custom_routes                = var.export_peer_custom_routes
  import_custom_routes                = var.export_local_custom_routes
  export_subnet_routes_with_public_ip = var.export_public_ip_routes

  depends_on = [google_compute_network_peering.local_network_peering]
}
