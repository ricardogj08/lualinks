<style>
  .table td, tbody th {
    cursor: pointer;
  }
</style>
<section>
  <hgroup>
    <h1>Users</h1>
    <h2>List all user accounts</h2>
  </hgroup>

  <form>
    <input type="search" name="search" placeholder="Search" autofocus>
  </form>

  <p>
    <a href="<%= page:make_url('user/create') %>" role="button">&plus; Create a new user</a>
  </p>

  <table role="grid" class="table">
    <thead>
      <tr>
        <th scope="col">ID</th>
        <th scope="col">Username</th>
        <th scope="col">Role</th>
      </tr>
    </thead>
    <tbody>
      <% for k, v in pairs(users) do %>
        <tr onclick="location.href='<%= page:make_url('user/view',{id = v.id}) %>'">
          <th scope="row"><%= v.id %></th>
          <td><%= v.username %></td>
          <td><%= v.role.description %></td>
        </tr>
      <% end %>
    </tbody>
  </table>
</section>
