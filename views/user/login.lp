<% local form = require 'sailor.form' %>
<article>
  <hgroup>
    <h1>Login</h1>
    <h2>Please login to your account</h2>
  </hgroup>

  <% if auth.status == false then %>
    <p><small><%= auth.err %></small></p>
  <% end %>

  <form method="post">
    <%= form.text(user, 'username', 'placeholder="Username" required') %>
    <%= form.password(user, 'password', 'placeholder="Password" required') %>
    <input type="submit" value="Login" class="contrast">
  </form>
</article>
