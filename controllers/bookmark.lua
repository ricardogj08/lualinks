local M = {}
local Bookmark = require 'sailor.model'('bookmark')
local Tag = require 'sailor.model'('tag')
local BookmarkTag = require 'sailor.model'('bookmark_tag')
local app_url = require 'conf.conf'.sailor.app_url
local valua = require 'valua'
local db = require 'sailor.db'
local utils = require 'web_utils.utils'
local requests = require 'requests'
local access = require 'sailor.access'

--- Valida los campos del formulario.
-- @bookmark Es una instancia del modelo bookmark.
-- @input Es una tabla con todos los campos a validar.
-- @return Una tabla de errores por cada campo.
local function validate_bookmark(bookmark,input)
  local err,val = {}
  if input.url then
    val,err.url = valua:new().not_empty().string()(bookmark.url)
    if val and Bookmark:find_by_attributes({
      user_id = bookmark.user_id,
      url = bookmark.url
    })
    then
      err.url = 'url alredy exists'
    end
  end
  if input.title then
    val,err.title = valua:new().not_empty().string()(bookmark.title)
  end
  return err
end

--- Valida los tags de un formulario.
-- @tags Es un array de nombres de tags.
-- @return Una tabla de errores.
local function validate_tags(tags)
  local err,val = {}
  for i=1,#tags do
    val,err.name = valua:new().not_empty().string().len(1, 64)(tags[i])
    if err.name then
      break
    end
  end
  return err
end

--- Obtiene una URL de respaldo de un sitio web desde archive.org
-- @url URL del sitio web.
-- @return Una URL desde archive.org o nil.
local function archive(url)
  local response = requests.get({
    'http://archive.org/wayback/available',
    params = {url = url},
    timeout = 3
  })
  local res = response.json()
  if res then
    res = res.archived_snapshots
    if next(res) then
      res = res.closest.url
    else
      res = nil
    end
  end
  return res
end

--- Lista todos los marcadores.
function M.index(page)
  page:enable_cors({allow_origin = app_url})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  -- Sistema de búsqueda.
  local search = page.POST.search
  if search then
    return page:redirect('bookmark/index', {search = search})
  end
  search = page.GET.search or ''
  -- Sistema de paginación.
  local p = tonumber(page.GET.page) or 1
  if p < 1 then
    if search == '' then
      return page:redirect('bookmark/index', {page = 1})
    end
    return page:redirect('bookmark/index', {search = search, page = 1})
  end
  local limit = 15
  local offset = limit * (p - 1)
  -- Búsqueda de marcadores.
  db.connect()
  local bookmarks = Bookmark:find_all('user_id = '..access.data.id..
    " AND (title LIKE '%"..db.escape(search)..
    "%' OR description LIKE '%"..db.escape(search)..
    "%') ORDER BY updated_at DESC LIMIT "..limit..' OFFSET '..offset)
  db.close()
  -- Sistema de paginación sin resultados.
  if not next(bookmarks) and p > 1 then
    if search == '' then
      return page:redirect('bookmark/index', {page = p - 1})
    end
    return page:redirect('bookmark/index', {search = search, page = p - 1})
  end
  page.title = 'Bookmarks'
  page:render('index', {bookmarks = bookmarks, search = search, p = p})
end

--- Registra un nuevo marcador.
function M.create(page)
  page:enable_cors({allow_origin = app_url})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local bookmark,tag,saved = Bookmark:new(),Tag:new()
  -- Valida si existe un campo del formulario.
  if next(page.POST) then
    -- Obtiene todos los campos del formulario.
    bookmark:get_post(page.POST)
    tag:get_post(page.POST)
    -- Valida todos los campos del formulario.
    bookmark.user_id = access.data.id
    bookmark.errors = validate_bookmark(bookmark, {url = true})
    -- Convierte los tags separados por espacios a un array.
    local tags = utils.split(tostring(tag.name or ''), "%s")
    tag.errors = validate_tags(tags)
    -- Define un backup del sitio web desde archive.org
    bookmark.archive = archive(bookmark.url)
    -- Desde el modelo valida todos los campos del formulario
    -- y registra un nuevo marcador.
    saved = not next(bookmark.errors) and not next(tag.errors) and bookmark:save()
    if saved then
      for i=1,#tags do
        tag = tag:find_by_attributes({name = tags[i], user_id = access.data.id})
        -- Registra un nuevo tag al usuario si no existe.
        if not tag then
          tag = Tag:new()
          tag.user_id,tag.name = access.data.id,tags[i]
          tag:save()
        end
        -- Asocia un tag al marcador del usuario.
        if tag and tag.id then
          local bookmark_tag = BookmarkTag:new()
          bookmark_tag.bookmark_id,bookmark_tag.tag_id = bookmark.id,tag.id
          bookmark_tag:save()
        end
      end
      return page:redirect('bookmark/index')
    end
  end
  page.title = 'Add bookmark'
  page:render('create', {bookmark = bookmark, tag = tag, saved = saved})
end

--- Modifica un marcador.
function M.update(page)
  page:enable_cors({allow_origin = app_url})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local id = page.GET.id
  local bookmark = Bookmark:find_by_attributes({id = id, user_id = access.data.id})
  if not bookmark then
    return 404
  end
  local tag,saved = Tag:new()
  if next(page.POST) then
    -- Obtiene todos los campos del formulario.
    bookmark:get_post(page.POST)
    tag:get_post(page.POST)
    local b = Bookmark:find_by_id(id)
     -- Valida solo los campos modificados.
    local input = {
      url = bookmark.url ~= b.url,
      title = bookmark.title ~= b.title
    }
    -- Valida todos los campos del formulario.
    bookmark.errors = validate_bookmark(bookmark, input)
    -- Convierte los tags separados por espacios a un array.
    local tags = utils.split(tostring(tag.name or ''), "%s")
    tag.errors = validate_tags(tags)
    -- Define un backup del sitio web desde archive.org
    bookmark.archive = archive(bookmark.url)
    -- Desde el modelo valida todos los campos del formulario
    -- y modifica los datos de un marcador.
    saved = not next(bookmark.errors) and bookmark:update()
    if not next(tag.errors) then
      local bookmark_tag
      for i=1,#tags do
        tag = Tag:find_by_attributes({name = tags[i], user_id = access.data.id})
        -- Registra un nuevo tag al usuario si no existe.
        if not tag then
          tag = Tag:new()
          tag.user_id,tag.name = access.data.id,tags[i]
          tag:save()
        end
        bookmark_tag = BookmarkTag:find_by_attributes({
          bookmark_id = bookmark.id, tag_id = tag.id
        })
        -- Asocia un tag al marcador del usuario si no existe.
        if not bookmark_tag then
          bookmark_tag = BookmarkTag:new()
          bookmark_tag.bookmark_id,bookmark_tag.tag_id = bookmark.id,tag.id
          bookmark_tag:save()
          saved = true
        end
      end
      -- Elimina la asociación de un tag a un marcador
      -- si no existe en el campo del formulario.
      for i=1,#bookmark.tags do
        if not valua:new().in_list(tags)(bookmark.tags[i].name) then
          bookmark_tag = BookmarkTag:find_by_attributes({
            bookmark_id = bookmark.id, tag_id = bookmark.tags[i].id
          })
          bookmark_tag:delete()
          saved = true
        end
      end
    end
    if saved then
      return page:redirect('bookmark/update', {id = id})
    end
  end
  -- Convierte un array de tags a un string.
  tag.name = ''
  for i=1,#bookmark.tags do
    tag.name = tag.name..' '..bookmark.tags[i].name
  end
  tag.name = tag.name:gsub("^%s+", "")
  page.title = 'Update bookmark'
  page:render('update', {bookmark = bookmark, tag = tag, saved = saved})
end

--- Elimina un marcador.
function M.delete(page)
  page:enable_cors({allow_origin = app_url})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local bookmark = Bookmark:find_by_attributes({
    id = page.GET.id, user_id = access.data.id
  })
  if bookmark then
    bookmark:delete()
    return page:redirect('bookmark/index')
  end
  return 404
end

return M
