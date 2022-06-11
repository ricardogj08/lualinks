<article>
  <hgroup>
    <h1>Create user</h1>
    <h2>Create a new user account</h2>
  </hgroup>

  <% if saved == false then %>
    <p><small>There was an error while saving.</small></p>
  <% end %>

  <% page:include('/views/user/form', {user = user, roles = roles}) %>
</article>
