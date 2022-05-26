<h2>
	View user #<%= user.id %>
	<small>(<a href="<%= page:make_url('user/update', {id = user.id} ) %>" >update</a>)</small>
	<small>(<a href="<%= page:make_url('user/delete', {id = user.id} ) %>" >delete</a>)</small>
</h2>
<table class="table">
	<tr><td>id</td><td><%= user.id %> </td></tr>
	<tr><td>username</td><td><%= user.username %> </td></tr>
	<tr><td>role_id</td><td><%= user.role_id %> </td></tr>
	<tr><td>password</td><td><%= user.password %> </td></tr>
</table>
<br/>
<a href="<%= page:make_url('user/index') %>"><- Back to View All</a>
