require "active_record"
require "parser/current"
require "proc_party"
require "stringio"

require "ahnnotate/column"
require "ahnnotate/config"
require "ahnnotate/error"
require "ahnnotate/vfs"
require "ahnnotate/vfs_driver/filesystem"
require "ahnnotate/vfs_driver/hash"
require "ahnnotate/vfs_driver/read_only_filesystem"
require "ahnnotate/function/format"
require "ahnnotate/function/main"
require "ahnnotate/function/run"
require "ahnnotate/function/tabularize"
require "ahnnotate/facet/models"
require "ahnnotate/facet/models/main"
require "ahnnotate/facet/models/module_node"
require "ahnnotate/facet/models/processor"
require "ahnnotate/facet/models/resolve_active_record_models"
require "ahnnotate/facet/models/resolve_class_relationships"
require "ahnnotate/facet/models/standin"
require "ahnnotate/index"
require "ahnnotate/options"
require "ahnnotate/table"
require "ahnnotate/tables"
require "ahnnotate/version"

if defined?(Rails)
  require "ahnnotate/railtie"
end
