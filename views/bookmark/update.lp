<% local form = require 'sailor.form' %>
<article>
  <hgroup>
    <h1>Update bookmark</h1>
    <h2>Update bookmark information</h2>
  </hgroup>

  <% if saved == false then %>
    <small>The bookmark data was not changed.</small>
  <% end %>

  <form method="post">
    <label for="bookmark:url">URL:</label>
    <%= form.url(bookmark, 'url', 'placeholder="URL" maxlength="2048" required') %>
    <small><%= bookmark.errors.url or '' %></small>

    <label for="bookmark:title">Title:</label>
    <%= form.text(bookmark, 'title', 'placeholder="Title" maxlength="512" required') %>
    <small><%= bookmark.errors.title or '' %></small>

    <label for="tag:name">Tags:</label>
    <%= form.text(tag, 'name', 'placeholder="Tags (optional)"') %>
    <small><%= tag.errors.name or '' %></small>

    <label for="bookmark:description">Description:</label>
    <%= form.textarea(bookmark, 'description', 'placeholder="Description (optional)" maxlength="1024"') %>
    <small><%= bookmark.errors.description or '' %></small>

    <div class="grid">
      <input type="submit" value="Save" class="contrast">
      <a href="<%= page:make_url('bookmark/index') %>"><input type="button" class="secondary" value="Cancel"></a>
    </div>
  </form>
</article>
