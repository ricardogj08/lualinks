local M = {}
local User = require "sailor.model"("user")
local Role = require "sailor.model"("role")
local valua = require "valua"

--- Valida todos los campos del formulario.
-- @param user Instancia actual del modelo user.
-- @param page Objecto page del controlador.
-- @param input Tabla con todos los campos a validar.
-- @return Una tabla de errores por cada campo.
local function validate(user, page, input)
  err = {}
  if input.username then
    if User:find_by_attributes({username = user.username}) then
      err.username = "username alredy exists"
    end
  end
  if input.role_id then
    if not Role:find_by_id(user.role_id) then
      err.role_id = "Invalid role id"
    end
  end
  if input.password then
    _, err.password = valua:new().not_empty().string().len(1, 64).
      no_white().compare(page.POST.pass2)(user.password)
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
  local users = require "sailor.model"("user"):find_all()
  page:render("index", {users = users})
end

--- Registra un nuevo usuario.
function M.create(page)
  local user = User:new()
  local saved
  -- Valida si existen los campos del formulario.
  if next(page.POST) then
    -- Obtiene todos los campos del formulario.
    user:get_post(page.POST)
    user.errors = validate(user, page, {
      username = true,
      role_id  = true,
      password = true
    })
    -- Desde el modelo valida todos los campos del formulario
    -- y registra un nuevo usuario.
    saved = not next(user.errors) and user:save()
    if saved then
      page:redirect("user/index")
    end
  end
  page:render("create", {user = user, saved = saved, roles = roles()})
end

--- Modifica los datos de un usuario.
function M.update(page)
  local user = require "sailor.model"("user"):find_by_id(page.GET.id)
  if not user then
    return 404
  end
  local saved
  if next(page.POST) then
    user:get_post(page.POST)
    saved = user:update()
    if saved then
      page:redirect("user/index")
    end
  end
  page:render("update", {user = user, saved = saved})
end

--- Consulta los datos de un usuario.
function M.view(page)
  local user = require "sailor.model"("user"):find_by_id(page.GET.id)
  if not user then
    return 404
  end
  page:render("view", {user = user})
end

--- Elimina un usuario.
function M.delete(page)
  local user = require "sailor.model"("user"):find_by_id(page.GET.id)
  if not user then
    return 404
  end

  if user:delete() then
    page:redirect("user/index")
  end
end

return M
