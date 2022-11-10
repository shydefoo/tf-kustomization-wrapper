# see https://registry.terraform.io/providers/kbst/kustomization/latest/docs/resources/resource for explanation
data "kustomization_build" "test" {
  # depends_on = [null_resource.clone_git_repo]
  path = var.kustomize_path
}

# first loop through resources in ids_prio[0]
resource "kustomization_resource" "p0" {
  for_each = var.ignore_lifecycle_changes == true ? data.kustomization_build.test.ids_prio[0] : []

  manifest = (
    contains(["_/Secret"], regex("(?P<group_kind>.*/.*)/.*/.*", each.value)["group_kind"])
    ? sensitive(data.kustomization_build.test.manifests[each.value])
    : data.kustomization_build.test.manifests[each.value]
  )

  lifecycle {
    ignore_changes = all
  }
}

# then loop through resources in ids_prio[1]
# and set an explicit depends_on on kustomization_resource.p0
resource "kustomization_resource" "p1" {
  for_each = var.ignore_lifecycle_changes == true ? data.kustomization_build.test.ids_prio[1] : []

  manifest = (
    contains(["_/Secret"], regex("(?P<group_kind>.*/.*)/.*/.*", each.value)["group_kind"])
    ? sensitive(data.kustomization_build.test.manifests[each.value])
    : data.kustomization_build.test.manifests[each.value]
  )

  lifecycle {
    ignore_changes = all
  }
  depends_on = [kustomization_resource.p0]
}

# finally, loop through resources in ids_prio[2]
# and set an explicit depends_on on kustomization_resource.p1
resource "kustomization_resource" "p2" {
  for_each = var.ignore_lifecycle_changes == true ? data.kustomization_build.test.ids_prio[2] : []

  manifest = (
    contains(["_/Secret"], regex("(?P<group_kind>.*/.*)/.*/.*", each.value)["group_kind"])
    ? sensitive(data.kustomization_build.test.manifests[each.value])
    : data.kustomization_build.test.manifests[each.value]
  )

  lifecycle {
    ignore_changes = all
  }
  depends_on = [kustomization_resource.p1]
}

# If ignore_lifecycle_changes set to false

resource "kustomization_resource" "p0_u" {
  for_each = var.ignore_lifecycle_changes == true ? [] : data.kustomization_build.test.ids_prio[0]

  manifest = (
    contains(["_/Secret"], regex("(?P<group_kind>.*/.*)/.*/.*", each.value)["group_kind"])
    ? sensitive(data.kustomization_build.test.manifests[each.value])
    : data.kustomization_build.test.manifests[each.value]
  )

}

# then loop through resources in ids_prio[1]
# and set an explicit depends_on on kustomization_resource.p0
resource "kustomization_resource" "p1_u" {
  for_each = var.ignore_lifecycle_changes == true ? [] : data.kustomization_build.test.ids_prio[1]

  manifest = (
    contains(["_/Secret"], regex("(?P<group_kind>.*/.*)/.*/.*", each.value)["group_kind"])
    ? sensitive(data.kustomization_build.test.manifests[each.value])
    : data.kustomization_build.test.manifests[each.value]
  )

  depends_on = [kustomization_resource.p0_u]
}

# finally, loop through resources in ids_prio[2]
# and set an explicit depends_on on kustomization_resource.p1
resource "kustomization_resource" "p2_u" {
  for_each = var.ignore_lifecycle_changes == true ? [] : data.kustomization_build.test.ids_prio[2]

  manifest = (
    contains(["_/Secret"], regex("(?P<group_kind>.*/.*)/.*/.*", each.value)["group_kind"])
    ? sensitive(data.kustomization_build.test.manifests[each.value])
    : data.kustomization_build.test.manifests[each.value]
  )
  depends_on = [kustomization_resource.p1_u]
}
