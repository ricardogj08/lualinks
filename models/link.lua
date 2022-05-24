-- Uncomment this to use validation rules
local val = require 'valua'
local link = {}

-- Attributes and their validation rules
link.attributes = {
  -- {<attribute> = <validation function, valua required>}
  -- Ex. {id = val:new().integer()}
  { id = val:new().not_empty().integer().min(1) },
  { user_id = val:new().not_empty().integer().min(1) },
  { url = val:new().not_empty().string().len(1, 2048) },
  { title = val:new().not_empty().string().len(1, 512) },
  { description = val:new().not_empty().string().len(1, 1024) }
}

link.db = {
  key = 'id',
  table = 'link'
}

link.relations = {
  tags = {
    relation = 'MANY_MANY',
    model = 'tag',
    table = 'link_tag',
    attributes = {'link_id', 'tag_id'}
  }
}

return link
