<% local form = require 'sailor.form' %>
<article>
  <hgroup>
    <h1>Update tag</h1>
    <h2>Update tag name</h2>
  </hgroup>

  <% if saved == false then %>
    <small>The tag name was not changed.</small>
  <% end %>

  <form method="post">
    <%= form.text(tag, 'name', 'placeholder="Name" maxlength="64" required') %>
    <small><%= tag.errors.name or '' %></small>

    <div class="grid">
      <input type="submit" value="Save" class="contrast">
      <a href="<%= page:make_url('tag/view', {id = tag.id}) %>"><input type="button" class="secondary" value="Cancel"></a>
    </div>
  </form>

  <a href="<%= page:make_url('tag/delete', {id = tag.id}) %>" class="secondary"><small>Delete tag</small></a>
</article>
