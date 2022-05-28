local M = {}
local Bookmark = require 'sailor.model'('bookmark')
local valua = require 'valua'
local db = require 'sailor.db'

function M.index(page)
  local bookmarks = Bookmark:find_all()
  page:render('index', {bookmarks = bookmarks})
end

function M.create(page)
  local bookmark = Bookmark:new()
  local saved
  if next(page.POST) then
    bookmark:get_post(page.POST)
    saved = bookmark:save()
    if saved then
      page:redirect('bookmark/index')
    end
  end
  page:render('create', {bookmark = bookmark, saved = saved})
end

function M.update(page)
  local bookmark = Bookmark:find_by_id(page.GET.id)
  if not bookmark then
    return 404
  end
  local saved
  if next(page.POST) then
    bookmark:get_post(page.POST)
    saved = bookmark:update()
    if saved then
      page:redirect('bookmark/index')
    end
  end
  page:render('update', {bookmark = bookmark, saved = saved})
end

function M.view(page)
  local bookmark = Bookmark:find_by_id(page.GET.id)
  if not bookmark then
    return 404
  end
  page:render('view', {bookmark = bookmark})
end

function M.delete(page)
  local bookmark = Bookmark:find_by_id(page.GET.id)
  if not bookmark then
    return 404
  end

  if bookmark:delete() then
    page:redirect('bookmark/index')
  end
end

return M
