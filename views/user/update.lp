<article>
  <hgroup>
    <h1>Update user</h1>
    <h2>Update user account information</h2>
  </hgroup>

  <% if saved == false then %>
    <p><small>The user data was not changed.</small></p>
  <% end %>

  <% page:include('/views/user/form', {user = user}) %>
</article>
