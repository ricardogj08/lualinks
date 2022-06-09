local M = {}
local User = require 'sailor.model'('user')
local valua = require 'valua'
local access = require 'sailor.access'

--- Valida todos los campos del formulario.
-- @user Es una instancia del modelo user.
-- @page Objeto page del controlador.
-- @input Es una tabla con todos los campos a validar.
-- @return Una tabla de errores por cada campo.
local function validate(user,page,input)
  local err,val = {}
  if input.username then
    val,err.username = valua:new().not_empty().string()(user.username)
    if val and User:find_by_attributes({username = user.username}) then
      err.username = 'username alredy exists'
    end
  end
  if input.password or input.username then
    val,err.password = valua:new().not_empty().string().len(1, 64).
      no_white().compare(page.POST.confirm_password)(user.password)
    if err.password and input.username then
      err.password = 'Please confirm o set a new password'
    end
  end
  return err
end

--- Consulta los datos de perfil de un usuario de sesión.
function M.view(page)
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local user,saved = User:find_by_id(access.data.id)
  -- Valida si existe un campo del formulario.
  if next(page.POST) then
    -- Elimina campos vacíos.
    for k,v in pairs(page.POST) do
      if v == '' then
        page.POST[k] = nil
      end
    end
    -- Obtiene todos los campos del formulario.
    user:get_post(page.POST)
    local u = User:find_by_id(access.data.id)
    user.role_id = u.role_id
    -- Valida solo los campos modificados.
    local input = {
      username = user.username ~= u.username,
      password = user.password ~= u.password
    }
    user.errors = validate(user, page, input)
    -- Cifra la contraseña.
    saved = not next(user.errors)
    if input.password and saved then
      user.password = access.hash(user.username, user.password)
    end
    -- Desde el modelo valida todos los campos del formulario
    -- y modifica los datos del usuario de sesión.
    saved = saved and user:update()
    if saved then
      return page:redirect('settings/view')
    end
  end
  user.password = nil
  page.title = 'Settings'
  return page:render('view', {user = user, saved = saved})
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
