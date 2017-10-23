require "yaml"
def loadyaml filename
  yaml=File.read filename
  YAML.load yaml
end

$config=loadyaml "config.yaml"
