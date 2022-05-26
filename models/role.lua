-- Uncomment this to use validation rules
local val = require 'valua'
local role = {}

-- Attributes and their validation rules
role.attributes = {
  -- {<attribute> = <validation function, valua required>}
  -- Ex. {id = val:new().integer()}
  { id = val:new().integer().min(1) },
  { name = val:new().not_empty().string().len(1, 24) },
  { description = val:new().not_empty().string().len(1, 256) }
}

role.db = {
  key = 'id',
  table = 'role'
}

role.relations = {}

return role
