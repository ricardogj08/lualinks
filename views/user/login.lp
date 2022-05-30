<% local form = require 'sailor.form' %>
<article>
  <hgroup>
    <h1>Login</h1>
    <h2>Heading 2</h2>
  </hgroup>

  <% if auth.status == false then %>
    <small><%= auth.err %></small>
  <% end %>

  <form method="post">
    <%= form.text(user, 'username', 'placeholder="Username" maxlength="64" required') %>
    <%= form.password(user, 'password', 'placeholder="Password" minlength="8" required') %>
    <input type="submit" value="Login" class="contrast">
  </form>
</article>
