# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# tfdoc:file:description Core locals.

locals {
  aws_sa_iam_email = "serviceAccount:${var.aws_sa_email}"
  dataform_sa_iam_email = "serviceAccount:service-${var.dataform_project_number}@gcp-sa-dataform.iam.gserviceaccount.com"
  groups = {
    for k, v in var.groups : k => "${v}@${var.organization_domain}"
  }
  groups_iam = {
    for k, v in local.groups : k => "group:${v}"
  }
  looker_sa_iam_email = "serviceAccount:${var.looker_sa_email}"
  project_suffix = var.project_suffix == null ? "" : "-${var.project_suffix}"
  use_shared_vpc = var.network_config.host_project != null
}
