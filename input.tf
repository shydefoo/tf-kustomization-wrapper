variable "kustomize_path" {
  description = "Path to kustomize app with reference to vino_repo"
}

variable "ignore_lifecycle_changes" {
  default     = true
  description = "If set to true, will ignore lifecycle changes of resources. This means tf will only create or destroy kustomize resources, and ignore and diffs in the resource's desired state vs live state."
}
