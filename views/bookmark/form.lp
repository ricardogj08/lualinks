<% local form = require('sailor.form') %>
<form method="post">
  <label>URL:
    <%= form.url(bookmark, 'url', 'placeholder="URL" maxlength="2048" required') %>
    <small><%= bookmark.errors.url or '' %></small>
  </label>

  <label>Title:
    <%= form.text(bookmark, 'title', 'placeholder="Title" maxlength="512" required') %>
    <small><%= bookmark.errors.title or '' %></small>
  </label>

  <label>Tags:
    <%= form.text(tag, 'name', 'placeholder="Tags (optional)"') %>
    <small><%= tag.errors.name or '' %></small>
  </label>

  <label>Description:
    <%= form.textarea(bookmark, 'description', 'placeholder="Description (optional)" maxlength="1024"') %>
    <small><%= bookmark.errors.description or '' %></small>
  </label>

  <div class="grid">
    <input type="submit" value="Save">
    <a href="<%= page:make_url('bookmark/index') %>"><input type="button" class="secondary" value="Cancel"></a>
  </div>
</form>
