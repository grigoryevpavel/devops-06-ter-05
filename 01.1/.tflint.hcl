config {
    module=true
    format = "compact"
    plugin_dir = "~/.tflint.d/plugins" 
}
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}