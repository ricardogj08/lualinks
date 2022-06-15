local bookmark = {}
-- Uncomment this to use validation rules
local Valua = require('valua')

-- Attributes and their validation rules
bookmark.attributes = {
  -- {<attribute> = <validation function, valua required>}
  -- Ex. {id = val:new().integer()}
  {id = Valua:new().integer().min(1)},
  {user_id = Valua:new().not_empty().integer().min(1)},
  {url = Valua:new().not_empty().string().len(1,2048).no_white()},
  {archive = Valua:new().optional().string().len(1,2048).no_white()},
  {title = Valua:new().not_empty().string().len(1,512)},
  {description = Valua:new().optional().string().len(1,1024)}
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
