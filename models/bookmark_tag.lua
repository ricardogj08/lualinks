-- Uncomment this to use validation rules
local val = require 'valua'
local bookmark_tag = {}

-- Attributes and their validation rules
bookmark_tag.attributes = {
  -- {<attribute> = <validation function, valua required>}
  -- Ex. {id = val:new().integer()}
  { id = val:new().integer().min(1) },
  { bookmark_id = val:new().not_empty().integer().min(1) },
  { tag_id = val:new().not_empty().integer().min(1)}
}

bookmark_tag.db = {
  key = 'id',
  table = 'bookmark_tag'
}

bookmark_tag.relations = {}

return bookmark_tag
