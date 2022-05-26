<style>
  .table td {
    cursor: pointer;
  }
</style>
<h2>View all</h2>
<table class="table">
  <tr>
    <th>id</th>
    <th>username</th>
    <th>role_id</th>
    <th>password</th>
  </tr>
  <?lua for k,v in pairs(users) do ?>
    <tr onclick="location.href='<%= page:make_url('user/view',{id = v.id}) %>'" >
      <td> <%= v.id %> </td>
      <td> <%= v.username %> </td>
      <td> <%= v.role_id %> </td>
      <td> <%= v.password %> </td>
    </tr>
  <?lua end ?>
</table>
<br/>
<a href="<%= page:make_url('user/create') %>" class="btn btn-primary">Create new user</a>
