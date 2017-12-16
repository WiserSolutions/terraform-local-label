#
# Terraform module to provide consistent naming
#
# TODO:
#   Change where replace is done. Move to earlier in process. On initial `name`?
#   Create tags_asg list from tags map. If possible
#   New input tags_asg -> tags_asg with standard tags added

module "namespace-env" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.0"
  value   = "${var.namespace-env}"
}
module "namespace-org" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.0"
  value   = "${var.namespace-org}"
}

locals {
  attr        = "${lower(format("%s", join(var.delimiter, compact(var.attributes))))}"
  env         = "${lower(format("%s", var.environment))}"
  name_low    = "${lower(format("%s", var.name))}"
  org         = "${lower(format("%s", var.organization))}"
  id_env      = "${module.namespace-env.value ? join(var.delimiter, list(local.env, local.name_low)) : local.name_low}"
  id_org      = "${module.namespace-org.value ? join(var.delimiter, list(local.org, local.id_env)) : local.id_env}"
  id          = "${length(local.attr) > 0 ? join(var.delimiter, list(local.id_org, local.attr)) : local.id_org}"
  id_20       = "${substr(replace(local.id,"_","-"),0,19 <= length(local.id) ? 19 : length(local.id))}"
  id_32       = "${substr(replace(local.id,"_","-"),0,31 <= length(local.id) ? 31 : length(local.id))}"
  org_attr_20 = "${min(18 - length(local.attr), length(local.id_org))}"
  id_attr_20  = "${19 <= length(local.id) ?
    join(var.delimiter,
      list(
        substr(local.id_org,0,
          local.org_attr_20 >= 0 ? local.org_attr_20 : 0)
      ),
      list(local.attr)
    )
    : local.id}"
  org_attr_32 = "${min(30 - length(local.attr), length(local.id_org))}"
  id_attr_32  = "${31 <= length(local.id) ?
    join(var.delimiter,
      list(
        substr(local.id_org,0,
          local.org_attr_32 >= 0 ? local.org_attr_32 : 0)
      ),
      list(local.attr)
    )
    : local.id}"

  #TODO: only add Organization if not ""
  tags      = "${ merge(
    var.tags,
    map(
      "Name", "${local.id}",
      "Environment", "${local.env}",
      "Organization", "${local.org}",
      "Terraform", "true"
    )
  )}"
  /*
  tags_asg  = ["${ concat(
    list(
      map("key", "Name",
        "value", var.namespaced ? format("%s-%s", var.environment, var.name)
        : format("%s", var.name), "propagate_at_launch", true),
      map("key", "Cluster",
        "value", var.namespaced ? format("%s-%s", var.environment, var.name)
        : format("%s", var.name), "propagate_at_launch", true),
      map("key", "Environment", "value", var.environment, "propagate_at_launch", true),
      map("key", "Terraform", "value", "true", "propagate_at_launch", true)
    ),
    var.tags_asg)
  }"]
*/
}
