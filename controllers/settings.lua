local M = {}
local APP_URL = require 'conf.conf'.sailor.app_url
local access = require('sailor.access')
local User = require('sailor.model')('user')
local Valua = require('valua')

--- Valida los campos de un formulario.
-- @param user object: Instancia del modelo user.
-- @param page object: Objeto page del controlador.
-- @param input table: Una tabla con todos los campos a validar.
-- @return table: Una tabla de errores por cada campo.
local function validate(user,page,input)
  local err,val = {}
  if input.username then
    val,err.username = Valua:new().not_empty().
      string().len(1,64).no_white()(user.username)
    if val and User:find_by_attributes({
      username = user.username
    })
    then
      err.username = 'username alredy exists'
    end
  end
  if input.password or input.username then
    val,err.password = Valua:new().not_empty().string().len(8,64).
      no_white().compare(page.POST.confirm_password)(user.password)
    if err.password and input.username then
      err.password = 'Please confirm o set a new password'
    end
  end
  return err
end

--- Consulta los datos de perfil de un usuario.
function M.view(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local id,saved = access.data.id
  local user = User:find_by_id(id)
  if next(page.POST) then
    -- Obtiene los campos del formulario.
    user:get_post(page.POST)
    local usr = User:find_by_id(id)
    -- Asegura que el rol no se pueda modificar.
    user.role_id = usr.role_id
    -- Valida solo los campos modificados.
    local input = {
      username = user.username ~= usr.username,
      password = user.password
    }
    local err = validate(user,page,input)
    -- Cifra la contraseña.
    user.password = input.password and not err.password and
      access.hash(user.username, user.password) or usr.password
    user.errors = err
    -- Desde el modelo valida los campos
    -- y modifica los datos del usuario.
    saved = not next(err) and user:update()
    page:inspect(user)
  end
  page.title,user.password = 'Settings'
  page:render('view', {user = user, saved = saved})
end

-- Elimina la cuenta de un usuario.
function M.delete(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local user = User:find_by_id(access.data.id)
  if not user then
    return 404
  end
  user:delete()
  access.logout()
  page:redirect('user/login')
end

return M
