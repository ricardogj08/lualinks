<?lua local form = require "sailor.form" ?>
<h2>Update user</h2>
<?lua if saved == false then ?>
  There was an error while saving.
<?lua end ?>
<form method="post">
  <div class="form-group">
    <label>id:</label>
    <%= form.text(user,'id', 'class="form-control" placeholder="id"') %>
  </div>
  <div class="form-group">
    <label>username:</label>
    <%= form.text(user,'username', 'class="form-control" placeholder="username"') %>
  </div>
  <div class="form-group">
    <label>role_id:</label>
    <%= form.text(user,'role_id', 'class="form-control" placeholder="role_id"') %>
  </div>
  <div class="form-group">
    <label>password:</label>
    <%= form.text(user,'password', 'class="form-control" placeholder="password"') %>
  </div>
  <input type="submit" class="btn btn-primary"/>
</form>
<br/>
<a href="<%= page:make_url('user/index') %>"><- Back to View All</a>
