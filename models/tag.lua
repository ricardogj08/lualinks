-- Uncomment this to use validation rules
local val = require 'valua'
local tag = {}

-- Attributes and their validation rules
tag.attributes = {
  -- {<attribute> = <validation function, valua required>}
  -- Ex. {id = val:new().integer()}
  { id = val:new().integer().min(1) },
  { name = val:new().not_empty().string().len(1, 64) },
  { user_id = val:new().not_empty().integer().min(1) }
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
