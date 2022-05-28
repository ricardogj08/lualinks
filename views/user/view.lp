<section>
  <hgroup>
    <h1><%= user.username %></h1>
    <h2>View user account information</h2>
  </hgroup>

  <p>
    <a href="<%= page:make_url('user/index') %>" role="button">&lt; Back to users</a>
  </p>

  <table>
    <tbody>
      <tr>
        <th scope="row">ID</th>
        <td><%= user.id %></td>
      </tr>
      <tr>
        <th scope="row">Username</th>
        <td><%= user.username %></td>
      </tr>
      <tr>
        <th scope="row">Rol</th>
        <td><%= user.role.description %></td>
      </tr>
      <tr>
        <th scope="row">Created at</th>
        <td><%= user.created_at %></td>
      </tr>
      <tr>
        <th scope="row">Updated at</th>
        <td><%= user.updated_at %></td>
      </tr>
    </tbody>
  </table>

  <p>
    <a href="<%= page:make_url('user/delete', {id = user.id}) %>" role="button" class="contrast">Delete</a>
    <a href="<%= page:make_url('user/update', {id = user.id}) %>" role="button" class="secondary">Update</a>
  </p>
</section>
