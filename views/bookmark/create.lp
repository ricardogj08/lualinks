<?lua local form = require 'sailor.form' ?>
<article>
  <hgroup>
    <h1>Add bookmark</h1>
    <h2>Add a new bookmark</h2>
  </hgroup>

  <% if saved == false then %>
    <small>There was an error while saving.</small>
  <% end %>

  <form method="post">
    <%= form.url(bookmark, 'url', 'placeholder="URL" maxlength="2048" required') %>
    <small><%= bookmark.errors.url or '' %></small>

    <%= form.text(bookmark, 'title', 'placeholder="Title" maxlength="512" required') %>
    <small><%= bookmark.errors.title or '' %></small>

    <%= form.text(tag, 'name', 'placeholder="Tags (optional)"') %>
    <small><%= tag.errors.name or '' %></small>

    <%= form.textarea(bookmark, 'description', 'placeholder="Description (optional)" maxlength="1024"') %>
    <small><%= bookmark.errors.description or '' %></small>

    <div class="grid">
      <input type="submit" value="Save" class="contrast">
      <a href="<%= page:make_url('bookmark/index') %>"><input type="button" class="secondary" value="Cancel"></a>
    </div>
  </form>
</article>
