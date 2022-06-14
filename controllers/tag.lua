local M = {}
local APP_URL = require 'conf.conf'.sailor.app_url
local access = require('sailor.access')
local Tag = require('sailor.model')('tag')
local Valua = require('valua')
local DB = require('sailor.db')

--- Lista todos los tags de un usuario.
function M.index(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  -- Obtiene el patrón de búsqueda.
  local search = page.POST.search
  if search then
    return page:redirect('tag/index', {search = search})
  end
  search = page.GET.search or ''
  -- Busca todos los tags de un usuario
  -- desde un patrón de búsqueda.
  DB.connect()
  local tags = Tag:find_all('user_id = '..access.data.id..
    " AND name LIKE '%"..DB.escape(search)..
    "%' ORDER BY name ASC"
  )
  DB.close()
  page.title = 'Tags'
  page:render('index', {tags = tags, search = search})
end

--- Modifica el nombre del tag de un usuario.
function M.update(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local id = access.data.id
  -- Valida si el tag es del usuario.
  local tag = Tag:find_by_attributes({
    id = page.GET.id,
    user_id  = id
  })
  if not tag then
    return 404
  end
  local saved
  if next(page.POST) then
    -- Obtiene los campos del formulario.
    tag:get_post(page.POST)
    -- Asegura que el usuario asociado
    -- al tag no se pueda modificar.
    tag.user_id = id
    -- Valida el nombre del tag.
    local val,err = Valua:new().not_empty().string().
      len(1,64).no_white()(tag.name)
    if tag.name then
      tag.name = tag.name:lower()
    end
    -- Valida si el nombre del tag es único.
    if val and Tag:find_by_attributes({
      user_id = id,
      name = tag.name
    })
    then
      err = 'tag name alredy exists'
    end
    tag.errors.name = err
    -- Desde el modelo valida los campos
    -- y modifica el nombre del tag.
    saved = not err and tag:update()
  end
  page.title = 'Update tag'
  page:render('update', {tag = tag, saved = saved})
end

--- Lista todos los marcadores del tag de un usuario.
function M.view(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  -- Valida si el tag es del usuario.
  local tag = Tag:find_by_attributes({
    id = page.GET.id,
    user_id = access.data.id
  })
  if not tag then
    return 404
  end
  page.title = tag.name
  page:render('view', {tag = tag})
end

--- Elimina el tag de un usuario.
function M.delete(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  -- Valida si el tag es del usuario.
  local tag = Tag:find_by_attributes({
    id = page.GET.id,
    user_id = access.data.id
  })
  if not tag then
    return 404
  end
  tag:delete()
  page:redirect('tag/index')
end

return M
