<% local form = require('sailor.form') %>
<section>
  <hgroup>
    <h1>Update tag</h1>
    <h2>Update tag name</h2>
  </hgroup>

  <% if saved == false then %>
    <p><small>The tag name was not changed.</small></p>
  <% end %>

  <form method="post">
    <label>Name:
      <%= form.text(tag, 'name', 'placeholder="Name" maxlength="64" required') %>
      <small><%= tag.errors.name or '' %></small>
    </label>

    <div class="grid">
      <input type="submit" value="Save" class="">
      <a href="<%= page:make_url('tag/view', {id = tag.id}) %>">
        <input type="button" class="secondary" value="Cancel">
      </a>
    </div>

    <% page:include('/views/incs/modal', {title = 'Delete this tag', msg = 'Are you sure you want to delete this tag?', route = page:make_url('tag/delete', {id = tag.id})}) %>
  </form>
</section>
