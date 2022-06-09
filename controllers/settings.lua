local M = {}
local User = require 'sailor.model'('user')
local valua = require 'valua'
local access = require 'sailor.access'

--- Consulta los datos de perfil de un usuario de sesión.
function M.view(page)
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local user = User:find_by_id(access.data.id)
  user.password = nil
  page.title = 'Settings'
  return page:render('view', {user = user})
end

--- Elimina la cuenta de un usuario de sesión. 
function M.delete(page)
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local user = User:find_by_id(access.data.id)
  if user then
    user:delete()
    access.logout()
    return page:redirect('user/index')
  end
  return 404
end

return M
