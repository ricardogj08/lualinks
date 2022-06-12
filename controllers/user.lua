local M = {}
local User = require 'sailor.model'('user')
local Role = require 'sailor.model'('role')
local app_url = require 'conf.conf'.sailor.app_url
local valua = require 'valua'
local db = require 'sailor.db'
local access = require 'sailor.access'

--- Valida si el usuario de sesión es administrador.
local function is_admin(id)
  local user = User:find_by_id(id)
  return user.role.name == 'admin'
end

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
  if input.role_id then
    val,err.role_id = valua:new().not_empty().integer()(user.role_id)
    if val and not Role:find_by_id(user.role_id) then
      err.role_id = 'Invalid role id'
    end
  end
  if input.password or input.username then
    val,err.password = valua:new().not_empty().string().len(1, 64).
      no_white().compare(page.POST.confirm_password)(user.password)
  end
  return err
end

--- Obtiene todos los roles del sistema.
-- @return Un array de strings.
local function roles()
  local roles = {}
  for _,v in ipairs(Role:find_all()) do
    roles[v.id] = v.description
  end
  return roles
end

--- Inicio de sesión.
function M.login(page)
  page:enable_cors({allow_origin = app_url})
  if not access.is_guest() then
    return page:redirect('bookmark/index')
  end
  local user,auth = User:new(),{}
  -- Valida si existe un campo del formulario.
  if next(page.POST) then
    access.settings({model = 'user'})
    user:get_post(page.POST)
    -- Credenciales de acceso.
    auth.status,auth.err = access.login(user.username or '', user.password or '')
    if auth.status then
      return page:redirect('bookmark/index')
    end
  end
  page:render('login', {user = user, auth = auth})
end

--- Cierre de sesión.
function M.logout(page)
  page:enable_cors({allow_origin = app_url})
  access.logout()
  page:redirect('user/login')
end

--- Lista todos los usuarios.
function M.index(page)
  page:enable_cors({allow_origin = app_url})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  if not is_admin(access.data.id) then
    return 404
  end
  -- Sistema de búsqueda.
  local search = page.POST.search
  if search then
    return page:redirect('user/index', {search = search})
  end
  search = page.GET.search or ''
  -- Sistema de paginación.
  local p = tonumber(page.GET.page) or 1
  if p < 1 then
    if search == '' then
      return page:redirect('user/index', {page = 1})
    end
    return page:redirect('user/index', {search = search, page = 1})
  end
  local limit = 15
  local offset = limit * (p - 1)
  -- Búsqueda de usuarios.
  db.connect()
  local users = User:find_all("username LIKE '%"..db.escape(search)..
    "%' ORDER BY id LIMIT "..limit..' OFFSET '..offset)
  db.close()
  -- Sistema de paginación sin resultados.
  if not next(users) and p > 1 then
    if search == '' then
      return page:redirect('user/index', {page = p - 1})
    end
    return page:redirect('user/index', {search = search, page = p - 1})
  end
  page.title = 'Users'
  page:render('index', {users = users, search = search, p = p})
end

--- Registra un nuevo usuario.
function M.create(page)
  page:enable_cors({allow_origin = app_url})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  if not is_admin(access.data.id) then
    return 404
  end
  local user = User:new()
  local saved
  -- Valida si existe un campo del formulario.
  if next(page.POST) then
    -- Obtiene todos los campos del formulario.
    user:get_post(page.POST)
    -- Valida todos los campos del formulario.
    user.errors = validate(user, page, {
      username = true, role_id = true, password = true
    })
    if not next(user.errors) then
      -- Cifra la contraseña.
      user.password = access.hash(user.username, user.password)
      -- Desde el modelo valida todos los campos del formulario
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
  page:enable_cors({allow_origin = app_url})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  if not is_admin(access.data.id) then
    return 404
  end
  local id = page.GET.id
  local user = User:find_by_id(id)
  if not user then
    return 404
  end
  local saved
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
    local u = User:find_by_id(id)
    local input = {}
    -- Valida solo los campos modificados.
    for k,v in pairs(user) do
      if u[k] ~= v then
        input[k] = true
      end
    end
    user.errors = validate(user, page, input)
    -- Cifra la contraseña.
    if user.errors.password and input.username then
      user.errors.password = 'Please confirm o set a new password'
    end
    saved = not next(user.errors)
    if input.password and saved then
      user.password = access.hash(user.username, user.password)
    end
    -- Desde el modelo valida todos los campos del formulario
    -- y modifica los datos de un usuario.
    saved = saved and user:update()
    if saved then
      return page:redirect('user/update', {id = id})
    end
  end
  user.password = nil
  page.title = 'Update user'
  page:render('update', {user = user, saved = saved, roles = roles()})
end

--- Consulta los datos de un usuario.
function M.view(page)
  page:enable_cors({allow_origin = app_url})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  if not is_admin(access.data.id) then
    return 404
  end
  local user = User:find_by_id(page.GET.id)
  if user then
    page.title = user.username
    return page:render('view', {user = user})
  end
  return 404
end

--- Elimina un usuario.
function M.delete(page)
  page:enable_cors({allow_origin = app_url})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  if not is_admin(access.data.id) then
    return 404
  end
  local user = User:find_by_id(page.GET.id)
  if user then
    user:delete()
    return page:redirect('user/index')
  end
  return 404
end

return M
