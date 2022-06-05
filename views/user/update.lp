<% local form = require 'sailor.form' %>
<article>
  <hgroup>
    <h1>Update user</h1>
    <h2>Update user account information</h2>
  </hgroup>

  <% if saved == false then %>
    <small>The user data was not changed.</small>
  <% end %>

  <form method="post">
    <label for="user:username">Username:</label>
    <%= form.text(user, 'username', 'placeholder="Username" maxlength="64" required') %>
    <small><%= user.errors.username or '' %></small>

    <label for="user:role_id">Role:</label>
    <%= form.dropdown(user, 'role_id', roles, 'Please select a role...', 'required') %>
    <small><%= user.errors.role_id or '' %></small>

    <label for="user:password">Password:</label>
    <%= form.password(user, 'password', 'placeholder="Password" minlength="8" maxlength="64"') %>
    <small><%= user.errors.password or '' %></small>

    <label for="confirm_password">Confirm password:</label>
    <input type="password" name="confirm_password" id="confirm_password" placeholder="Confirm password" minlength="8" maxlength="64">

    <div class="grid">
      <input type="submit" value="Save" class="contrast">
      <a href="<%= page:make_url('user/index') %>"><input type="button" class="secondary" value="Cancel"></a>
    </div>
  </form>
</article>
