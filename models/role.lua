local role = {}
-- Uncomment this to use validation rules
local Valua = require('valua')

-- Attributes and their validation rules
role.attributes = {
  -- {<attribute> = <validation function, valua required>}
  -- Ex. {id = val:new().integer()}
  {id = Valua:new().integer().min(1)},
  {name = Valua:new().not_empty().string().len(1,8).no_white()},
  {description = Valua:new().not_empty().string().len(1,16)}
}

role.db = {
  key = 'id',
  table = 'role'
}

role.relations = {}

return role
