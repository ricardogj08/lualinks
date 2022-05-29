local M = {}
local User = require 'sailor.model'('user')
local Role = require 'sailor.model'('role')
local valua = require 'valua'
local db = require 'sailor.db'

--- Valida todos los campos del formulario.
-- @param user Instancia actual del modelo user.
-- @param page Objecto page del controlador.
-- @param input Tabla con todos los campos a validar.
-- @return Una tabla de errores por cada campo.
local function validate(user, page, input)
  local err = {}
  if input.username then
    if User:find_by_attributes({username = user.username}) then
      err.username = 'username alredy exists'
    end
  end
  if input.role_id then
    if not Role:find_by_id(user.role_id) then
      err.role_id = 'Invalid role id'
    end
  end
  if input.password then
    _, err.password = valua:new().not_empty().string().len(1, 64).
      no_white().compare(page.POST.confirm_password)(user.password)
  end
  return err
end

--- Obtiene todos los roles del sistema.
-- @return Un array de strings.
local function roles()
  local roles = {}
  for _, v in ipairs(Role:find_all()) do
    roles[v.id] = v.description
  end
  return roles
end

--- Lista todos los usuarios.
function M.index(page)
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
    -- Desde el modelo valida todos los campos del formulario
    -- y registra un nuevo usuario.
    saved = not next(user.errors) and user:save()
    if saved then
      return page:redirect('user/index')
    end
  end
  page.title = 'Create user'
  page:render('create', {user = user, saved = saved, roles = roles()})
end

--- Modifica los datos de un usuario.
function M.update(page)
  local id = page.GET.id
  local user = User:find_by_id(id)
  if not user then
    return 404
  end
  local saved
  -- Valida si existe un campo del formulario.
  if next(page.POST) then
    -- Elimina campos vacíos.
    for k, v in pairs(page.POST) do
      if v == '' then
        page.POST[k] = nil
      end
    end
    -- Obtiene todos los campos del formulario.
    user:get_post(page.POST)
    local u = User:find_by_id(id)
    local input = {}
    -- Valida solo los campos modificados.
    for k, v in pairs(user) do
      if u[k] ~= v then
        input[k] = true
      end
    end
    user.errors = validate(user, page, input)
    -- Desde el modelo valida todos los campos del formulario
    -- y modifica los datos de un usuario.
    saved = not next(user.errors) and user:update()
    if saved then
      return page:redirect('user/update', {id = id})
    end
  end
  user.password = nil
  page.title = 'Edit user'
  page:render('update', {user = user, saved = saved, roles = roles()})
end

--- Consulta los datos de un usuario.
function M.view(page)
  local user = User:find_by_id(page.GET.id)
  if user then
    page.title = user.username
    return page:render('view', {user = user})
  end
  return 404
end

--- Elimina un usuario.
function M.delete(page)
  local user = User:find_by_id(page.GET.id)
  if user then
    user:delete()
    return page:redirect('user/index')
  end
  return 404
end

return M