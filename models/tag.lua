local tag = {}
-- Uncomment this to use validation rules
local Valua = require('valua')

-- Attributes and their validation rules
tag.attributes = {
  -- {<attribute> = <validation function, valua required>}
  -- Ex. {id = val:new().integer()}
  {id = Valua:new().integer().min(1)},
  {name = Valua:new().not_empty().string().len(1,64).no_white()},
  {user_id = Valua:new().not_empty().integer().min(1)}
}

tag.db = {
  key = 'id',
  table = 'tag'
}

tag.relations = {
  user = {
    relation = 'BELONGS_TO',
    model = 'user',
    attribute = 'user_id'
  },

  bookmarks = {
    relation = 'MANY_MANY',
    model = 'bookmark',
    table = 'bookmark_tag',
    attributes = {'tag_id', 'bookmark_id'}
  }
}

return tag
