local bookmark_tag = {}
-- Uncomment this to use validation rules
local Valua = require('valua')

-- Attributes and their validation rules
bookmark_tag.attributes = {
  -- {<attribute> = <validation function, valua required>}
  -- Ex. {id = val:new().integer()}
  {id = Valua:new().integer().min(1)},
  {bookmark_id = Valua:new().not_empty().integer().min(1)},
  {tag_id = Valua:new().not_empty().integer().min(1)}
}

bookmark_tag.db = {
  key = 'id',
  table = 'bookmark_tag'
}

bookmark_tag.relations = {}

return bookmark_tag
