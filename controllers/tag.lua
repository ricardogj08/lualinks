local M = {}
local Tag = require 'sailor.model'('tag')
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

function M.update(page)
  local tag = Tag:find_by_id(page.GET.id)
  if not tag then
    return 404
  end
  local saved
  if next(page.POST) then
    tag:get_post(page.POST)
    saved = tag:update()
    if saved then
      page:redirect('tag/index')
    end
  end
  page:render('update', {tag = tag, saved = saved})
end

function M.view(page)
  local tag = Tag:find_by_id(page.GET.id)
  if not tag then
    return 404
  end
  page:render('view', {tag = tag})
end

function M.delete(page)
  local tag = Tag:find_by_id(page.GET.id)
  if not tag then
    return 404
  end
  if tag:delete() then
    page:redirect('tag/index')
  end
end

return M
