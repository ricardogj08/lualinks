-- Uncomment this to use validation rules
local val = require 'valua'
local user = {}

-- Attributes and their validation rules
user.attributes = {
  -- {<attribute> = <validation function, valua required>}
  -- Ex. {id = val:new().integer()}
  { id = val:new().not_empty().integer().min(1) },
  { username = val:new().not_empty().string().len(1, 64) },
  { role_id = val:new().not_empty().integer().min(1) },
  { password = val:new().not_empty().string().no_white().len(1, 256) }
}

user.db = {
  key = 'id',
  table = 'user'
}

user.relations = {
  role = {
    relation = 'BELONGS_TO',
    model = 'role',
    attribute = 'role_id'
  }
}

return user
