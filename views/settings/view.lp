<% local form = require 'sailor.form' %>
<article>
  <hgroup>
    <h1>Profile</h1>
    <h2>Edit your profile</h2>
  </hgroup>

  <% if saved == false then %>
    <small>The profile data was not changed.</small>
  <% end %>

  <form method="post">
    <label for="user:username">Username:</label>
    <%= form.text(user, 'username', 'placeholder="Username" maxlength="64" required') %>
    <small><%= user.errors.username or '' %></small>

    <label for="user:password">Password:</label>
    <%= form.password(user, 'password', 'placeholder="Password" minlength="8" maxlength="64"') %>
    <small><%= user.errors.password or '' %></small>

    <label for="confirm_password">Confirm password:</label>
    <input type="password" name="confirm_password" id="confirm_password" placeholder="Confirm password" minlength="8" maxlength="64">

    <div class="grid">
      <input type="submit" value="Save" class="contrast">
      <a href="<%= page:make_url('bookmark/index') %>"><input type="button" class="secondary" value="Cancel"></a>
    </div>
  </form>

  <a href="<%= page:make_url('settings/delete') %>" class="secondary"><small>Delete my account</small></a>
</article>
