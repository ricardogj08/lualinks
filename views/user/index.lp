<style>
  .table td, tbody th {
    cursor: pointer;
  }
</style>
<section>
  <hgroup>
    <h1>Users</h1>
    <h2>View all user accounts</h2>
  </hgroup>

  <% page:include('/views/incs/search', {controller = 'user', search = search, maxlength = 64}) %>

  <p>
    <a href="<%= page:make_url('user/create') %>" role="button">&plus; Create user</a>
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
      <% for _,v in ipairs(users) do %>
        <tr onclick="location.href='<%= page:make_url('user/view', {id = v.id}) %>'">
          <th scope="row">&num;<%= v.id %></th>
          <td><%= v.username %></td>
          <td><%= v.role.description %></td>
        </tr>
      <% end %>
    </tbody>
  </table>

  <% page:include('/views/incs/pagination', {controller = 'user', search = search, p = p}) %>
</section>
