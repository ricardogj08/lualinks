<% local form = require('sailor.form') %>
<form method="post">
  <label>Username:
    <%= form.text(user, 'username', 'placeholder="Username" maxlength="64" required') %>
    <small><%= user.errors.username or '' %></small>
  </label>

  <label>Role:
    <%= form.dropdown(user, 'role_id', roles, 'Please select a role...', 'required') %>
    <small><%= user.errors.role_id or '' %></small>
  </label>

  <label>Password:
    <%= form.password(user, 'password', 'placeholder="Password" minlength="8" maxlength="64"') %>
    <small><%= user.errors.password or '' %></small>
  </label>

  <label>Confirm password:
    <input type="password" name="confirm_password" placeholder="Confirm password" minlength="8" maxlength="64">
  </label>

  <div class="grid">
    <input type="submit" value="Save">
    <a href="<%= page:make_url('user/index') %>"><input type="button" class="secondary" value="Cancel"></a>
  </div>
</form>
