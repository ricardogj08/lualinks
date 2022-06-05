local M = {}
local Bookmark = require 'sailor.model'('bookmark')
local Tag = require 'sailor.model'('tag')
local BookmarkTag = require 'sailor.model'('bookmark_tag')
local valua = require 'valua'
local db = require 'sailor.db'
local utils = require 'web_utils.utils'
local access = require 'sailor.access'
local session = require 'sailor.session'
session.open(require 'sailor'.r)
session = session.data

--- Valida si una URL es permitida.
-- @param model Instancia actual del modelo bookmark.
-- @return Una tabla de errores.
local function validate_bookmark(bookmark)
  local val
  local err = {}
  val, err.url = valua:new().not_empty().string()(bookmark.url)
  if val and Bookmark:find_by_attributes({user_id = bookmark.user_id, url = bookmark.url}) then
    err.url = 'url alredy exists'
  end
  return err
end

--- Valida los tags de un formulario.
-- @param tags Un array de nombres de tags.
-- @return Una tabla de errores.
local function validate_tags(tags)
  local val
  local err = {}
  for _, v in ipairs(tags) do
    val, err.name = valua:new().not_empty().string().len(1, 64)(v)
    if err.name then
      break
    end
  end
  return err
end

--- Lista todos los marcadores.
function M.index(page)
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
  local bookmarks = Bookmark:find_all('user_id = '..session.id..
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
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local bookmark = Bookmark:new()
  local tag = Tag:new()
  local saved
  -- Valida si existe un campo del formulario.
  if next(page.POST) then
    -- Obtiene todos los campos del formulario.
    bookmark:get_post(page.POST)
    tag:get_post(page.POST)
    -- Valida todos los campos del formulario.
    bookmark.user_id = session.id
    bookmark.errors = validate_bookmark(bookmark)
    -- Convierte los tags separados por espacios a un array.
    local tags = utils.split(tostring(tag.name or ''), "%s")
    tag.errors = validate_tags(tags)
    -- Desde el modelo valida todos los campos del formulario
    -- y registra un nuevo marcador.
    saved = not next(bookmark.errors) and not next(tag.errors) and bookmark:save()
    if saved then
      for _, v in ipairs(tags) do
        tag = tag:find_by_attributes({name = v, user_id = session.id})
        -- Registra un nuevo tag si no existe.
        if not tag then
          tag = Tag:new()
          tag.name = v
          tag.user_id = session.id
          tag:save()
        end
        -- Asocia un tag al marcador.
        if tag and tag.id then
          local bookmark_tag = BookmarkTag:new()
          bookmark_tag.bookmark_id = bookmark.id
          bookmark_tag.tag_id = tag.id
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
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local bookmark = Bookmark:find_by_attributes({id = page.GET.id, user_id = session.id})
  if not bookmark then
    return 404
  end
  local tag = Tag:new()
  local saved
  if next(page.POST) then
    -- Elimina campos vacíos.
    for k, v in pairs(page.POST) do
      if v == '' then
        page.POST[k] = nil
      end
    end
    -- Obtiene todos los campos del formulario.
    bookmark:get_post(page.POST)
    tag:get_post(page.POST)
    -- Convierte los tags separados por espacios a un array.
    local tags = utils.split(tostring(tag.name or ''), "%s")
    tag.errors = validate_tags(tags)
    --saved = not next(bookmark.errors) and not next(tag.errors) and bookmark:update()
    if saved then
      page:redirect('bookmark/index')
    end
  end
  -- Convierte un array de tags a un string.
  tag.name = ''
  for _, v in ipairs(bookmark.tags) do
    tag.name = tag.name..' '..v.name
  end
  tag.name = tag.name:gsub("^%s+", "")
  page.title = 'Update bookmark'
  page:render('update', {bookmark = bookmark, tag = tag, saved = saved})
end

--- Elimina un marcador.
function M.delete(page)
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local bookmark = Bookmark:find_by_attributes({id = page.GET.id, user_id = session.id})
  if not bookmark then
    return 404
  end
  if bookmark:delete() then
    page:redirect('bookmark/index')
  end
end

return M
