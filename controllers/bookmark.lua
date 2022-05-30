local M = {}
local Bookmark = require 'sailor.model'('bookmark')
local Tag = require 'sailor.model'('tag')
local valua = require 'valua'
local db = require 'sailor.db'
local access = require 'sailor.access'

function M.index(page)
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local bookmarks = Bookmark:find_all()
  page.title = 'Bookmarks'
  page:render('index', {bookmarks = bookmarks})
end

function M.create(page)
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local bookmark = Bookmark:new()
  local tag = Tag:new()
  local saved
  if next(page.POST) then
    bookmark:get_post(page.POST)
    tag:get_post(page.POST)
    saved = bookmark:save()
    if saved then
      return page:redirect('bookmark/index')
    end
  end
  page:render('create', {bookmark = bookmark, tag = tag, saved = saved})
end

function M.update(page)
  if access.is_guest() then
    return page:redirect('user/login')
  end
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
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local bookmark = Bookmark:find_by_id(page.GET.id)
  if not bookmark then
    return 404
  end
  page:render('view', {bookmark = bookmark})
end

function M.delete(page)
  if access.is_guest() then
    return page:redirect('user/login')
  end
  local bookmark = Bookmark:find_by_id(page.GET.id)
  if not bookmark then
    return 404
  end

  if bookmark:delete() then
    page:redirect('bookmark/index')
  end
end

return M
