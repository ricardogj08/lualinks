<% local form = require 'sailor.form' %>
<article>
  <hgroup>
    <h1>Create a new user</h1>
    <h2>Create a new user account</h2>
  </hgroup>

  <% if saved == false then %>
    <small>There was an error while saving.</small>
  <% end %>

  <form method="post">
    <%= form.text(user, 'username', 'placeholder="Username" minlength="1" maxlength="64" required') %>
    <small><%= user.errors.username or '' %></small>

    <%= form.dropdown(user, 'role_id', roles, 'Please select a role...', 'required') %>
    <small><%= user.errors.role_id or '' %></small>

    <%= form.password(user, 'password', 'placeholder="Password" minlength="8" maxlength="64" required') %>
    <small><%= user.errors.password or '' %></small>

    <input type="password" name="confirm_password" placeholder="Confirm password" minlength="8" maxlength="64" required>

    <div class="grid">
      <input type="submit" value="Register">
      <a href="<%= page:make_url('user/index') %>"><input type="button" class="secondary" value="Cancel"></a>
    </div>
  </form>
</article>
