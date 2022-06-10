<h2>
  View tag #<%= tag.id %>
  <small>(<a href="<%= page:make_url('tag/update', {id = tag.id} ) %>" >update</a>)</small>
  <small>(<a href="<%= page:make_url('tag/delete', {id = tag.id} ) %>" >delete</a>)</small>
</h2>
<table class="table">
  <tr>
    <td>id</td>
    <td><%= tag.id %></td>
  </tr>
  <tr>
    <td>name</td>
    <td><%= tag.name %></td>
  </tr>
  <tr>
    <td>user_id</td>
    <td><%= tag.user_id %></td>
  </tr>
</table>
<br/>
<a href="<%= page:make_url('tag/index') %>"><- Back to View All</a>
