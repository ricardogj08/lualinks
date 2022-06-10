local M = {}
local Tag = require 'sailor.model'('tag')
local valua = require 'valua'
local db = require 'sailor.db'
local access = require 'sailor.access'

--- Lista todos los tags.
function M.index(page)
  if access.is_guest() then
    return page:redirect('user/login')
  end
  -- Sistema de búsqueda.
  local search = page.POST.search
  if search then
    return page:redirect('tag/index', {search = search})
  end
  search = page.GET.search or ''
  -- Búsqueda de marcadores.
  db.connect()
  local tags = Tag:find_all('user_id = '..access.data.id..
    " AND name LIKE '%"..db.escape(search)..
    "%' ORDER BY name ASC")
  db.close()
  page.title = 'Tags'
  page:render('index', {tags = tags, search = search})
end

--- Modifica el nombre de un marcador.
function M.update(page)
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local tag = Tag:find_by_attributes({
    id = page.GET.id, user_id = access.data.id
  })
  if not tag then
    return 404
  end
  local saved
  -- Valida si existe un campo del formulario.
  if next(page.POST) then
    -- Obtiene todos los campos del formulario.
    tag:get_post(page.POST)
    tag.user_id = access.data.id
    local val
    val,tag.errors.name = valua:new().not_empty().string().
      len(1, 64).no_white()(tag.name)
    -- Valida si el nombre del tag es único.
    if val and Tag:find_by_attributes({
      user_id = access.data.id, name = tag.name
    })
    then
      tag.errors.name = 'tag name alredy exists'
    end
    -- Desde el modelo valida todos los campos del formulario
    -- y modifica los datos del marcador.
    saved = not next(tag.errors) and tag:update()
    if saved then
      return page:redirect('tag/update', {id = tag.id})
    end
  end
  page:render('update', {tag = tag, saved = saved})
end

--- Consulta los marcadores de un tag.
function M.view(page)
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local tag = Tag:find_by_attributes({
    id = page.GET.id, user_id = access.data.id
  })
  if tag then
    page.title = tag.name
    return page:render('view', {tag = tag})
  end
  return 404
end

--- Elimina un tag.
function M.delete(page)
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local tag = Tag:find_by_attributes({
    id = page.GET.id, user_id = access.data.id
  })
  if tag then
    tag:delete()
    return page:redirect('tag/index')
  end
  return 404
end

return M
