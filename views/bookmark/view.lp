<h2>
  View bookmark #<%= bookmark.id %>
  <small>(<a href="<%= page:make_url('bookmark/update', {id = bookmark.id}) %>" >update</a>)</small>
  <small>(<a href="<%= page:make_url('bookmark/delete', {id = bookmark.id}) %>" >delete</a>)</small>
</h2>
<table class="table">
  <tr>
    <td>id</td>
    <td><%= bookmark.id %></td>
  </tr>
  <tr>
    <td>user_id</td>
    <td><%= bookmark.user_id %></td>
  </tr>
  <tr>
    <td>url</td>
    <td><%= bookmark.url %></td>
  </tr>
  <tr>
    <td>title</td>
    <td><%= bookmark.title %></td>
  </tr>
  <tr>
    <td>description</td>
    <td><%= bookmark.description %></td>
  </tr>
</table>
<br/>
<a href="<%= page:make_url('bookmark/index') %>"><- Back to View All</a>
