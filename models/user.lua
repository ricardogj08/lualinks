local user = {}
-- Uncomment this to use validation rules
local Valua = require('valua')

-- Attributes and their validation rules
user.attributes = {
  -- {<attribute> = <validation function, valua required>}
  -- Ex. {id = val:new().integer()}
  {id = Valua:new().integer().min(1)},
  {username = Valua:new().not_empty().string().len(1,64).no_white()},
  {role_id = Valua:new().not_empty().integer().min(1)},
  {password = Valua:new().not_empty().string().len(1,256).no_white()}
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
