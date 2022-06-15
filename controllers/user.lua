local M = {}
local APP_URL = require 'conf.conf'.sailor.app_url
local access = require('sailor.access')
local User = require('sailor.model')('user')
local Role = require('sailor.model')('role')
local Valua = require('valua')
local DB = require('sailor.db')

--- Valida si un usuario es administrador.
-- @param id integer: Identificador único del usuario.
-- @return boolean
local function is_admin(id)
  local user = User:find_by_id(id)
  return user and user.role.name == 'admin'
end

--- Valida los campos de un formulario.
-- @param user object: Instancia del modelo user.
-- @param page object: Objecto page del controlador.
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
  if input.role_id then
    val,err.role_id = Valua:new().not_empty().integer()(user.role_id)
    if val and not Role:find_by_id(user.role_id) then
      err.role_id = 'Invalid role id'
    end
  end
  if input.password or input.username then
    val,err.password = Valua:new().not_empty().string().len(8,64).
      no_white().compare(page.POST.confirm_password)(user.password)
  end
  return err
end

--- Lista todos los roles del sistema.
-- @return table: Una tabla de nombres de roles.
local function roles()
  local roles = {}
  for _,r in ipairs(Role:find_all()) do
    roles[r.id] = r.description
  end
  return roles
end

--- Inicio de sesión.
function M.login(page)
  page:enable_cors({allow_origin = APP_URL})
  if not access.is_guest() then
    return page:redirect('bookmark/index')
  end
  local user = User:new()
  local auth = {}
  if next(page.POST) then
    -- Obtiene los campos del formulario.
    user:get_post(page.POST)
    -- Define las credenciales de acceso.
    access.settings({model = 'user'})
    auth.ok,auth.err = access.login(user.username or '', user.password or '')
    if auth.ok then
      return page:redirect('bookmark/index')
    end
  end
  page:render('login', {user = user, auth = auth})
end

--- Cierre de sesión.
function M.logout(page)
  page:enable_cors({allow_origin = APP_URL})
  access.logout()
  page:redirect('user/login')
end

--- Lista todos los usuarios.
function M.index(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  if not is_admin(access.data.id) then
    return 404
  end
  -- Obtiene el patrón de búsqueda.
  local search = page.POST.search
  if search then
    return page:redirect('user/index', {search = search})
  end
  search = page.GET.search or ''
  -- Obtiene el número de paginación.
  local index = tonumber(page.GET.index) or 1
  if index < 1 then
    if search == '' then
      return page:redirect('user/index', {index = 1})
    end
    return page:redirect('user/index', {search = search, index = 1})
  end
  local limit = 15
  local offset = limit * (index - 1)
  -- Busca todos los usuarios desde un patrón de búsqueda.
  DB.connect()
  local users = User:find_all("username LIKE '%"..DB.escape(search)..
    "%' ORDER BY id LIMIT "..limit..' OFFSET '..offset
  )
  DB.close()
  -- Valida la paginación cuando no hay resultados.
  if not next(users) and index > 1 then
    if search == '' then
      return page:redirect('user/index', {index = index - 1})
    end
    return page:redirect('user/index', {search = search, index = index - 1})
  end
  page.title = 'Users'
  page:render('index', {users = users, search = search, index = index})
end

--- Registra un nuevo usuario.
function M.create(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  if not is_admin(access.data.id) then
    return 404
  end
  local user,saved = User:new()
  if next(page.POST) then
    -- Obtiene los campos del formulario.
    user:get_post(page.POST)
    -- Valida los campos del formulario.
    local err = validate(user, page, {
      username = true,
      role_id = true,
      password = true
    })
    user.errors = err
    if not next(err) then
      -- Cifra la contraseña.
      user.password = access.hash(user.username, user.password)
      -- Desde el modelo valida los campos
      -- y registra un nuevo usuario.
      saved = user:save()
      if saved then
        return page:redirect('user/index')
      end
    end
  end
  page.title = 'Create user'
  page:render('create', {user = user, saved = saved, roles = roles()})
end

--- Modifica los datos de un usuario.
function M.update(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  if not is_admin(access.data.id) then
    return 404
  end
  -- Valida si el usuario existe.
  local id = page.GET.id
  local user = User:find_by_id(id)
  if not user then
    return 404
  end
  local saved
  if next(page.POST) then
    -- Obtiene los campos del formulario.
    user:get_post(page.POST)
    local usr = User:find_by_id(id)
    -- Valida solo los campos modificados.
    local input = {
      username = user.username ~= usr.username,
      role_id = user.role_id ~= usr.role_id,
      password = user.password
    }
    local err = validate(user,page,input)
    -- Cifra la contraseña.
    if input.username and err.password then
      err.password = 'Please confirm o set a new password'
    end
    user.password = input.password and not err.password and
      access.hash(user.username, user.password) or usr.password
    user.errors = err
    -- Desde el modelo valida los campos
    -- y modifica los datos del usuario.
    saved = not next(err) and user:update()
  end
  page.title,user.password = 'Update user'
  page:render('update', {user = user, saved = saved, roles = roles()})
end

--- Consulta los datos de un usuario.
function M.view(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  if not is_admin(access.data.id) then
    return 404
  end
  -- Valida si el usuario existe.
  local user = User:find_by_id(page.GET.id)
  if not user then
    return 404
  end
  page.title = user.username
  page:render('view', {user = user})
end

--- Elimina un usuario.
function M.delete(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  if not is_admin(access.data.id) then
    return 404
  end
  -- Valida si el usuario existe.
  local user = User:find_by_id(page.GET.id)
  if not user then
    return 404
  end
  user:delete()
  page:redirect('user/index')
end

return M
