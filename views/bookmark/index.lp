<style>
  .table td {
  cursor: pointer;
  }
</style>
<h2>View all</h2>
<table class="table">
  <tr>
    <th>id</th>
    <th>user_id</th>
    <th>url</th>
    <th>title</th>
    <th>description</th>
  </tr>
  <?lua for k,v in pairs(bookmarks) do ?>
  <tr onclick="location.href='<%= page:make_url('bookmark/view', {id = v.id}) %>'">
    <td><%= v.id %></td>
    <td><%= v.user_id %></td>
    <td><%= v.url %></td>
    <td><%= v.title %></td>
    <td><%= v.description %></td>
  </tr>
  <?lua end ?>
</table>
<br/>
<a href="<%= page:make_url('bookmark/create') %>" class="btn btn-primary">Create new bookmark</a>
