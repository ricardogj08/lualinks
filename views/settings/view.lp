<% local form = require 'sailor.form' %>
<article>
  <hgroup>
    <h1>Profile</h1>
    <h2>Edit your profile</h2>
  </hgroup>

  <% if saved == false then %>
    <p><small>The profile data was not changed.</small></p>
  <% end %>

  <form method="post">
    <label>Username:
      <%= form.text(user, 'username', 'placeholder="Username" maxlength="64" required') %>
      <small><%= user.errors.username or '' %></small>
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
      <a href="<%= page:make_url('bookmark/index') %>"><input type="button" class="secondary" value="Cancel"></a>
    </div>

    <a href="<%= page:make_url('settings/delete') %>" class="secondary"><small>Delete my account</small></a>
  </form>
</article>
