<% local form = require 'sailor.form' %>
<article>
  <hgroup>
    <h1>Edit user</h1>
    <h2>Edit user account information</h2>
  </hgroup>

  <% if saved == false then %>
    <small>The user data was not changed.</small>
  <% end %>

  <form method="post">
    <%= form.text(user, 'username', 'placeholder="Username" minlength="1" maxlength="64" required') %>
    <small><%= user.errors.username or '' %></small>

    <%= form.dropdown(user, 'role_id', roles, 'Please select a role...', 'required') %>
    <small><%= user.errors.role_id or '' %></small>

    <%= form.password(user, 'password', 'placeholder="Password" minlength="8" maxlength="64"') %>
    <small><%= user.errors.password or '' %></small>

    <input type="password" name="confirm_password" placeholder="Confirm password" minlength="8" maxlength="64">

    <div class="grid">
      <input type="submit" value="Save">
      <a href="<%= page:make_url('user/index') %>"><input type="button" class="secondary" value="Cancel"></a>
    </div>
  </form>
</article>
