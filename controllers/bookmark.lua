local M = {}
local APP_URL = require 'conf.conf'.sailor.app_url
local access = require('sailor.access')
local Bookmark = require('sailor.model')('bookmark')
local Tag = require('sailor.model')('tag')
local Bookmark_Tag = require('sailor.model')('bookmark_tag')
local Valua = require('valua')
local DB = require('sailor.db')
local utils = require('web_utils.utils')
local requests = require('requests')

--- Valida los campos de un formulario.
-- @param bookmark object: Instancia del modelo bookmark.
-- @param input table: Una tabla con todos los campos a validar.
-- @return table: Una tabla de errores por cada campo.
local function validate_bookmark(bookmark,input)
  local err,val = {}
  if input.url then
    val,err.url = Valua:new().not_empty().string().
      len(1,2048).no_white()(bookmark.url)
    if val and Bookmark:find_by_attributes({
      user_id = bookmark.user_id,
      url = bookmark.url
    })
    then
      err.url = 'url alredy exists'
    end
  end
  if input.title then
    val,err.title = Valua:new().not_empty().
      string().len(1,512)(bookmark.title)
  end
  return err
end

--- Valida los tags de un formulario.
-- @param tags table: Una tabla con nombres de tags.
-- @return table: Una tabla de errores para el campo name.
local function validate_tags(tags)
  local err,val = {}
  for i=1,#tags do
    val,err.name = Valua:new().not_empty().
      string().len(1,64).no_white()(tags[i])
    if err.name then
      break
    end
  end
  return err
end

--- Consulta el snapshot de un sitio web desde archive.org
-- @param url string: URL del sitio web.
-- @return string or nil: Una URL desde archive.org
local function archive(url)
  local res = requests.get({
    'http://archive.org/wayback/available',
    params = {url = url},
    timeout = 3
  })
  res = res.json()
  if res then
    res = res.archived_snapshots
    res = next(res) and res.closest.url or nil
  end
  return res
end

--- Lista todos los marcadores de un usuario.
function M.index(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  -- Obtiene el patrón de búsqueda.
  local search = page.POST.search
  if search then
    return page:redirect('bookmark/index', {search = search})
  end
  search = page.GET.search or ''
  -- Obtiene el número de paginación.
  local index = tonumber(page.GET.index) or 1
  if index < 1 then
    if search == '' then
      return page:redirect('bookmark/index', {index = 1})
    end
    return page:redirect('bookmark/index', {search = search, index = 1})
  end
  local limit = 15
  local offset = limit * (index - 1)
  -- Busca todos los marcadores de un usuario
  -- desde un patrón de búsqueda.
  DB.connect()
  local bookmarks = Bookmark:find_all('user_id = '..access.data.id..
    " AND (title LIKE '%"..DB.escape(search)..
    "%' OR description LIKE '%"..DB.escape(search)..
    "%') ORDER BY updated_at DESC LIMIT "..limit..' OFFSET '..offset
  )
  DB.close()
  -- Valida la paginación cuando no hay resultados.
  if not next(bookmarks) and index > 1 then
    if search == '' then
      return page:redirect('bookmark/index', {index = index - 1})
    end
    return page:redirect('bookmark/index', {search = search, index = index - 1})
  end
  page.title = 'Bookmarks'
  page:render('index', {bookmarks = bookmarks, search = search, index = index})
end

--- Registra un nuevo marcador.
function M.create(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local bookmark = Bookmark:new()
  local tag,saved = Tag:new()
  if next(page.POST) then
    local user_id = access.data.id
    -- Obtiene los campos del formulario.
    bookmark:get_post(page.POST)
    tag:get_post(page.POST)
    bookmark.user_id = user_id
    -- valida los campos del formulario.
    local err = validate_bookmark(bookmark, {url = true})
    -- Convierte los tags separados por espacios a una tabla.
    local tags = utils.split(tostring(tag.name or ''):lower(), "%s")
    local terr = validate_tags(tags)
    -- Consulta un backup del sitio web desde archive.org
    if not err.url then
      bookmark.archive = archive(bookmark.url)
    end
    bookmark.errors = err
    tag.errors = terr
    -- Desde el modelo valida los campos
    -- y registra un nuevo marcador.
    saved = not next(err) and not next(terr) and bookmark:save()
    if saved then
      local bm_tag
      for _,t in ipairs(tags) do
        tag = Tag:find_by_attributes({name = t, user_id = user_id})
        -- Registra nuevos tags si no existen.
        if not tag then
          tag = Tag:new()
          tag.name,tag.user_id = t,user_id
          tag:save()
        end
        -- Asocia un tag al marcador.
        if tag.id then
          bm_tag = Bookmark_Tag:new()
          bm_tag.bookmark_id,bm_tag.tag_id = bookmark.id,tag.id
          bm_tag:save()
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
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  -- Valida si el marcador existe.
  local id,user_id = tonumber(page.GET.id),access.data.id
  local bookmark = Bookmark:find_by_attributes({id = id, user_id = user_id})
  if not bookmark then
    return 404
  end
  local tag,saved = Tag:new()
  if next(page.POST) then
    -- Obtiene los campos del formulario.
    bookmark:get_post(page.POST)
    tag:get_post(page.POST)
    local bm = Bookmark:find_by_id(id)
    -- Asegura que el id del usuario no se pueda modificar.
    bookmark.user_id = bm.user_id
    -- Valida solo los campos modificados.
    local input = {
      url = bookmark.url ~= bm.url,
      title = bookmark.title ~= bm.title
    }
    local err = validate_bookmark(bookmark,input)
    -- Convierte los tags separados por espacios a una tabla.
    local tags = utils.split(tostring(tag.name or ''):lower(), "%s")
    local terr = validate_tags(tags)
    -- Actualiza el backup de archive.org
    if not err.url then
      bookmark.archive = archive(bookmark.url)
    end
    bookmark.errors = err
    tag.errors = terr
    -- Desde el modelo valida los campos
    -- y modfica los datos de un marcador.
    saved = not next(err) and bookmark:update()
    terr = not next(terr)
    -- Valida si los tags de un marcador se modifican.
    if terr then
      if #tags ~= #bookmark.tags then
        saved = true
      else
        for _,t in ipairs(bookmark.tags) do
          if not Valua:new().in_list(tags)(t.name) then
            saved = true
            break
          end
        end
      end
    end
    if terr and saved then
      local bm_tag
      for _,t in ipairs(tags) do
        tag = Tag:find_by_attributes({name = t, user_id = user_id})
        -- Registra nuevos tags si no existen.
        if not tag then
          tag = Tag:new()
          tag.name,tag.user_id = t,user_id
          tag:save()
        end
        -- Asocia un tag al marcador si no existe.
        bm_tag = Bookmark_Tag:find_by_attributes({
          bookmark_id = id,
          tag_id = tag.id
        })
        if not bm_tag then
          bm_tag = Bookmark_Tag:new()
          bm_tag.bookmark_id,bm_tag.tag_id = id,tag.id
          bm_tag:save()
        end
      end
      -- Elimina la asociación de un tag al marcardor
      -- si no existe en el campo del formulario.
      local old = bookmark.tags
      for i,t in ipairs(old) do
        if not Valua:new().in_list(tags)(t.name) then
          bm_tag = Bookmark_Tag:find_by_attributes({
            bookmark_id = id,
            tag_id = t.id
          })
          bm_tag:delete()
        end
      end
      if saved then
        return page:redirect('bookmark/update', {id = id})
      end
    end
  end
  -- Convierte un array de tags a un string.
  tag.name = ''
  for _,t in ipairs(bookmark.tags) do
    tag.name = tag.name..' '..t.name
  end
  tag.name = tag.name:gsub("^%s+", "")
  page.title = 'Update bookmark'
  page:render('update', {bookmark = bookmark, tag = tag, saved = saved})
end

--- Elimina un marcador.
function M.delete(page)
  page:enable_cors({allow_origin = APP_URL})
  if access.is_guest() then
    return page:redirect('user/login')
  end
  -- Valida si el marcador es del usuario.
  local bookmark = Bookmark:find_by_attributes({
    id = page.GET.id,
    user_id = access.data.id
  })
  if not bookmark then
    return 404
  end
  bookmark:delete()
  page:redirect('bookmark/index')
end

return M
