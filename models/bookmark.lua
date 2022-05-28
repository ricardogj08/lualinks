-- Uncomment this to use validation rules
local val = require 'valua'
local bookmark = {}

-- Attributes and their validation rules
bookmark.attributes = {
  -- {<attribute> = <validation function, valua required>}
  -- Ex. {id = val:new().integer()}
  { id = val:new().integer().min(1) },
  { user_id = val:new().not_empty().integer().min(1) },
  { url = val:new().not_empty().string().len(1, 2048) },
  { title = val:new().not_empty().string().len(1, 512) },
  { description = val:new().not_empty().string().len(1, 1024) }
}

bookmark.db = {
  key = 'id',
  table = 'bookmark'
}

bookmark.relations = {
  tags = {
    relation = 'MANY_MANY',
    model = 'tag',
    table = 'bookmark_tag',
    attributes = {'bookmark_id', 'tag_id'}
  }
}

return bookmark
